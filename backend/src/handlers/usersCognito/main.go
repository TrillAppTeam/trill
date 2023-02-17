package main

import (
	"context"

	"trill/src/models"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

type CognitoEvent = events.CognitoEventUserPoolsPostConfirmation

func create(ctx context.Context, req CognitoEvent) (CognitoEvent, error) {
	user := models.User{
		Username:       req.UserName,
		Bio:            "",
		ProfilePicture: "",
	}

	return req, models.CreateUser(ctx, &user)
}

func main() {
	lambda.Start(create)
}
