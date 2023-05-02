package main

import (
	"context"
	"errors"
	"fmt"
	"strconv"
	"strings"
	"trill/src/handlers"
	"trill/src/models"
	"trill/src/utils"
	"trill/src/views"

	"gorm.io/gorm"

	"github.com/aws/aws-lambda-go/lambda"
)

type Request = handlers.Request
type Response = handlers.Response

var (
	ErrorAlbumID     error = errors.New("failed to parse album ID")
	ErrorUsername    error = errors.New("failed to parse username")
	ErrorRequestor   error = errors.New("failed to get requestor from token")
	ErrorSortInvalid error = errors.New("invalid sort parameter")
)

var db *gorm.DB

func handler(ctx context.Context, req Request) (Response, error) {
	var initCtx context.Context
	var err error
	initCtx, db, err = handlers.InitContext(ctx, db)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}

	switch req.RequestContext.HTTP.Method {
	case "GET":
		if _, ok := req.QueryStringParameters["sort"]; ok {
			return getReviews(initCtx, req)
		}
		return getReview(initCtx, req)
	case "PUT":
		return createOrUpdateReview(initCtx, req)
	case "DELETE":
		return deleteReview(initCtx, req)
	default:
		err := fmt.Errorf("HTTP Method '%s' not allowed", req.RequestContext.HTTP.Method)
		return Response{StatusCode: 405, Body: err.Error(), Headers: views.DefaultHeaders}, err
	}
}

func getReview(ctx context.Context, req Request) (Response, error) {
	requestor, ok := req.RequestContext.Authorizer.Lambda["username"].(string)
	if !ok {
		return Response{
			StatusCode: 500,
			Body:       fmt.Sprintf(ErrorRequestor.Error()),
			Headers:    views.DefaultHeaders,
		}, nil
	}

	reviewerUsername, queryOK := req.QueryStringParameters["username"]
	if !queryOK {
		reviewerUsername = requestor
	}

	albumID, ok := req.QueryStringParameters["albumID"]
	if !ok {
		return Response{StatusCode: 500, Body: ErrorAlbumID.Error(), Headers: views.DefaultHeaders}, nil
	}

	review, err := models.GetReview(ctx, reviewerUsername, albumID)
	if err == models.ErrorReviewNotFound {
		return Response{StatusCode: 404, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	} else if err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	} else if review == nil {
		return Response{StatusCode: 204, Headers: views.DefaultHeaders}, nil
	}

	buf, err := utils.DoSpotifyRequest(ctx, utils.AlbumAPIURL, albumID)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}
	var album views.SpotifyAlbum
	resp := handlers.UnmarshalSpotify(ctx, buf, &album)
	if resp != nil {
		return *resp, nil
	}

	body, err := views.MarshalReview(ctx, review, requestor, &album)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}

	return Response{StatusCode: 200, Body: body, Headers: views.DefaultHeaders}, nil
}

func getReviews(ctx context.Context, req Request) (Response, error) {
	requestor, ok := req.RequestContext.Authorizer.Lambda["username"].(string)
	if !ok {
		return Response{StatusCode: 500, Body: ErrorRequestor.Error(), Headers: views.DefaultHeaders}, nil
	}

	username, hasUserParam := req.QueryStringParameters["username"]
	albumID, hasAlbumParam := req.QueryStringParameters["albumID"]

	followingRaw := req.QueryStringParameters["following"]
	following, _ := strconv.ParseBool(followingRaw)

	likesRaw := req.QueryStringParameters["likes"]
	likes, _ := strconv.ParseBool(likesRaw)

	paginate, err := handlers.GetPaginateFromRequest(ctx, req)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}

	reviewQuery := models.Review{
		Username: func() string {
			if hasUserParam {
				return username
			}
			return requestor
		}(),
		AlbumID: albumID,
	}

	var users *[]models.User = nil
	if following {
		var err error
		users, err = models.GetFollowing(ctx, requestor)
		if err != nil {
			return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
		}
	}

	var likedReviews *[]models.Like = nil
	if likes {
		var err error
		likedReviews, err = models.GetLikesFromUser(ctx, requestor)
		if err != nil {
			return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
		}
	}

	var reviews *[]models.Review
	switch paginate.Sort {
	case
		"newest",
		"oldest",
		"popular":
		reviews, err = models.GetReviews(ctx, &reviewQuery, users, likedReviews, paginate)
		if err != nil {
			return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
		}
	default:
		return Response{StatusCode: 400, Body: ErrorSortInvalid.Error(), Headers: views.DefaultHeaders}, nil
	}

	var albums *views.SpotifyAlbums = nil
	if !hasAlbumParam {
		albumIDs := make([]string, len(*reviews))
		for i, r := range *reviews {
			albumIDs[i] = r.AlbumID
		}
		query := strings.Join(albumIDs, ",")
		buf, err := utils.DoSpotifyRequest(ctx, utils.AlbumsAPIURL, query)
		if err != nil {
			return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
		}

		albums = new(views.SpotifyAlbums)
		if resp := handlers.UnmarshalSpotify(ctx, buf, albums); resp != nil {
			return *resp, nil
		}
	}

	body, err := views.MarshalReviews(ctx, reviews, requestor, albums)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}

	return Response{StatusCode: 200, Body: body, Headers: views.DefaultHeaders}, nil
}

// Given the username and album ID in request body, if the review exists, update it
// Otherwise, create a new review in the database
// Note: Currently, updating a review in the database will update its review date to the current timestamp
// Postman: PUT - /reviews
func createOrUpdateReview(ctx context.Context, req Request) (Response, error) {
	var review models.Review
	if err := views.UnmarshalReview(ctx, req.Body, &review); err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}

	requestor, ok := req.RequestContext.Authorizer.Lambda["username"].(string)
	if !ok {
		return Response{StatusCode: 500, Body: ErrorRequestor.Error(), Headers: views.DefaultHeaders}, nil
	}
	albumID, ok := req.QueryStringParameters["albumID"]
	if !ok {
		return Response{StatusCode: 500, Body: ErrorAlbumID.Error(), Headers: views.DefaultHeaders}, nil
	}
	review.Username = requestor
	review.AlbumID = albumID

	if err := models.CreateReview(ctx, &review); err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}

	deleteRecord := models.ListenLaterAlbum{
		Username: requestor,
		AlbumID:  albumID,
	}
	if err := models.DeleteListenLaterAlbum(ctx, &deleteRecord); err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}

	return Response{
		StatusCode: 201,
		Body: fmt.Sprintf("Successfully added/updated review for album %s from %s in database.",
			review.AlbumID, review.Username),
		Headers: views.DefaultHeaders,
	}, nil
}

// User deletes a review for a specific albumID
// Postman: DELETE - /reviews
func deleteReview(ctx context.Context, req Request) (Response, error) {
	requestor, ok := req.RequestContext.Authorizer.Lambda["username"].(string)
	if !ok {
		return Response{StatusCode: 500, Body: ErrorRequestor.Error(), Headers: views.DefaultHeaders}, nil
	}
	albumID, ok := req.QueryStringParameters["albumID"]
	if !ok {
		return Response{StatusCode: 500, Body: ErrorAlbumID.Error(), Headers: views.DefaultHeaders}, nil
	}

	review := models.Review{
		Username: requestor,
		AlbumID:  albumID,
	}

	// Delete the requested Review from the database
	if err := models.DeleteReview(ctx, &review); err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}

	return Response{
		StatusCode: 200,
		Body: fmt.Sprintf("Successfully removed review to album %s by %s from database.",
			review.AlbumID, review.Username),
		Headers: views.DefaultHeaders,
	}, nil
}

func main() {
	lambda.Start(handler)
}
