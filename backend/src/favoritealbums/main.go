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

type FavoriteAlbums struct {
	gorm.Model
	UserID  int    // `sql:"int"`
	AlbumID string // `sql:"char(128)"
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

// User adds an album to their favorite albums. Only allows users to add an album if they have < 4 albums currently in their favorites.
func create(ctx context.Context, req events.APIGatewayProxyRequest) (Response, error) {
	db, err := connectDB()
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, err
	}

	userID := req.QueryStringParameters["userID"]
	if userID == "" {
		return Response{StatusCode: 400, Body: "userID parameter is required"}, nil
	}

	// Only allow users to add an album if they have less than 4 albums currently in their favorites
	var count int64
	if err := db.Model(&FavoriteAlbums{}).Where("userID = ?", userID).Count(&count).Error; err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, err
	}

	if count >= 4 {
		err := fmt.Errorf("Error: User already has 4 favorite albums.")
		return Response{StatusCode: 400, Body: err.Error()}, err
	}

	// Parse the JSON body
	var album FavoriteAlbums
	if err := json.Unmarshal([]byte(req.Body), &album); err != nil {
		return Response{StatusCode: 400, Body: err.Error()}, err
	}

	// Save the album to the database
	if err := db.Create(&album).Error; err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, err
	}

	return Response{StatusCode: 201, Body: "Successfully added album to favorites."}, nil
}

// Get's the user's favorite albums
func read(req events.APIGatewayProxyRequest) (Response, error) {
	db, err := connectDB()
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, err
	}

	userID := req.QueryStringParameters["userID"]
	if userID == "" {
		return Response{StatusCode: 400, Body: "userID parameter is required"}, nil
	}

	// Get the user's favorite albums
	var albums []FavoriteAlbums
	if err := db.Where("userID = ?", userID).Find(&albums).Error; err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, err
	}

	// Convert the albums to JSON
	albumsJSON, err := json.Marshal(albums)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, err
	}

	return Response{StatusCode: 200, Body: string(albumsJSON)}, nil
}

// User deletes an album from their favorite albums
func delete(req events.APIGatewayProxyRequest) (Response, error) {
	db, err := connectDB()
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, err
	}

	albumID := req.QueryStringParameters["albumID"]
	if albumID == "" {
		return Response{StatusCode: 400, Body: "albumID parameter is required"}, nil
	}

	// Delete the album from the database
	if err := db.Delete(&albumID).Error; err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, err
	}

	return Response{StatusCode: 200, Body: "Successfully deleted album from favorites."}, nil
}

func main() {
	lambda.Start(handler)
}
