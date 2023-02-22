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
	ReviewID   int       `json:"review_id"`
	Username   string    `json:"username"`
	AlbumID    string    `json:"album_id"`
	Rating     int       `json:"rating"`
	ReviewText string    `json:"review_text"`
	CreatedAt  time.Time `json:"created_at" gorm:"default:CURRENT_TIMESTAMP"`
	UpdatedAt  time.Time `json:"updated_at" gorm:"default:CURRENT_TIMESTAMP"`
	Likes      []Like    `json:"likes" gorm:"foreignKey:ReviewID;references:ReviewID"`
}

// temp copy
type Like struct {
	Username string `json:"username"`
	ReviewID int    `json:"review_id"`
}

func connectDB() (*gorm.DB, error) {
	connectionString := fmt.Sprintf("%s:%s@tcp(%s:%s)/%s?allowNativePasswords=true&parseTime=true", secrets.user, secrets.password, secrets.host, secrets.port, secrets.database)
	if db, err := gorm.Open(mysql.Open(connectionString), &gorm.Config{}); err != nil {
		return nil, fmt.Errorf("error: failed to connect to AWS RDS: %w", err)
	} else {
		return db, nil
	}
}

func handler(ctx context.Context, req events.APIGatewayV2HTTPRequest) (Response, error) {
	switch req.RequestContext.HTTP.Method {
	case "GET":
		_, ok := req.QueryStringParameters["username"]
		if ok {
			return getUserReview(ctx, req)
		} else {
			return getReviews(ctx, req)
		}
	case "PUT":
		return createOrUpdateReview(ctx, req)
	case "DELETE":
		return deleteReview(ctx, req)
	default:
		err := fmt.Errorf("HTTP Method '%s' not allowed", req.RequestContext.HTTP.Method)
		return Response{StatusCode: 405, Body: err.Error()}, err
	}
}

// Given a username and album ID, get the review
// If review does not exist, return 204 status code
// @PARAMS are QueryStringParameters: "username" & "album_id"
// Postman: GET - /reviews?username={username}&album_id={album_id}
func getUserReview(ctx context.Context, req events.APIGatewayV2HTTPRequest) (Response, error) {
	db, err := connectDB()
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, err
	}

	// Get the username
	username, ok := req.QueryStringParameters["username"]
	if !ok {
		return Response{StatusCode: 500, Body: "Failed to parse username"}, nil
	}

	// Get the album ID
	albumID, ok := req.QueryStringParameters["album_id"]
	if !ok {
		return Response{StatusCode: 500, Body: "Failed to parse album ID"}, nil
	}

	// Find the review matching the username and album ID
	var review Review
	var result = db.Preload("Likes").Where("username = ? AND album_id = ?", username, albumID).Limit(1).Find(&review)
	if err := result.Error; err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, err
	}

	// conrmad is distracting me
	// i came here to cause problems
	// me me mow me mow
	// can we leave these in here
	// there was microplastics in my lunch. nohting materrs. yes
	// my office room has no windows. my office rooms has no windows. my
	// yeah idk. when you see the "bin/(whatever handler you're editing)" line, that is the compilation command. once the next line appears its done
	// i believe you.

	// If review does not exist, return 204 (no content)
	if result.RowsAffected == 0 {
		return Response{StatusCode: 204}, nil
	}

	// Serialize review into JSON
	reviewJSON, err := json.Marshal(review)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, err
	}

	return Response{StatusCode: 200, Body: string(reviewJSON)}, nil
}

// Given an albumID, return a list of reviews associated with the albumID
// @PARAMS are QueryStringParameters: "sort" & "album_id"
// Postman: GET - /reviews?sort={popular|newest|oldest}&album_id={album_id}
func getReviews(ctx context.Context, req events.APIGatewayV2HTTPRequest) (Response, error) {
	db, err := connectDB()
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, err
	}

	// Get the sort
	sort, ok := req.QueryStringParameters["sort"]
	if !ok {
		return Response{StatusCode: 500, Body: "Failed to parse sort"}, nil
	}

	// Get the album ID
	albumID, ok := req.QueryStringParameters["album_id"]
	if !ok {
		return Response{StatusCode: 500, Body: "Failed to parse album ID"}, nil
	}

	// Query database based on sort parameter
	var reviews []Review
	var result *gorm.DB
	switch sort {
	case "newest":
		result = db.Preload("Likes").Where("album_id = ?", albumID).Order("created_at desc").Find(&reviews)
		break
	case "oldest":
		result = db.Preload("Likes").Where("album_id = ?", albumID).Order("created_at asc").Find(&reviews)
		break
	case "popular":
		result = db.Preload("Likes").
			Joins("LEFT JOIN likes ON reviews.review_id = likes.review_id").
			Where("reviews.album_id = ?", albumID).
			Group("reviews.review_id").
			Order("COUNT(likes.review_id) DESC").
			Find(&reviews)
		break
	default:
		return Response{StatusCode: 500, Body: "Invalid sort parameter"}, err
	}

	if err := result.Error; err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, err
	}

	// Serialize reviews into JSON
	reviewsJSON, err := json.Marshal(reviews)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, err
	}

	return Response{StatusCode: 200, Body: string(reviewsJSON)}, nil
	// get number of likes for both gets
}

// Given the username and album ID in request body, if the review exists, update it
// Otherwise, create a new review in the database
// Note: Currently, updating a review in the database will update its review date to the current timestamp
// Postman: PUT - /reviews
func createOrUpdateReview(ctx context.Context, req events.APIGatewayV2HTTPRequest) (Response, error) {
	db, err := connectDB()
	if err != nil {
		// oopsy woopsy something went fucky wucky!!!
		return Response{StatusCode: 500, Body: err.Error()}, err
	}

	// Create Review from request body
	review := new(Review)
	err = json.Unmarshal([]byte(req.Body), &review)
	if err != nil {
		return Response{StatusCode: 400, Body: "Invalid request data format"}, err
	}

	// Update database if the review exists, otherwise create a new review
	updateRes := db.Model(&review).Where("username = ? AND album_id = ?", &review.Username, &review.AlbumID).Updates(&review)
	if updateRes.Error != nil {
		return Response{StatusCode: 500, Body: "Error updating data in database"}, err
	}
	if updateRes.RowsAffected == 0 {
		err = db.Create(&review).Error
		if err != nil {
			return Response{StatusCode: 500, Body: "Error inserting data into database"}, err
		}
		return Response{
			StatusCode: 201,
			Body: fmt.Sprintf("Successfully added review to album %s from %s to database.",
				review.AlbumID, review.Username),
		}, nil
	}

	return Response{
		StatusCode: 201,
		Body: fmt.Sprintf("Successfully updated review for album %s from %s in database.",
			review.AlbumID, review.Username),
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

func main() {
	lambda.Start(handler)
}
