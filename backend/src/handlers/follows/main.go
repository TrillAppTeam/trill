package main

import (
	"context"
	"fmt"
	"trill/src/models"
	"trill/src/views"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"gorm.io/gorm"
)

type Request events.APIGatewayV2HTTPRequest
type Response events.APIGatewayV2HTTPResponse

var db *gorm.DB

func handler(ctx context.Context, req events.APIGatewayV2HTTPRequest) (Response, error) {
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
		return follow(ctx, req)
	case "GET":
		if req.QueryStringParameters["type"] == "getFollowers" {
			return getFollowers(ctx, req)
		} else if req.QueryStringParameters["type"] == "getFollowing" {
			return getFollowing(ctx, req)
		} else {
			err := fmt.Errorf("invalid 'type' parameter for GET method")
			return Response{StatusCode: 400, Body: err.Error()}, err
		}
	case "DELETE":
		return unfollow(ctx, req)
	default:
		err := fmt.Errorf("HTTP Method '%s' not allowed", req.RequestContext.HTTP.Method)
		return Response{StatusCode: 405, Body: err.Error()}, err
	}
}

// Create a follow relationship
// POST - /follows?username=avwede
func follow(ctx context.Context, req events.APIGatewayV2HTTPRequest) (Response, error) {
	username, ok := req.RequestContext.Authorizer.Lambda["username"].(string)
	if !ok {
		return Response{StatusCode: 500, Body: "Failed to get current user", Headers: views.DefaultHeaders}, nil
	}

	// Get the username from the request params
	userToFollow, ok := req.QueryStringParameters["username"]
	if !ok {
		return Response{StatusCode: 500, Body: "Failed to parse username", Headers: views.DefaultHeaders}, nil
	}

	if username == userToFollow {
		return Response{StatusCode: 500, Body: "User cannot follow themselves", Headers: views.DefaultHeaders}, nil
	}

	follow := models.Follows{
		Followee:  username,
		Following: userToFollow,
	}

	if err := models.CreateFollow(ctx, &follow); err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}

	return Response{
		StatusCode: 201,
		Body:       "Successfully added to database",
		Headers:    views.DefaultHeaders,
	}, nil
}

// Get Following
// @PARAMS are QueryStringParameters : "username"
// Postman: follows?type=getFollowing&username=avwede
func getFollowing(ctx context.Context, req events.APIGatewayV2HTTPRequest) (Response, error) {
	followee, ok := req.QueryStringParameters["username"]
	if !ok {
		return Response{StatusCode: 500, Body: "failed to parse username", Headers: views.DefaultHeaders}, nil
	}

	following, err := models.GetFollowing(ctx, followee)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}

	body, err := views.MarshalUsers(ctx, following)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}

	return Response{
		StatusCode: 200,
		Body:       body,
		Headers:    views.DefaultHeaders,
	}, nil
}

// Get Followers
// @PARAMS are QueryStringParameters : "username"
// Postman: follows?type=getFollowers&username=avwede
func getFollowers(ctx context.Context, req events.APIGatewayV2HTTPRequest) (Response, error) {
	followee, ok := req.QueryStringParameters["username"]
	if !ok {
		return Response{StatusCode: 500, Body: "failed to parse username", Headers: views.DefaultHeaders}, nil
	}

	followers, err := models.GetFollowers(ctx, followee)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}

	body, err := views.MarshalUsers(ctx, followers)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}

	return Response{
		StatusCode: 200,
		Body:       body,
		Headers:    views.DefaultHeaders,
	}, nil
}

// User unfollows someone
// DELETE - /follows?username=avwede
// assuming followee follows the following idk my brain hurts i took a 3 hour nap
func unfollow(ctx context.Context, req events.APIGatewayV2HTTPRequest) (Response, error) {
	username, ok := req.RequestContext.Authorizer.Lambda["username"].(string)
	if !ok {
		return Response{StatusCode: 500, Body: "Failed to get current user", Headers: views.DefaultHeaders}, nil
	}

	// Get the username from the request params
	userToUnfollow, ok := req.QueryStringParameters["username"]
	if !ok {
		return Response{StatusCode: 500, Body: "Failed to parse username", Headers: views.DefaultHeaders}, nil
	}

	if username == userToUnfollow {
		return Response{StatusCode: 500, Body: "User cannot unfollow themselves", Headers: views.DefaultHeaders}, nil
	}

	follow := models.Follows{
		Followee:  username,
		Following: userToUnfollow,
	}

	if err := models.DeleteFollow(ctx, &follow); err != nil {
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
