package handlers

import (
	"bytes"
	"context"
	"errors"
	"fmt"
	"mime"
	"mime/multipart"
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

func ParseMultipartRequest(req *events.APIGatewayV2HTTPRequest) (*multipart.Form, error) {
	mediaType, params, err := mime.ParseMediaType(req.Headers["content-type"])
	if err != nil {
		return nil, err
	}
	if mediaType != "multipart/form-data" {
		return nil, errors.New("invalid media type")
	}

	boundary := params["boundary"]
	if boundary == "" {
		return nil, errors.New("missing boundary")
	}
	body := bytes.NewReader([]byte(req.Body))
	multipartReader := multipart.NewReader(body, boundary)

	return multipartReader.ReadForm(0)
}
