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
)

var db *gorm.DB

func handler(ctx context.Context, req Request) (Response, error) {
	initCtx, err := handlers.InitContext(ctx, db)
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
	apiURL := "https://api.spotify.com/v1/albums/%s"
	buf, err := utils.DoSpotifyRequest(ctx, apiURL, albumID)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}

	return handlers.GenerateResponseFromSpotifyBody(ctx, buf, &views.SpotifyAlbum{}, views.Marshal), nil
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
	}
	query := strings.Join(*albumIDs, ",")
	apiURL := "https://api.spotify.com/v1/albums?ids=%s"
	buf, err := utils.DoSpotifyRequest(ctx, apiURL, query)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}

	albums := make([]views.SpotifyAlbum, len(*albumIDs))
	fmt.Printf("%+v\n", buf)
	return handlers.GenerateResponseFromSpotifyBody(ctx, buf, &albums, views.Marshal), nil
}

// GET: Returns album info
func search(ctx context.Context, req Request) (Response, error) {
	query, ok := req.QueryStringParameters["query"]
	if !ok {
		return Response{StatusCode: 500, Body: "Failed to parse query", Headers: views.DefaultHeaders}, nil
	}
	apiURL := "https://api.spotify.com/v1/search?q=%s&type=album"
	buf, err := utils.DoSpotifyRequest(ctx, apiURL, query)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}

	return handlers.GenerateResponseFromSpotifyBody(ctx, buf, &views.SpotifyAlbums{}, views.MarshalSpotifyAlbums), nil
}

func main() {
	lambda.Start(handler)
}
