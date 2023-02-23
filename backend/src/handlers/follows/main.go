package main

import (
	"context"
	"fmt"
	"trill/src/models"
	"trill/src/views"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

type Request events.APIGatewayV2HTTPRequest
type Response events.APIGatewayV2HTTPResponse

func handler(ctx context.Context, req events.APIGatewayV2HTTPRequest) (Response, error) {
	switch req.RequestContext.HTTP.Method {
	case "POST":
		return create(ctx, req)
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
		return delete(ctx, req)
	default:
		err := fmt.Errorf("HTTP Method '%s' not allowed", req.RequestContext.HTTP.Method)
		return Response{StatusCode: 405, Body: err.Error()}, err
	}
}

// Create a follow relationship
// @PARAMS are in the JSON body : "followee" and "following"
func create(ctx context.Context, req events.APIGatewayV2HTTPRequest) (Response, error) {
	// TO DO: Update database to be uuid instead of username, reflect here
	// Unmarshal JSON request body into a Follows struct

	follows := models.Follows{}
	if err := views.UnmarshalFollows(ctx, req.Body, &follows); err != nil {
		return Response{StatusCode: 400, Body: "invalid request data format", Headers: views.DefaultHeaders}, nil
	} else if err := models.CreateFollows(ctx, &follows); err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}

	return Response{
		StatusCode: 201,
		Body:       "Successfully added to database",
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

<<<<<<< HEAD
	body, err := views.MarshalFollows(ctx, following)
=======
	body, err := views.MarshalFollowing(ctx, following)
>>>>>>> main
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
// Currently returns in this format: [{"Followee":"avwede","Following":"csmi"},{"Followee":"avwede","Following":"dmflo"}]
func getFollowers(ctx context.Context, req events.APIGatewayV2HTTPRequest) (Response, error) {
	followee, ok := req.QueryStringParameters["username"]
	if !ok {
		return Response{StatusCode: 500, Body: "failed to parse username", Headers: views.DefaultHeaders}, nil
	}

	followers, err := models.GetFollowers(ctx, followee)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}

<<<<<<< HEAD
	body, err := views.MarshalFollows(ctx, followers)
=======
	body, err := views.MarshalFollowers(ctx, followers)
>>>>>>> main
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
// @PARAMS are in the JSON body : "followee" and "following"
// Currently returns in this format: [{"Followee":"csmi","Following":"avwede"}]
// TODO ensure followee == username
func delete(ctx context.Context, req events.APIGatewayV2HTTPRequest) (Response, error) {
	follows := models.Follows{}
	if err := views.UnmarshalFollows(ctx, req.Body, &follows); err != nil {
		return Response{StatusCode: 400, Body: "invalid request data format", Headers: views.DefaultHeaders}, nil
	} else if err := models.DeleteFollows(ctx, follows.Followee, follows.Following); err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}

	return Response{
		StatusCode: 201,
		Body:       "Successfully removed from database",
	}, nil
}

func main() {
	lambda.Start(handler)
}
