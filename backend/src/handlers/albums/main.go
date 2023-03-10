package main

import (
	"context"
	"fmt"
	"strings"
	"trill/src/handlers"
	"trill/src/models"
	"trill/src/utils"
	"trill/src/views"

	"net/url"

	"github.com/aws/aws-lambda-go/lambda"
	"gorm.io/gorm"
)

type Request = handlers.Request
type Response = handlers.Response

var db *gorm.DB

func handler(ctx context.Context, req Request) (Response, error) {
	initCtx, err := handlers.InitContext(ctx, db)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}

	switch req.RequestContext.HTTP.Method {
	case "GET":
		_, ok := req.QueryStringParameters["query"]
		if ok {
			return search(initCtx, req)
		}
		return getPopular(initCtx, req)
	default:
		err := fmt.Errorf("HTTP Method '%s' not allowed", req.RequestContext.HTTP.Method)
		return Response{StatusCode: 405, Body: err.Error()}, nil
	}
}

func getPopular(ctx context.Context, req Request) (Response, error) {
	albumIDs, err := models.GetPopularAlbumsFromReviews(ctx)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}
	query := strings.Join(*albumIDs, ",")
	apiURL := "https://api.spotify.com/v1/albums?ids=%s"
	buf, err := doSpotifyAlbumRequest(ctx, apiURL, query)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}

	return Response{StatusCode: 200, Body: string(buf), Headers: views.DefaultHeaders}, nil
}

// GET: Returns album info
func search(ctx context.Context, req Request) (Response, error) {
	query, ok := req.QueryStringParameters["query"]
	if !ok {
		return Response{StatusCode: 500, Body: "Failed to parse query", Headers: views.DefaultHeaders}, nil
	}
	apiURL := "https://api.spotify.com/v1/search?q=%s&type=album"
	buf, err := doSpotifyAlbumRequest(ctx, apiURL, query)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}

	var spotifyAlbums views.SpotifyAlbums
	if spotifyErrorResponse := views.UnmarshalSpotifyAlbums(ctx, buf, &spotifyAlbums); spotifyErrorResponse != nil {
		spotifyError := spotifyErrorResponse.Error
		return Response{
			StatusCode: spotifyError.Status,
			Body:       "Spotify request error: " + spotifyError.Message,
			Headers:    views.DefaultHeaders,
		}, nil
	}
	body, err := views.MarshalSpotifyAlbums(ctx, &spotifyAlbums.Albums.Items)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}

	return Response{StatusCode: 200, Body: body, Headers: views.DefaultHeaders}, nil
}

func doSpotifyAlbumRequest(ctx context.Context, apiURL string, query string) ([]byte, error) {
	token, err := utils.GetSpotifyToken()
	if err != nil {
		return nil, err
	}

	encodedQuery := url.QueryEscape(query)
	reqURL := fmt.Sprintf(apiURL, encodedQuery)
	buf, err := utils.DoSpotifyRequest(token, reqURL)
	if err != nil {
		return nil, err
	}

	return buf.Bytes(), nil
}

func main() {
	lambda.Start(handler)
}
