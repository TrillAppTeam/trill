package main

import (
	"context"

	"trill/src/handlers"
	"trill/src/models"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"gorm.io/gorm"
)

type CognitoEvent = events.CognitoEventUserPoolsPostConfirmation

var db *gorm.DB

func create(ctx context.Context, req CognitoEvent) (CognitoEvent, error) {
	var initCtx context.Context
	var err error
	initCtx, db, err = handlers.InitContext(ctx, db)
	if err != nil {
		return req, err
	}

	user := models.User{
		Username:       req.UserName,
		Nickname:       req.Request.UserAttributes["nickname"],
		Bio:            "",
		ProfilePicture: "",
	}

	return req, models.CreateUser(initCtx, &user)
}

func main() {
	lambda.Start(create)
}
