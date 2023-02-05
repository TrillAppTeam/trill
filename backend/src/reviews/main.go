// TO DO:
// GET: given a review ID, get the number of likes it has
// GET: given a albumID, return the list of reviews but sort where the most like reviews are first
// POST: add a new review
// DELETE: delete a review
// this api going be hefty, theres more endpoints we're missing but brain dead rn

package main

import (
	"context"
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

type Reviews struct {
	gorm.Model
	ReviewID   int    // `sql:"int"`
	UserID     int    // `sql:"int"
	AlbumID    string // `sql:"varchar(128)"
	ReviewText string // `sql:"varchar(4096)"`
	ReviewDate time.Time
	Rating     int // `sql:"int"
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
	// case "POST":
	// 	return create(ctx, req)
	// case "GET":
	// 	return read(req)
	// case "DELETE":
	// 	return delete(req)
	default:
		err := fmt.Errorf("HTTP Method '%s' not allowed", req.HTTPMethod)
		return Response{StatusCode: 405, Body: err.Error()}, err
	}
}

// User adds a review for a specific albumID
// func create(ctx context.Context, req events.APIGatewayProxyRequest) (Response, error) {

// }

// // Given a albumID, return the following:
// // - A list of reviews associated with the albumID (Sorted where most-liked reviews are first in the list).
// // - The number of likes for each review, so that you can display this on the frontend
// func read(req events.APIGatewayProxyRequest) (Response, error) {

// }

// // Given a reviewID, return the number of likes for that review. This will be used when sorting by most popular reviews.
// // not exactly sure how to include this in the GET case? I guess just include it in the body thats returned?
// func getLikesForReviewID(req events.APIGatewayProxyRequest) (Response, error) {

// }

// // User deletes an album from their favorite albums
// func delete(req events.APIGatewayProxyRequest) (Response, error) {

// }

func main() {
	lambda.Start(handler)
}