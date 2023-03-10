package main

import (
	"context"
	"fmt"
	"strconv"
	"trill/src/handlers"
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
		s, ok := req.QueryStringParameters["search"]
		trySearch, _ := strconv.ParseBool(s)
		if ok && trySearch {
			return search(initCtx, req)
		}
		return getPopular(initCtx, req)
	default:
		err := fmt.Errorf("HTTP Method '%s' not allowed", req.RequestContext.HTTP.Method)
		return Response{StatusCode: 405, Body: err.Error()}, err
	}
}

func getPopular(ctx context.Context, req Request) (Response, error) {
	query := "foobie"
	apiURL := "https://api.spotify.com/v1/albums?ids=%s"
	return doSpotifyAlbumRequest(ctx, apiURL, query), nil
}

// GET: Returns album info
func search(ctx context.Context, req Request) (Response, error) {
	query, ok := req.QueryStringParameters["query"]
	if !ok {
		return Response{StatusCode: 500, Body: "Failed to parse query", Headers: views.DefaultHeaders}, nil
	}
	apiURL := "https://api.spotify.com/v1/search?q=%s&type=album"

	return doSpotifyAlbumRequest(ctx, apiURL, query), nil
}

func doSpotifyAlbumRequest(ctx context.Context, apiURL string, query string) Response {
	token, err := utils.GetSpotifyToken()
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}
	}

	encodedQuery := url.QueryEscape(query)
	reqURL := fmt.Sprintf(apiURL, encodedQuery)
	buf, err := utils.DoSpotifyRequest(token, reqURL)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}
	}

	var spotifyAlbums views.SpotifyAlbums
	spotifyErrorResponse := views.UnmarshalSpotifyAlbums(ctx, buf.Bytes(), &spotifyAlbums)
	if spotifyErrorResponse != nil {
		spotifyError := spotifyErrorResponse.Error
		return Response{
			StatusCode: spotifyError.Status,
			Body:       "Spotify request error: " + spotifyError.Message,
			Headers:    views.DefaultHeaders,
		}
	}

	body, err := views.MarshalSpotifyAlbums(ctx, &spotifyAlbums.Albums.Items)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}
	}

	return Response{
		StatusCode: 200,
		Body:       body,
		Headers:    views.DefaultHeaders,
	}
}

func main() {
	lambda.Start(handler)
}
