package main

import (
	"context"
	"fmt"
	"strings"
	"trill/src/handlers"
	"trill/src/models"
	"trill/src/views"

	"github.com/aws/aws-lambda-go/lambda"
	"gorm.io/gorm"
)

type Request = handlers.Request
type Response = handlers.Response

var db *gorm.DB

func handler(ctx context.Context, req Request) (Response, error) {
	var initCtx context.Context
	var err error
	initCtx, db, err = handlers.InitContext(ctx, db)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}

	switch req.RequestContext.HTTP.Method {
	case "GET":
		if _, ok := req.QueryStringParameters["search"]; ok {
			return search(initCtx, req)
		} else {
			return get(initCtx, req)
		}
	case "PUT":
		return update(initCtx, req)
	default:
		err := fmt.Errorf("HTTP method '%s' not allowed", req.RequestContext.HTTP.Method)
		return Response{StatusCode: 405, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}
}

func search(ctx context.Context, req Request) (Response, error) {
	search := req.QueryStringParameters["search"]
	users, err := models.SearchUser(ctx, search)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}

	body, err := views.MarshalUsers(ctx, users)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}

	return Response{StatusCode: 200, Body: body, Headers: views.DefaultHeaders}, nil
}

func get(ctx context.Context, req Request) (Response, error) {
	requestor, ok := req.RequestContext.Authorizer.Lambda["username"].(string)
	if !ok {
		return Response{StatusCode: 500, Body: "failed to parse username", Headers: views.DefaultHeaders}, nil
	}

	var body, userToGet string
	username, ok := req.QueryStringParameters["username"]
	privateCognitoUser := &models.PrivateCognitoUser{}
	if !ok { // get public + private info
		var err error
		userToGet = requestor
		authToken := strings.Split((req.Headers["authorization"]), " ")[1]
		privateCognitoUser, err = models.GetPrivateCognitoUser(ctx, authToken)
		if err != nil {
			return Response{StatusCode: 500, Body: err.Error()}, nil
		}
	} else { // get public info
		userToGet = username
	}

	user, err := models.GetUser(ctx, userToGet)
	if err != nil {
		if httpErr, ok := err.(*models.HTTPError); ok {
			return Response{StatusCode: httpErr.Code, Body: httpErr.Error()}, nil
		}
		return Response{StatusCode: 500, Body: err.Error()}, nil
	}

	following, err := models.GetFollowing(ctx, userToGet)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}

	followers, err := models.GetFollowers(ctx, userToGet)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}

	requestorFollows, err := models.IsFollowing(ctx, requestor, userToGet)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}

	followsRequestor, err := models.IsFollowing(ctx, userToGet, requestor)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}

	body, err = views.MarshalFullUser(ctx, user, privateCognitoUser, following, followers, requestorFollows, followsRequestor)
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
