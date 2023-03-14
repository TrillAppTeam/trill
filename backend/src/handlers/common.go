package handlers

import (
	"context"
	"fmt"
	"trill/src/models"

	"github.com/aws/aws-lambda-go/events"
	"gorm.io/gorm"
)

type Request = events.APIGatewayV2HTTPRequest
type Response = events.APIGatewayV2HTTPResponse

func InitContext(ctx context.Context, db *gorm.DB) (context.Context, *gorm.DB, error) {
	fmt.Printf("db before: %p\n", db)
	if db == nil {
		var err error
		db, err = models.ConnectDB()
		fmt.Printf("db after: %p\n", db)
		if err != nil {
			return nil, nil, err
		}
	}
	return context.WithValue(ctx, "db", db), db, nil
}
