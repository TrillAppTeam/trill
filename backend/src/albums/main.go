package main

import (
	"context"
	"fmt"
	"os"
	"io"
	"bytes"

	"encoding/json"
	"net/http"

	"gorm.io/driver/mysql"
	"gorm.io/gorm"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

const SECRETS_PATH = "../../.secrets.yml"

type Secrets struct {
	host     string `yaml:"MYSQLHOST"`
	port     string `yaml:"MYSQLPORT"`
	database string `yaml:"MYSQLDATABASE"`
	user     string `yaml:"MYSQLUSER"`
	password string `yaml:"MYSQLPASS"`
	region   string `yaml:"AWS_DEFAULT_REGION"`
	spotifyID   string `yaml:"SPOTIFY_CLIENT_ID"`
	spotifySecret   string `yaml:"SPOTIFY_CLIENT_SECRET"`
}

type SpotifyAlbums struct {
	Albums struct {
		Href  string `json:"href"`
		Items []struct {
			AlbumType      string `json:"album_type"`
			ExternalUrls   struct {
				Spotify string `json:"spotify"`
			} `json:"external_urls"`
			Href   string `json:"href"`
			ID     string `json:"id"`
			Images []struct {
				URL    string `json:"url"`
				Height int    `json:"height"`
				Width  int    `json:"width"`
			} `json:"images"`
			Name         string   `json:"name"`
			ReleaseDate  string   `json:"release_date"`
			Type         string   `json:"type"`
			URI          string   `json:"uri"`
			Genres       []string `json:"genres"`
			Label        string   `json:"label"`
			Popularity   int      `json:"popularity"`
			Artists      []struct {
				ID   string `json:"id"`
				Name string `json:"name"`
				Type string `json:"type"`
				URI  string `json:"uri"`
			} `json:"artists"`
		} `json:"items"`
		Limit    int `json:"limit"`
		Next     string `json:"next"`
		Offset   int `json:"offset"`
		Previous string `json:"previous"`
		Total    int `json:"total"`
	} `json:"albums"`
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

type Response events.APIGatewayProxyResponse

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
	//case "POST":
	//	return create(ctx, req)
	case "GET":
		return read(req)
	//case "PUT":
	//	return update(req)
	// EDIT: we dont think a user should be able to delete their account <3
	// case "DELETE":
	// 	return delete(req)
	default:
		err := fmt.Errorf("HTTP Method '%s' not allowed", req.HTTPMethod)
		return Response{StatusCode: 405, Body: err.Error()}, err
	}
}

// GET: Returns album info
func read(req events.APIGatewayProxyRequest) (Response, error) {
	var resp SpotifyAlbums
	var buf bytes.Buffer

	query := req.QueryStringParameters["query"]
	clientSecret := secrets.spotifySecret
	clientID := secrets.spotifyID

	client := &http.Client{}

	reqBody := []byte(fmt.Sprintf("grant_type=client_credentials&client_id=%s&client_secret=%s", clientID, clientSecret))

	request, err := http.NewRequest("POST", "https://accounts.spotify.com/api/token", bytes.NewBuffer(reqBody))
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, err
	}

	request.Header.Add("Content-Type", "application/x-www-form-urlencoded")

	tokenResp, err := client.Do(request)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, err
	}
	defer tokenResp.Body.Close()

	_, err = io.Copy(&buf, tokenResp.Body)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, err
	}

	var AccessToken string
	err = json.Unmarshal(buf.Bytes(), &AccessToken)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, err
	}

	request, err = http.NewRequest("GET", "https://api.spotify.com/v1/search?q="+query+"&type=album", nil)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, err
	}
	request.Header.Add("Authorization", "Bearer " + AccessToken)
	r, err := client.Do(request)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, err
	}
	defer r.Body.Close()

	_, err = io.Copy(&buf, r.Body)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, err
	}

	err = json.Unmarshal(buf.Bytes(), &resp)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, err
	}

	albums := resp.Albums.Items
	albumsJson, err := json.Marshal(albums)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, err
	}

	return Response{StatusCode: 200, Body: string(albumsJson)}, nil
}

func main() {
	lambda.Start(handler)
}
