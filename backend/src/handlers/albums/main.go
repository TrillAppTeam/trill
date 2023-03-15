package main

import (
	"context"
	"errors"
	"fmt"
	"strings"
	"trill/src/handlers"
	"trill/src/models"
	"trill/src/utils"
	"trill/src/views"

	"github.com/aws/aws-lambda-go/lambda"
	"gorm.io/gorm"
)

type Request = handlers.Request
type Response = handlers.Response

var (
	ErrorTimespanParse error = errors.New("empty timespan parameter")
	ErrorTimespan      error = errors.New("invalid value for timespan")
	ErrorUsername      error = errors.New("failed to parse username")
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
		if _, ok := req.QueryStringParameters["query"]; ok {
			return search(initCtx, req)
		} else if _, ok := req.QueryStringParameters["albumID"]; ok {
			return get(initCtx, req)
		}
		return getPopular(initCtx, req)
	default:
		err := fmt.Errorf("HTTP Method '%s' not allowed", req.RequestContext.HTTP.Method)
		return Response{StatusCode: 405, Body: err.Error()}, nil
	}
}

func get(ctx context.Context, req Request) (Response, error) {
	albumID, ok := req.QueryStringParameters["albumID"]
	if !ok {
		return Response{StatusCode: 500, Body: "Failed to parse query", Headers: views.DefaultHeaders}, nil
	}

	requestor, ok := req.RequestContext.Authorizer.Lambda["username"].(string)
	if !ok {
		return Response{
			StatusCode: 500,
			Body:       fmt.Sprint(ErrorUsername.Error()),
			Headers:    views.DefaultHeaders,
		}, nil
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

	reviewStats, err := models.GetReviewStats(ctx, album.ID, requestor)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}

	requestorFavorited, err := models.IsFavorited(ctx, albumID, requestor)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}

	inListenLater, err := models.InListenLater(ctx, albumID, requestor)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}

	body, err := views.MarshalDetailedAlbum(ctx, album, *reviewStats, requestorFavorited, inListenLater)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}

	return Response{StatusCode: 200, Body: body, Headers: views.DefaultHeaders}, nil
}

func getPopular(ctx context.Context, req Request) (Response, error) {
	timespan, ok := req.QueryStringParameters["timespan"]
	if !ok {
		return Response{StatusCode: 400, Body: ErrorTimespanParse.Error(), Headers: views.DefaultHeaders}, nil
	}

	switch timespan {
	case
		"daily",
		"weekly",
		"monthly",
		"yearly",
		"all":
		break
	default:
		return Response{StatusCode: 400, Body: ErrorTimespan.Error(), Headers: views.DefaultHeaders}, nil
	}

	albumIDs, err := models.GetPopularAlbumsFromReviews(ctx, timespan)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	} else if len(*albumIDs) == 0 {
		return Response{StatusCode: 204, Headers: views.DefaultHeaders}, nil
	}

	query := strings.Join(*albumIDs, ",")
	buf, err := utils.DoSpotifyRequest(ctx, utils.AlbumsAPIURL, query)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}

	// return Response{StatusCode: 200, Body: string(buf), Headers: views.DefaultHeaders}, nil
	return handlers.GenerateResponseFromSpotifyBody(ctx, buf, &views.SpotifyAlbums{}), nil
}

// GET: Returns album info
func search(ctx context.Context, req Request) (Response, error) {
	query, ok := req.QueryStringParameters["query"]
	if !ok {
		return Response{StatusCode: 500, Body: "Failed to parse query", Headers: views.DefaultHeaders}, nil
	}
	buf, err := utils.DoSpotifyRequest(ctx, utils.AlbumSearchAPIURL, query)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}

	return handlers.GenerateResponseFromSpotifyBody(ctx, buf, &views.SpotifyAlbumSearch{}), nil
}

func main() {
	lambda.Start(handler)
}
