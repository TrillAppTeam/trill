package handlers

import (
	"context"
	"trill/src/models"

	"github.com/aws/aws-lambda-go/events"
	"gorm.io/gorm"
)

type Request = events.APIGatewayV2HTTPRequest
type Response = events.APIGatewayV2HTTPResponse

func InitContext(ctx context.Context, db *gorm.DB) (context.Context, error) {
	if db == nil {
		var err error
		db, err = models.ConnectDB()
		if err != nil {
			return nil, err
		}
	}
	return context.WithValue(ctx, "db", db), nil
}
