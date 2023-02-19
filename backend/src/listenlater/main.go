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

type ListenLaterAlbums struct {
	Username string // ``gorm:"primarykey;unique"``
	AlbumID  int
}

type SpotifyAlbums struct {
	AlbumType    string `json:"album_type"`
	ExternalUrls struct {
		Spotify string `json:"spotify"`
	} `json:"external_urls"`
	Href   string `json:"href"`
	ID     string `json:"id"`
	Images []struct {
		URL    string `json:"url"`
		Height int    `json:"height"`
		Width  int    `json:"width"`
	} `json:"images"`
	Name        string   `json:"name"`
	ReleaseDate string   `json:"release_date"`
	Type        string   `json:"type"`
	URI         string   `json:"uri"`
	Genres      []string `json:"genres"`
	Label       string   `json:"label"`
	Popularity  int      `json:"popularity"`
	Artists     []struct {
		ID   string `json:"id"`
		Name string `json:"name"`
		Type string `json:"type"`
		URI  string `json:"uri"`
	} `json:"artists"`
}

// https://github.com/gugazimmermann/fazendadojuca/blob/master/animals/main.go

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
	case "POST":
		return create(ctx, req)
	case "GET":
		return getListenLater(req)
	case "DELETE":
		return delete(req)
	default:
		err := fmt.Errorf("HTTP Method '%s' not allowed", req.RequestContext.HTTP.Method)
		return Response{StatusCode: 405, Body: err.Error()}, err
	}
}

func create(ctx context.Context, req events.APIGatewayV2HTTPRequest) (Response, error) {
	db, err := connectDB()
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, nil
	}

	listen_later_albums := new(ListenLaterAlbums)

	err = json.Unmarshal([]byte(req.Body), &listen_later_albums)
	if err != nil {
		return Response{StatusCode: 400, Body: "Invalid request data format"}, err
	}

	// Only allow users to add an album if they have less than 100 albums currently in their Listen Later
	var count int64
	if err := db.Table("listen_later_albums").Where("username = ?", listen_later_albums.Username).Count(&count).Error; err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, err
	}

	if count >= 100 {
		err := fmt.Errorf("Error: User already has 100 albums queued in Listen Later.")
		return Response{StatusCode: 400, Body: err.Error()}, err
	}

	// TO DO: Update database to be uuid instead of username, reflect here
	// Unmarshal JSON request body into a ListenLaterAlbums struct

	// Add the album to the database
	err = db.Create(&listen_later_albums).Error
	if err != nil {
		return Response{StatusCode: 500, Body: "Error inserting data into database"}, err
	}

	// Woo Hoo !!!
	return Response{
		StatusCode: 201,
		Body:       "Successfully added to database",
	}, nil
}

// GET: Returns user's Listen Later list
func getListenLater(req events.APIGatewayV2HTTPRequest) (Response, error) {
	// Connect to the RDS Database
	db, err := connectDB()
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, err
	}

	// Get the username from the JSON request body
	username, ok := req.QueryStringParameters["username"]
	if !ok {
		return Response{StatusCode: 500, Body: "Failed to parse username"}, nil
	}

	// Given the username, find
	var listen_later_albums []ListenLaterAlbums
	if err := db.Where("username = ?", username).Find(&listen_later_albums).Error; err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, err
	}

	listenLaterJSON, err := json.Marshal(listen_later_albums)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, err
	}

	// Return the JSON response
	return Response{StatusCode: 200, Body: string(listenLaterJSON)}, nil
}

func delete(req events.APIGatewayV2HTTPRequest) (Response, error) {
	// Connect to the RDS database
	db, err := connectDB()
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, err
	}

	deleteAlbum := new(ListenLaterAlbums)
	err = json.Unmarshal([]byte(req.Body), &deleteAlbum)
	if err != nil {
		return Response{StatusCode: 400, Body: "Invalid request data format"}, err
	}

	// Find these two values in the database, then delete the record.
	if err := db.Where("username = ? AND album_id = ?", &deleteAlbum.Username, &deleteAlbum.AlbumID).Delete(&deleteAlbum).Error; err != nil {
		return Response{StatusCode: 404, Body: "Cannot remove from Listen Later."}, nil
	}

	// Woo Hoo !!!
	return Response{
		StatusCode: 201,
		Body:       "Successfully removed from database",
	}, nil
}

func main() {
	lambda.Start(handler)
}
