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

type Following struct {
	gorm.Model
	UserID      int // `sql:"int"`
	FollowingID int // `sql:"int"
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

// User follows someone
func create(ctx context.Context, req events.APIGatewayProxyRequest) (Response, error) {
	db, err := connectDB()
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, err
	}

	following := Following{}
	if err := json.Unmarshal([]byte(req.Body), &following); err != nil {
		return Response{StatusCode: 400, Body: err.Error()}, err
	}

	if err := db.Create(&following).Error; err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, err
	}

	return Response{StatusCode: 201, Body: "Following relationship created"}, nil
}

// Get's list of people the user is following
func read(req events.APIGatewayProxyRequest) (Response, error) {
	db, err := connectDB()
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, err
	}

	userID := req.QueryStringParameters["userID"]
	if userID == "" {
		return Response{StatusCode: 400, Body: "userID parameter is required"}, nil
	}

	var followings []Following
	if err := db.Where("userID = ?", userID).Find(&followings).Error; err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, err
	}

	followingsJSON, err := json.Marshal(followings)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, err
	}

	return Response{StatusCode: 200, Body: string(followingsJSON)}, nil
}

// User unfollows someone
func delete(req events.APIGatewayProxyRequest) (Response, error) {
	db, err := connectDB()
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, err
	}

	followingID := req.QueryStringParameters["followingID"]
	userID := req.QueryStringParameters["userID"]

	if followingID == "" || userID == "" {
		err := fmt.Errorf("followingID and userID query parameters are required")
		return Response{StatusCode: 400, Body: err.Error()}, err
	}

	var following Following
	if err := db.Where("userID = ? AND followingID = ?", userID, followingID).First(&following).Error; err != nil {
		return Response{StatusCode: 404, Body: "Follow relationship not found"}, nil
	}

	if err := db.Delete(&following).Error; err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, err
	}

	return Response{StatusCode: 204}, nil
}

func main() {
	lambda.Start(handler)
}