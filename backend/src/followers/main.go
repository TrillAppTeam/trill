package main

import (
	"context"
	"fmt"
	"os"

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

type Followers struct {
	gorm.Model
	UserID     int // `sql:"int"`
	FollowerID int // `sql:"int"
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

// Someone followers the user
func create(ctx context.Context, req events.APIGatewayProxyRequest) (Response, error) {
	db, err := connectDB()
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, err
	}

	followers := Followers{}
	if err := json.Unmarshal([]byte(req.Body), &followers); err != nil {
		return Response{StatusCode: 400, Body: err.Error()}, err
	}

	if err := db.Create(&followers).Error; err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, err
	}

	return Response{StatusCode: 201, Body: "Followers relationship created"}, nil
}

// Get's list of a user's followers
func read(req events.APIGatewayProxyRequest) (Response, error) {
	db, err := connectDB()
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, err
	}

	userID := req.QueryStringParameters["userID"]
	if userID == "" {
		return Response{StatusCode: 400, Body: "userID parameter is required"}, nil
	}

	var followers []Followers
	if err := db.Where("userID = ?", userID).Find(&followers).Error; err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, err
	}

	followersJSON, err := json.Marshal(followers)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, err
	}

	return Response{StatusCode: 200, Body: string(followersJSON)}, nil
}

// User unfollows someone
func delete(req events.APIGatewayProxyRequest) (Response, error) {
	db, err := connectDB()
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, err
	}

	followerID := req.QueryStringParameters["followerID"]
	userID := req.QueryStringParameters["userID"]

	if followerID == "" || userID == "" {
		err := fmt.Errorf("followerID and userID query parameters are required")
		return Response{StatusCode: 400, Body: err.Error()}, err
	}

	var followers Followers
	if err := db.Where("userID = ? AND followerID = ?", userID, followerID).First(&followers).Error; err != nil {
		return Response{StatusCode: 404, Body: "Follower relationship not found"}, nil
	}

	if err := db.Delete(&followers).Error; err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, err
	}

	return Response{StatusCode: 204}, nil
}

func main() {
	lambda.Start(handler)
}
