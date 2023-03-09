package main

import (
	"context"
	"fmt"
	"strings"
	"trill/src/models"
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
	case "GET":
		if _, ok := req.QueryStringParameters["search"]; ok {
			return search(ctx, req)
		} else {
			return get(ctx, req)
		}
	case "PUT":
		return update(ctx, req)
	default:
		err := fmt.Errorf("HTTP method '%s' not allowed", req.RequestContext.HTTP.Method)
		return Response{StatusCode: 405, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}
}

func search(ctx context.Context, req Request) (Response, error) {
	search, _ := req.QueryStringParameters["search"]
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
	authToken := strings.Split((req.Headers["authorization"]), " ")[1]
	username, ok := req.QueryStringParameters["username"]
	privateCognitoUser := &models.PrivateCognitoUser{}
	if !ok { // get public + private info
		var err error
		userToGet = requestor
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
	publicCognitoUser, err := models.GetPublicCognitoUser(ctx, userToGet)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, nil
	}
	body, err = views.MarshalFullUser(ctx, user, publicCognitoUser, privateCognitoUser)
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
	authToken := strings.Split((req.Headers["authorization"]), " ")[1]

	user, err := models.GetUser(ctx, username)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}
	publicCognitoUser := &models.PublicCognitoUser{}

	if err = views.UnmarshalUser(ctx, req.Body, user); err != nil {
		return Response{StatusCode: 400, Body: fmt.Sprintf("invalid request body: %s, %s", err.Error(), req.Body), Headers: views.DefaultHeaders}, nil
	} else if err = views.UnmarshalPublicCognitoUser(ctx, req.Body, publicCognitoUser); err != nil {
		return Response{StatusCode: 400, Body: fmt.Sprintf("invalid request body: %s, %s", err.Error(), req.Body), Headers: views.DefaultHeaders}, nil
	} else if err = models.UpdatePublicCognitoUser(ctx, publicCognitoUser, authToken); err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	} else if err = models.UpdateUser(ctx, user); err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}

	return Response{StatusCode: 200, Body: "user updated successfully", Headers: views.DefaultHeaders}, nil
}

func main() {
	lambda.Start(handler)
}
