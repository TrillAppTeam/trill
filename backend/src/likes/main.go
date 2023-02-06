package main

import (
	"context"
	"fmt"
	"os"
	"strconv"

	"encoding/json"

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

type Likes struct {
	gorm.Model
	reviewID int // `sql:"int"`
	ReviewID int // `sql:"int"
}

// https://github.com/gugazimmermann/fazendadojuca/blob/master/animals/main.go

func connectDB() (*gorm.DB, error) {
	connectionString := fmt.Sprintf("%s:%s@tcp(%s:%s)/%s?allowNativePasswords=true", secrets.user, secrets.password, secrets.host, secrets.port, secrets.database)
	if db, err := gorm.Open(mysql.Open(connectionString), &gorm.Config{}); err != nil {
		return nil, fmt.Errorf("Error: Failed to connect to AWS RDS: %w", err)
	} else {
		return db, nil
	}
}

func handler(ctx context.Context, req events.APIGatewayProxyRequest) (Response, error) {
	switch req.HTTPMethod {
	case "POST":
		return create(ctx, req)
	case "GET":
		return read(req)
	case "DELETE":
		return delete(req)
	default:
		err := fmt.Errorf("HTTP Method '%s' not allowed", req.HTTPMethod)
		return Response{StatusCode: 405, Body: err.Error()}, err
	}
}

// User likes a review
func create(ctx context.Context, req events.APIGatewayProxyRequest) (Response, error) {
	db, err := connectDB()
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, err
	}

	likes := Likes{}
	if err := json.Unmarshal([]byte(req.Body), &likes); err != nil {
		return Response{StatusCode: 400, Body: err.Error()}, err
	}

	if err := db.Create(&likes).Error; err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, err
	}

	return Response{StatusCode: 201, Body: "Likes relationship created"}, nil
}

// Given a reviewID, get the number of likes for that review
func read(req events.APIGatewayProxyRequest) (Response, error) {
	db, err := connectDB()
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, err
	}

	reviewID := req.QueryStringParameters["reviewID"]
	if reviewID == "" {
		return Response{StatusCode: 400, Body: "reviewID parameter is required"}, nil
	}

	// Get the number of likes associated with the given reviewID
	var numLikes int64
	if err := db.Model(&Likes{}).Where("reviewID = ?", reviewID).Count(&numLikes).Error; err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, err
	}

	return Response{StatusCode: 200, Body: strconv.FormatInt(numLikes, 10)}, nil
}

// User unlikes a review
func delete(req events.APIGatewayProxyRequest) (Response, error) {
	db, err := connectDB()
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, err
	}

	ReviewID := req.QueryStringParameters["ReviewID"]
	reviewID := req.QueryStringParameters["reviewID"]

	if ReviewID == "" || reviewID == "" {
		err := fmt.Errorf("ReviewID and reviewID query parameters are required")
		return Response{StatusCode: 400, Body: err.Error()}, err
	}

	var likes Likes
	if err := db.Where("reviewID = ? AND ReviewID = ?", reviewID, ReviewID).First(&likes).Error; err != nil {
		return Response{StatusCode: 404, Body: "Likes relationship not found"}, nil
	}

	if err := db.Delete(&likes).Error; err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, err
	}

	return Response{StatusCode: 204}, nil
}

func main() {
	lambda.Start(handler)
}
