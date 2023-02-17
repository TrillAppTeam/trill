package main

import (
	"context"
	"fmt"
	"strings"
	"trill/src/models"
	"trill/src/views"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

type Request = events.APIGatewayV2HTTPRequest
type Response = events.APIGatewayV2HTTPResponse

func handler(ctx context.Context, req Request) (Response, error) {
	switch req.RequestContext.HTTP.Method {
	case "GET":
		return get(ctx, req)
	case "PUT":
		return update(ctx, req)
	default:
		err := fmt.Errorf("HTTP method '%s' not allowed", req.RequestContext.HTTP.Method)
		return Response{StatusCode: 405, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}
}

// GET: Returns user info
func get(ctx context.Context, req Request) (Response, error) {
	username, ok := req.RequestContext.Authorizer.Lambda["username"].(string)
	if !ok {
		return Response{StatusCode: 500, Body: "failed to parse username"}, nil
	}
	user, err := models.GetUser(ctx, username)
	if err != nil { // TODO: Better error handling
		return Response{StatusCode: 500, Body: err.Error()}, nil
	}

	authToken := strings.Split((req.Headers["authorization"]), " ")[1]
	cognitoUser, err := models.GetCognitoUser(ctx, authToken)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, nil
	}

	body, err := views.MarshalUser(ctx, user, cognitoUser)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, nil
	}

	return Response{
		StatusCode: 200,
		Body:       body,
		Headers:    views.DefaultHeaders,
	}, nil
}

func update(ctx context.Context, req Request) (Response, error) {
	username, ok := req.RequestContext.Authorizer.Lambda["username"].(string)
	if !ok {
		return Response{StatusCode: 500, Body: "failed to parse username", Headers: views.DefaultHeaders}, nil
	}

	user, err := models.GetUser(ctx, username)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}

	if err = views.UnmarshalUser(ctx, req.Body, user); err != nil {
		return Response{StatusCode: 400, Body: fmt.Sprintf("invalid request body: %s, %s", err.Error(), req.Body), Headers: views.DefaultHeaders}, nil
	} else if err = models.UpdateUser(ctx, user); err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}

	return Response{StatusCode: 200, Body: "user updated successfully", Headers: views.DefaultHeaders}, nil
}

func main() {
	lambda.Start(handler)
}
