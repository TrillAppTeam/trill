package main

import (
	"context"
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

var db *gorm.DB

func handler(ctx context.Context, req Request) (Response, error) {
	initCtx, err := handlers.InitContext(ctx, db)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}

	switch req.RequestContext.HTTP.Method {
	case "POST":
		return create(initCtx, req)
	case "GET":
		return get(initCtx, req)
	case "DELETE":
		return delete(initCtx, req)
	default:
		err := fmt.Errorf("HTTP Method '%s' not allowed", req.RequestContext.HTTP.Method)
		return Response{StatusCode: 405, Body: err.Error()}, err
	}
}

// User adds an album to their favorite albums. Only allows users to add an album if they have < 4 albums currently in their favorites.
func create(ctx context.Context, req Request) (Response, error) {
	username, ok := req.RequestContext.Authorizer.Lambda["username"].(string)
	if !ok {
		return Response{StatusCode: 500, Body: "failed to parse username", Headers: views.DefaultHeaders}, nil
	}

	albumID, ok := req.QueryStringParameters["albumID"]
	if !ok {
		return Response{StatusCode: 500, Body: "Failed to parse album ID", Headers: views.DefaultHeaders}, nil
	}

	insertRecord := models.FavoriteAlbum{
		Username: username,
		AlbumID:  albumID,
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
func get(ctx context.Context, req Request) (Response, error) {
	username, ok := req.QueryStringParameters["username"]
	if !ok {
		return Response{StatusCode: 500, Body: "Failed to parse username"}, nil
	}

	favoriteAlbums, err := models.GetFavoriteAlbums(ctx, username)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}

	if len(*favoriteAlbums) == 0 {
		return Response{StatusCode: 204, Headers: views.DefaultHeaders}, nil
	}

	albumIDs := make([]string, len(*favoriteAlbums))
	for i, a := range *favoriteAlbums {
		albumIDs[i] = a.AlbumID
	}
	query := strings.Join(albumIDs, ",")
	buf, err := utils.DoSpotifyRequest(ctx, utils.AlbumsAPIURL, query)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}

	return handlers.GenerateResponseFromSpotifyBody(ctx, buf, &views.SpotifyAlbums{}), nil
}

// Deletes an album from a user's favorite albums
func delete(ctx context.Context, req Request) (Response, error) {
	username, ok := req.RequestContext.Authorizer.Lambda["username"].(string)
	if !ok {
		return Response{StatusCode: 500, Body: "failed to parse username", Headers: views.DefaultHeaders}, nil
	}

	albumID, ok := req.QueryStringParameters["albumID"]
	if !ok {
		return Response{StatusCode: 500, Body: "Failed to parse album ID", Headers: views.DefaultHeaders}, nil
	}

	deleteRecord := models.FavoriteAlbum{
		Username: username,
		AlbumID:  albumID,
	}

	if err := models.DeleteFavoriteAlbum(ctx, &deleteRecord); err != nil {
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
