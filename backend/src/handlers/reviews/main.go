package main

import (
	"context"
	"errors"
	"fmt"
	"trill/src/models"
	"trill/src/views"

	"gorm.io/gorm"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

type Request = events.APIGatewayV2HTTPRequest
type Response = events.APIGatewayV2HTTPResponse

var (
	ErrorAlbumID     error = errors.New("failed to parse album ID")
	ErrorUsername    error = errors.New("failed to parse username")
	ErrorRequestor   error = errors.New("failed to get requestor from token")
	ErrorSort        error = errors.New("failed to parse sort")
	ErrorSortInvalid error = errors.New("invalid sort parameter")
)

var db *gorm.DB

func handler(ctx context.Context, req Request) (Response, error) {
	if db == nil {
		var err error
		db, err = models.ConnectDB()
		if err != nil {
			return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
		}
	}
	ctx = context.WithValue(ctx, "db", db)

	switch req.RequestContext.HTTP.Method {
	case "GET":
		_, ok := req.QueryStringParameters["username"]
		if ok {
			return getUserReview(ctx, req)
		} else {
			return getReviews(ctx, req)
		}
	case "PUT":
		return createOrUpdateReview(ctx, req)
	case "DELETE":
		return deleteReview(ctx, req)
	default:
		err := fmt.Errorf("HTTP Method '%s' not allowed", req.RequestContext.HTTP.Method)
		return Response{StatusCode: 405, Body: err.Error()}, err
	}
}

// Given a username and album ID, get the review
// If review does not exist, return 204 status code
// @PARAMS are QueryStringParameters: "username" & "album_id"
// Postman: GET - /reviews?username={username}&album_id={album_id}
func getUserReview(ctx context.Context, req Request) (Response, error) {
	username, ok := req.QueryStringParameters["username"]
	if !ok {
		return Response{StatusCode: 500, Body: ErrorUsername.Error(), Headers: views.DefaultHeaders}, nil
	}
	albumID, ok := req.QueryStringParameters["albumID"]
	if !ok {
		return Response{StatusCode: 500, Body: ErrorAlbumID.Error(), Headers: views.DefaultHeaders}, nil
	}

	review, err := models.GetReview(ctx, username, albumID)
	if err == models.ErrorReviewNotFound {
		return Response{StatusCode: 404, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	} else if err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}
	if review == nil {
		return Response{StatusCode: 204, Headers: views.DefaultHeaders}, nil
	}

	body, err := views.MarshalReview(ctx, review, username)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}

	return Response{StatusCode: 200, Body: body, Headers: views.DefaultHeaders}, nil

	// conrmad is distracting me
	// i came here to cause problems
	// me me mow me mow
	// can we leave these in here
	// there was microplastics in my lunch. nohting materrs. yes
	// my office room has no windows. my office rooms has no windows. my
	// yeah idk. when you see the "bin/(whatever handler you're editing)" line, that is the compilation command. once the next line appears its done
	// i believe you.
}

// Given an albumID, return a list of reviews associated with the albumID
// @PARAMS are QueryStringParameters: "sort" & "album_id"
// Postman: GET - /reviews?sort={popular|newest|oldest}&album_id={album_id}
func getReviews(ctx context.Context, req Request) (Response, error) {
	requestor, ok := req.RequestContext.Authorizer.Lambda["username"].(string)
	if !ok {
		return Response{StatusCode: 500, Body: ErrorRequestor.Error(), Headers: views.DefaultHeaders}, nil
	}
	albumID, ok := req.QueryStringParameters["albumID"]
	if !ok {
		return Response{StatusCode: 500, Body: ErrorAlbumID.Error(), Headers: views.DefaultHeaders}, nil
	}
	sort, ok := req.QueryStringParameters["sort"]
	if !ok {
		return Response{StatusCode: 500, Body: ErrorSort.Error(), Headers: views.DefaultHeaders}, nil
	}

	var reviews *[]models.Review
	var err error
	switch sort {
	case "newest":
		fallthrough
	case "oldest":
		fallthrough
	case "popular":
		reviews, err = models.GetReviews(ctx, albumID, sort)
		if err != nil {
			return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
		}
	default:
		return Response{StatusCode: 400, Body: ErrorSortInvalid.Error(), Headers: views.DefaultHeaders}, nil
	}

	reviewsInfos := make([]string, len(*reviews))
	for i, r := range *reviews {
		reviewsInfos[i], err = views.MarshalReview(ctx, &r, requestor)
		if err != nil {
			return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
		}
	}

	body, err := views.Marshal(ctx, reviewsInfos)
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
