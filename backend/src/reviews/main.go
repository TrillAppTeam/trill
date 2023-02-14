// TO DO:
// GET: given a review ID, get the number of likes it has
// GET: given a albumID, return the list of reviews but sort where the most like reviews are first
// POST: add a new review
// DELETE: delete a review
// this api going be hefty, theres more endpoints we're missing but brain dead rn

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

type Review struct {
	ReviewID   int
	Username   string
	AlbumID    string
	Rating     int
	ReviewText string
	ReviewDate time.Time `gorm:"default:CURRENT_TIMESTAMP"`
	// Likes      []Like    `gorm:"foreignKey:ReviewID"`
}

// temp copy
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
	// 	return getLikeCount(ctx, req)
	case "PUT":
		return createReview(ctx, req)
	case "DELETE":
		return deleteReview(ctx, req)
	default:
		err := fmt.Errorf("HTTP Method '%s' not allowed", req.RequestContext.HTTP.Method)
		return Response{StatusCode: 405, Body: err.Error()}, err
	}
}

// User creates a review for a specific albumID
// Postman: PUT - /reviews
func createReview(ctx context.Context, req events.APIGatewayV2HTTPRequest) (Response, error) {
	// todo: update review
	// if user already has review for that album in database, update it

	db, err := connectDB()
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, err
	}

	// Create new Review
	newReview := new(Review)
	err = json.Unmarshal([]byte(req.Body), &newReview)
	if err != nil {
		return Response{StatusCode: 400, Body: "Invalid request data format"}, err
	}

	// Add new Review to the database
	err = db.Create(&newReview).Error
	if err != nil {
		return Response{StatusCode: 500, Body: "Error inserting data into database"}, err
	}

	return Response{
		StatusCode: 201,
		Body: fmt.Sprintf("Successfully added review to album %s from %s to database.",
			newReview.AlbumID, newReview.Username),
	}, nil
}

// User deletes a review for a specific albumID
// Postman: DELETE - /reviews
func deleteReview(ctx context.Context, req events.APIGatewayV2HTTPRequest) (Response, error) {
	db, err := connectDB()
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, err
	}

	// Create Review to be deleted
	reviewToDelete := new(Review)
	err = json.Unmarshal([]byte(req.Body), &reviewToDelete)
	if err != nil {
		return Response{StatusCode: 400, Body: "Invalid request data format"}, err
	}

	// Delete the requested Review from the database
	if err := db.Where("username = ? AND album_id = ?", &reviewToDelete.Username, &reviewToDelete.AlbumID).Delete(&reviewToDelete).Error; err != nil {
		return Response{StatusCode: 404, Body: err.Error()}, nil
	}

	return Response{
		StatusCode: 201,
		Body: fmt.Sprintf("Successfully removed review to album %s by %s from database.",
			reviewToDelete.AlbumID, reviewToDelete.Username),
	}, nil
}

// // Given a albumID, return the following:
// // - A list of reviews associated with the albumID (Sorted where most-liked reviews are first in the list).
// // - The number of likes for each review, so that you can display this on the frontend
// func read(req events.APIGatewayProxyRequest) (Response, error) {

// }

func main() {
	lambda.Start(handler)
}
