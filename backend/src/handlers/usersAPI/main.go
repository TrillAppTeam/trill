package main

import (
	"context"
	"fmt"
	"strings"
	"trill/src/models"
	"trill/src/views"

	"encoding/json"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

type Request = events.APIGatewayV2HTTPRequest
type Response = events.APIGatewayV2HTTPResponse

func handler(ctx context.Context, req Request) (Response, error) {
	switch req.RequestContext.HTTP.Method {
	case "GET":
		return read(ctx, req)
	case "PUT":
		return update(req)
	default:
		err := fmt.Errorf("HTTP method '%s' not allowed", req.RequestContext.HTTP.Method)
		return Response{StatusCode: 405, Body: err.Error()}, nil
	}
}

// GET: Returns user info
func read(ctx context.Context, req Request) (Response, error) {
	username, ok := req.RequestContext.Authorizer.Lambda["username"].(string)
	if !ok {
		return Response{StatusCode: 500, Body: "failed to parse username"}, nil
	}
	authToken := strings.Split((req.Headers["authorization"]), " ")[1]

	user, err := models.GetUser(ctx, username)
	if err != nil { // TODO: Better error handling
		return Response{StatusCode: 500, Body: err.Error()}, nil
	}
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
		Headers: map[string]string{
			"Content-Type": "application/json",
		},
	}, nil
}

func update(req Request) (Response, error) {
	db, err := connectDB()
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, err
	}

	username, ok := req.RequestContext.Authorizer.Lambda["username"].(string)
	if !ok {
		return Response{StatusCode: 500, Body: "failed to parse username"}, nil
	}

	var user User
	result := db.Where("username = ?", username).First(&user)
	if result.Error != nil {
		return Response{StatusCode: 404, Body: "user not found"}, nil
	}

	// put changes into new user struct
	err = json.Unmarshal([]byte(req.Body), &user)
	if err != nil {
		return Response{StatusCode: 400, Body: "invalid request body"}, nil
	}

	// update user in the database
	updatedUser := db.Save(&user)
	if updatedUser.Error != nil {
		return Response{StatusCode: 500, Body: updatedUser.Error.Error()}, nil
	}

	return Response{StatusCode: 200, Body: "user updated successfully"}, nil
}

func main() {
	lambda.Start(handler)
}
