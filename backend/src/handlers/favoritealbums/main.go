package main

import (
	"context"
	"fmt"
	"trill/src/models"
	"trill/src/utils"
	"trill/src/views"

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
	}
	ctx = context.WithValue(ctx, "db", db)

	switch req.RequestContext.HTTP.Method {
	case "POST":
		return create(ctx, req)
	case "GET":
		return read(ctx, req)
	case "DELETE":
		return delete(ctx, req)
	default:
		err := fmt.Errorf("HTTP Method '%s' not allowed", req.RequestContext.HTTP.Method)
		return Response{StatusCode: 405, Body: err.Error()}, err
	}
}

// User adds an album to their favorite albums. Only allows users to add an album if they have < 4 albums currently in their favorites.
func create(ctx context.Context, req Request) (Response, error) {
	insertRecord := models.FavoriteAlbum{}
	err := views.UnmarshalFavoriteAlbum(ctx, req.Body, &insertRecord)
	if err != nil {
		return Response{StatusCode: 400, Body: "Invalid request data format"}, err
	}

	username, ok := req.RequestContext.Authorizer.Lambda["username"].(string)
	if !ok {
		return Response{StatusCode: 500, Body: "failed to parse username", Headers: views.DefaultHeaders}, nil
	}

	// Only allow users to add an album if they have less than 4 albums currently in their favorites
	favoriteAlbums, err := models.GetFavoriteAlbums(ctx, username)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}

	if len(*favoriteAlbums) >= 4 {
		return Response{StatusCode: 400, Body: "user already has 4 albums", Headers: views.DefaultHeaders}, err
	}

	err = models.CreateFavoriteAlbum(ctx, &insertRecord)
	if err != nil {
		return Response{StatusCode: 500, Body: "Error inserting data into database"}, err
	}

	return Response{
		StatusCode: 201,
		Body:       "Successfully added to database",
		Headers:    views.DefaultHeaders,
	}, nil
}

// Gets the user's favorite albums
// @PARAMS - username (string)
func read(ctx context.Context, req Request) (Response, error) {
	token, err := utils.GetSpotifyToken()
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}

	// Get the username from the request params
	username, ok := req.QueryStringParameters["username"]
	if !ok {
		return Response{StatusCode: 500, Body: "Failed to parse username"}, nil
	}

	favoriteAlbums, err := models.GetFavoriteAlbums(ctx, username)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}

	if len(*favoriteAlbums) == 0 {
		return Response{StatusCode: 200, Body: ""}, nil
	}

	albumInfos := make([]views.SpotifyAlbum, len(*favoriteAlbums))
	for i, f := range *favoriteAlbums {
		reqURL := fmt.Sprintf("https://api.spotify.com/v1/albums/%s", f.AlbumID)
		buf, err := utils.DoSpotifyRequest(token, reqURL)
		if err != nil {
			return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
		}

		var spotifyAlbum views.SpotifyAlbum
		spotifyErrorResponse := views.UnmarshalSpotifyAlbum(ctx, buf.Bytes(), &spotifyAlbum)
		if spotifyErrorResponse != nil {
			spotifyError := spotifyErrorResponse.Error
			return Response{
				StatusCode: spotifyError.Status,
				Body:       "Spotify request error: " + spotifyError.Message,
				Headers:    views.DefaultHeaders,
			}, nil
		}

		albumInfos[i] = spotifyAlbum
	}

	body, err := views.MarshalSpotifyAlbums(ctx, &albumInfos)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}

	return Response{StatusCode: 200, Body: body, Headers: views.DefaultHeaders}, nil
}

// Deletes an album from a user's favorite albums
func delete(ctx context.Context, req Request) (Response, error) {
	// Get the username from the request params
	username, ok := req.QueryStringParameters["username"]
	if !ok {
		return Response{StatusCode: 500, Body: "Failed to parse username"}, nil
	}

	favoriteAlbum := models.FavoriteAlbum{}
	if err := views.UnmarshalFavoriteAlbum(ctx, req.Body, &favoriteAlbum); err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}
	favoriteAlbum.Username = username

	if err := models.DeleteFavoriteAlbum(ctx, &favoriteAlbum); err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}

	return Response{
		StatusCode: 200,
		Body:       "Successfully removed from database",
		Headers:    views.DefaultHeaders,
	}, nil
}

func main() {
	lambda.Start(handler)
}
