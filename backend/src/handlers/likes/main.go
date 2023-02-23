package main

import (
	"context"
	"encoding/json"
	"fmt"
	"os"

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

type Like struct {
	Username string `json:"username"`
	ReviewID int    `json:"review_id"`
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
	case "GET":
		return getLikeCount(ctx, req)
	case "PUT":
		return like(ctx, req)
	case "DELETE":
		return unlike(ctx, req)
	default:
		err := fmt.Errorf("HTTP Method '%s' not allowed", req.RequestContext.HTTP.Method)
		return Response{StatusCode: 405, Body: err.Error()}, err
	}
}

// Given a reviewID, get the number of likes for that review
// @PARAMS are QueryStringParameters: "review_id"
// Postman: GET - /likes?review_id={reviewID}
func getLikeCount(ctx context.Context, req events.APIGatewayV2HTTPRequest) (Response, error) {
	db, err := connectDB()
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, err
	}

	// Get the review ID
	reviewID, ok := req.QueryStringParameters["review_id"]
	if !ok {
		return Response{StatusCode: 500, Body: "Failed to parse review ID"}, nil
	}

	// Given the review ID, find the users who liked it
	var likeUsers []Like
	var result = db.Where("review_id = ?", reviewID).Find(&likeUsers)
	if err := result.Error; err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, err
	}

	// Serialize users into JSON; Return usersJSON if we want the list of users
	// usersJSON, err := json.Marshal(likeUsers)
	// if err != nil {
	// 	return Response{StatusCode: 500, Body: err.Error()}, err
	// }

	return Response{StatusCode: 200, Body: fmt.Sprint(result.RowsAffected)}, nil
}

// User likes a review
// Postman: PUT - /likes
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
// Postman: DELETE - /likes
func unlike(ctx context.Context, req events.APIGatewayV2HTTPRequest) (Response, error) {
	db, err := connectDB()
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, err
	}

	// Create Like to be deleted
	likeToDelete := new(Like)
	err = json.Unmarshal([]byte(req.Body), &likeToDelete)
	if err != nil {
		return Response{StatusCode: 400, Body: "Invalid request data format"}, err
	}

	// Delete the requested Like from the database
	if err := db.Where("username = ? AND review_id = ?", &likeToDelete.Username, &likeToDelete.ReviewID).Delete(&likeToDelete).Error; err != nil {
		return Response{StatusCode: 404, Body: err.Error()}, nil
	}

	return Response{
		StatusCode: 201,
		Body: fmt.Sprintf("Successfully removed like to review %d from %s to database.",
			likeToDelete.ReviewID, likeToDelete.Username),
	}, nil
}

func main() {
	lambda.Start(handler)
}
