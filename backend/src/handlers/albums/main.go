package main

import (
	"context"
	"fmt"
	"trill/src/models"
	"trill/src/utils"
	"trill/src/views"

	"net/url"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"gorm.io/gorm"
)

type Request = events.APIGatewayV2HTTPRequest
type Response = events.APIGatewayV2HTTPResponse

var db *gorm.DB

func handler(ctx context.Context, req Request) (Response, error) {
	if db == nil {
		var err error
		db, err = models.ConnectDB()
		if err != nil {
			return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
		}
		ctx = context.WithValue(ctx, "db", db)
	}

	switch req.RequestContext.HTTP.Method {
	case "GET":
		return read(ctx, req)
	default:
		err := fmt.Errorf("HTTP Method '%s' not allowed", req.RequestContext.HTTP.Method)
		return Response{StatusCode: 405, Body: err.Error()}, err
	}
}

// GET: Returns album info
func read(ctx context.Context, req Request) (Response, error) {
	token, err := utils.GetSpotifyToken()
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}

	query, ok := req.QueryStringParameters["query"]
	if !ok {
		return Response{StatusCode: 500, Body: "Failed to parse query", Headers: views.DefaultHeaders}, nil
	}
	encodedQuery := url.QueryEscape(query)
	reqURL := fmt.Sprintf("https://api.spotify.com/v1/search?q=%s&type=album", encodedQuery)
	buf, err := utils.DoSpotifyRequest(token, reqURL)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}

	var spotifyAlbums views.SpotifyAlbums
	spotifyErrorResponse := views.UnmarshalSpotifyAlbums(ctx, buf.Bytes(), &spotifyAlbums)
	if spotifyErrorResponse != nil {
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

	return Response{
		StatusCode: 200,
		Body:       body,
		Headers:    views.DefaultHeaders,
	}, nil
}

func main() {
	lambda.Start(handler)
}
