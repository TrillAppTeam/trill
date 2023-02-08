package main

import (
	"context"
	"encoding/json"
	"fmt"
	"os"
	"time"

	"gorm.io/driver/mysql"
	"gorm.io/gorm"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

const SECRETS_PATH = "../../.secrets.yml"

type Response events.APIGatewayProxyResponse

type Secrets struct {
	host     string `yaml:"MYSQLHOST"`
	port     string `yaml:"MYSQLPORT"`
	database string `yaml:"MYSQLDATABASE"`
	user     string `yaml:"MYSQLUSER"`
	password string `yaml:"MYSQLPASS"`
	region   string `yaml:"AWS_DEFAULT_REGION"`
}

var secrets = Secrets{
	os.Getenv("MYSQLHOST"),
	os.Getenv("MYSQLPORT"),
	os.Getenv("MYSQLDATABASE"),
	os.Getenv("MYSQLUSER"),
	os.Getenv("MYSQLPASS"),
	os.Getenv("AWS_DEFAULT_REGION"),
}

type User struct {
	CreatedAt      time.Time
	UpdatedAt      time.Time
	DeletedAt      time.Time `gorm:"index"`
	Username       string
	Bio            string
	ProfilePicture string
}

type Review struct {
	CreatedAt  time.Time
	UpdatedAt  time.Time
	DeletedAt  time.Time `gorm:"index"`
	ReviewID   int
	Username   string
	AlbumID    string
	ReviewText string
	Rating     int
}

type Like struct {
	Username string
	ReviewID int
}

func connectDB() (*gorm.DB, error) {
	connectionString := fmt.Sprintf("%s:%s@tcp(%s:%s)/%s?allowNativePasswords=true", secrets.user, secrets.password, secrets.host, secrets.port, secrets.database)
	if db, err := gorm.Open(mysql.Open(connectionString), &gorm.Config{}); err != nil {
		return nil, fmt.Errorf("error: failed to connect to AWS RDS: %w", err)
	} else {
		return db, nil
	}
}

func handler(ctx context.Context, req events.APIGatewayV2HTTPRequest) (Response, error) {
	switch req.RequestContext.HTTP.Method {
	// case "GET":
	// 	return getLikes(ctx, req)
	case "PUT":
		return like(ctx, req)
	// case "DELETE":
	// 	return unlike(ctx, req)
	default:
		err := fmt.Errorf("HTTP Method '%s' not allowed", req.RequestContext.HTTP.Method)
		return Response{StatusCode: 405, Body: err.Error()}, err
	}
}

// Given a reviewID, get the number of likes for that review
// func getLikes(ctx context.Context, req events.APIGatewayV2HTTPRequest) (Response, error) {
// }

// User likes a review
func like(ctx context.Context, req events.APIGatewayV2HTTPRequest) (Response, error) {
	db, err := connectDB()
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, err
	}

	// Create new Like
	newLike := new(Like)
	err = json.Unmarshal([]byte(req.Body), &newLike)
	if err != nil {
		return Response{StatusCode: 400, Body: "Invalid request data format"}, err
	}

	// Add new like to the database
	err = db.Create(&newLike).Error
	if err != nil {
		return Response{StatusCode: 500, Body: "Error inserting data into database"}, err
	}

	return Response{
		StatusCode: 201,
		Body: fmt.Sprintf("Successfully added new like to review %d from %s to database.",
			newLike.ReviewID, newLike.Username),
	}, nil
}

// User unlikes a review
// func unlike(ctx context.Context, req events.APIGatewayV2HTTPRequest) (Response, error) {

// }

func main() {
	lambda.Start(handler)
}
