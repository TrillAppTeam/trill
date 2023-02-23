package main

import (
	"bytes"
	"context"
	"fmt"
	"io"
	"os"

	"encoding/json"

	"net/http"
	"net/url"

	"gorm.io/driver/mysql"
	"gorm.io/gorm"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

const SECRETS_PATH = "../../.secrets.yml"

type Response events.APIGatewayProxyResponse

type Secrets struct {
	host          string `yaml:"MYSQLHOST"`
	port          string `yaml:"MYSQLPORT"`
	database      string `yaml:"MYSQLDATABASE"`
	user          string `yaml:"MYSQLUSER"`
	password      string `yaml:"MYSQLPASS"`
	region        string `yaml:"AWS_DEFAULT_REGION"`
	spotifyID     string `yaml:"SPOTIFY_CLIENT_ID"`
	spotifySecret string `yaml:"SPOTIFY_CLIENT_SECRET"`
}

var secrets = Secrets{
	os.Getenv("MYSQLHOST"),
	os.Getenv("MYSQLPORT"),
	os.Getenv("MYSQLDATABASE"),
	os.Getenv("MYSQLUSER"),
	os.Getenv("MYSQLPASS"),
	os.Getenv("AWS_DEFAULT_REGION"),
	os.Getenv("SPOTIFY_CLIENT_ID"),
	os.Getenv("SPOTIFY_CLIENT_SECRET"),
}

type FavoriteAlbums struct {
	Username string
	AlbumID  string
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

type SpotifyToken struct {
	AccessToken string `json:"access_token"`
	TokenType   string `json:"token_type"`
	ExpiresIn   int    `json:"expires_in"`
}

/*type User struct {
	Username       string `gorm:"primarykey;unique"`
	Bio            string
	ProfilePicture string
	Followers      []Follows `gorm:"foreignkey:Followee"`
	Following      []Follows `gorm:"foreignkey:Following"`
}*/

// https://github.com/gugazimmermann/fazendadojuca/blob/master/animals/main.go

func connectDB() (*gorm.DB, error) {
	connectionString := fmt.Sprintf("%s:%s@tcp(%s:%s)/%s?allowNativePasswords=true", secrets.user, secrets.password, secrets.host, secrets.port, secrets.database)
	if db, err := gorm.Open(mysql.Open(connectionString), &gorm.Config{}); err != nil {
		return nil, fmt.Errorf("Error: Failed to connect to AWS RDS: %w", err)
	} else {
		return db, nil
	}
}

func handler(ctx context.Context, req events.APIGatewayV2HTTPRequest) (Response, error) {
	switch req.RequestContext.HTTP.Method {
	case "POST":
		return create(ctx, req)
	case "GET":
		return read(req)
	case "DELETE":
		return delete(req)
	default:
		err := fmt.Errorf("HTTP Method '%s' not allowed", req.RequestContext.HTTP.Method)
		return Response{StatusCode: 405, Body: err.Error()}, err
	}
}

// User adds an album to their favorite albums. Only allows users to add an album if they have < 4 albums currently in their favorites.
func create(ctx context.Context, req events.APIGatewayV2HTTPRequest) (Response, error) {
	db, err := connectDB()
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, err
	}
	// db.AutoMigrate(&User{})
	// db.AutoMigrate(&Follows{})

	insertRecord := new(FavoriteAlbums)
	err = json.Unmarshal([]byte(req.Body), &insertRecord)
	if err != nil {
		return Response{StatusCode: 400, Body: "Invalid request data format"}, err
	}

	// Only allow users to add an album if they have less than 4 albums currently in their favorites
	var count int64
	if err := db.Table("favorite_albums").Where("username = ?", insertRecord.Username).Count(&count).Error; err != nil {
		return Response{StatusCode: 500, Body: "Failed to check count"}, err
	}

	if count >= 4 {
		err := fmt.Errorf("Error: User already has 4 favorite albums.")
		return Response{StatusCode: 400, Body: err.Error()}, err
	}

	// Add the follow relationship to the database
	err = db.Create(&insertRecord).Error
	if err != nil {
		return Response{StatusCode: 500, Body: "Error inserting data into database"}, err
	}

	// Woo Hoo !!!
	return Response{
		StatusCode: 201,
		Body:       "Successfully added to database",
	}, nil
}

// Gets the user's favorite albums
// @PARAMS - username (string)
func read(req events.APIGatewayV2HTTPRequest) (Response, error) {
	db, err := connectDB()
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, err
	}

	// Get the username from the request params
	username, ok := req.QueryStringParameters["username"]
	if !ok {
		return Response{StatusCode: 500, Body: "Failed to parse username"}, nil
	}

	var count int64
	if err := db.Table("favorite_albums").Where("username = ?", username).Count(&count).Error; err != nil {
		return Response{StatusCode: 500, Body: "Failed to check count"}, err
	}

	if count == 0 {
		str, _ := json.Marshal([]string{})
		return Response{StatusCode: 200, Body: string(str)}, nil
	}

	// Given the username, find
	var fave_albums []FavoriteAlbums
	if err := db.Where("username = ?", username).Find(&fave_albums).Error; err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, err
	}

	albumInfo := make([]SpotifyAlbums, len(fave_albums))

	for i := range fave_albums {
		album, err := getAlbumInfo(fave_albums[i].AlbumID)
		if err != nil {
			return Response{StatusCode: 500, Body: err.Error()}, err
		}
		albumInfo[i] = album
	}

	albumInfoJSON, err := json.Marshal(albumInfo)

	return Response{StatusCode: 200, Body: string(albumInfoJSON)}, nil
}

func getAlbumInfo(albumID string) (SpotifyAlbums, error) {
	var resp SpotifyAlbums
	var buf bytes.Buffer

	clientSecret := secrets.spotifySecret
	clientID := secrets.spotifyID

	client := &http.Client{}
	body := url.Values{}
	body.Set("grant_type", "client_credentials")
	body.Set("client_id", clientID)
	body.Set("client_secret", clientSecret)

	reqBody := bytes.NewBufferString(body.Encode())
	request, err := http.NewRequest("POST", "https://accounts.spotify.com/api/token", reqBody)
	if err != nil {
		return SpotifyAlbums{}, err
	}

	request.Header.Add("Content-Type", "application/x-www-form-urlencoded")

	tokenResp, err := client.Do(request)
	if err != nil {
		return SpotifyAlbums{}, err
	}
	defer tokenResp.Body.Close()

	_, err = io.Copy(&buf, tokenResp.Body)
	if err != nil {
		return SpotifyAlbums{}, err
	}

	var token SpotifyToken
	err = json.Unmarshal(buf.Bytes(), &token)
	if err != nil {
		return SpotifyAlbums{}, err
	}

	request, err = http.NewRequest("GET", "https://api.spotify.com/v1/albums/"+albumID, nil)
	if err != nil {
		return SpotifyAlbums{}, err
	}
	request.Header.Add("Authorization", "Bearer "+token.AccessToken)
	r, err := client.Do(request)
	if err != nil {
		return SpotifyAlbums{}, err
	}
	defer r.Body.Close()

	buf.Reset()

	_, err = io.Copy(&buf, r.Body)
	if err != nil {
		return SpotifyAlbums{}, err
	}

	err = json.Unmarshal(buf.Bytes(), &resp)
	if err != nil {
		return SpotifyAlbums{}, err
	}

	return resp, nil
}

// Deletes an album from a user's favorite albums
func delete(req events.APIGatewayV2HTTPRequest) (Response, error) {
	db, err := connectDB()
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, err
	}

	deleteRecord := new(FavoriteAlbums)
	err = json.Unmarshal([]byte(req.Body), &deleteRecord)
	if err != nil {
		return Response{StatusCode: 400, Body: "Invalid request data format"}, err
	}

	// Find these two values in the database, then delete the record.
	if err := db.Where("username = ? AND album_id = ?", &deleteRecord.Username, &deleteRecord.AlbumID).Delete(&deleteRecord).Error; err != nil {
		return Response{StatusCode: 404, Body: "Cannot delete favorited album."}, nil
	}

	// Woo Hoo !!!
	return Response{
		StatusCode: 200,
		Body:       "Successfully removed from database",
	}, nil
}

func main() {
	lambda.Start(handler)
}
