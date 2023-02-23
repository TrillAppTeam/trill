package main

import (
	"context"
	"fmt"
	"trill/src/utils"
	"trill/src/views"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

type Request = events.APIGatewayV2HTTPRequest
type Response = events.APIGatewayV2HTTPResponse

func handler(ctx context.Context, req Request) (Response, error) {
	switch req.RequestContext.HTTP.Method {
	case "GET":
		return read(ctx, req)
	default:
		err := fmt.Errorf("HTTP Method '%s' not allowed", req.RequestContext.HTTP.Method)
		return Response{StatusCode: 405, Body: err.Error()}, err
	}
}

func read(ctx context.Context, req Request) (Response, error) {
	token, err := utils.GetSpotifyToken()
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}

<<<<<<< HEAD
	albumID, ok := req.QueryStringParameters["ID"]
	if !ok {
		return Response{StatusCode: 500, Body: "Failed to parse ID", Headers: views.DefaultHeaders}, nil
=======
	albumID, ok := req.QueryStringParameters["albumID"]
	if !ok {
		return Response{StatusCode: 500, Body: "Failed to parse query", Headers: views.DefaultHeaders}, nil
>>>>>>> main
	}
	reqURL := fmt.Sprintf("https://api.spotify.com/v1/albums/%s", albumID)
	buf, err := utils.DoSpotifyRequest(token, reqURL)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}

	var spotifyAlbum views.SpotifyAlbum
	err = views.UnmarshalSpotifyAlbum(ctx, buf.Bytes(), &spotifyAlbum)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}

	body, err := views.MarshalSpotifyAlbum(ctx, &spotifyAlbum)
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
