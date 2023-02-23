package main

import (
	"context"

	"trill/src/models"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"gorm.io/gorm"
)

type CognitoEvent = events.CognitoEventUserPoolsPostConfirmation

var db *gorm.DB

func create(ctx context.Context, req CognitoEvent) (CognitoEvent, error) {
	if db == nil {
		var err error
		db, err = models.ConnectDB()
		if err != nil {
			return req, err
		}
		ctx = context.WithValue(ctx, "db", db)
	}

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
