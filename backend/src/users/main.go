package main

import (
	"context"
	"fmt"
	"os"
	"time"

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

type User struct {
	// gorm.Model
	CreatedAt      time.Time
	UpdatedAt      time.Time
	DeletedAt      time.Time `gorm:"index"`
	Username       string    `gorm:"varchar(128);primarykey"`
	Bio            string    `gorm:"varchar(1024)"`
	ProfilePicture string    `gorm:"varchar(512)"`
}

var secrets = Secrets{
	os.Getenv("MYSQLHOST"),
	os.Getenv("MYSQLPORT"),
	os.Getenv("MYSQLDATABASE"),
	os.Getenv("MYSQLUSER"),
	os.Getenv("MYSQLPASS"),
	os.Getenv("AWS_DEFAULT_REGION"),
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
		return read(req)
	case "PUT":
		return update(req)
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

	// make new user
	username, ok := req.RequestContext.Authorizer.Lambda["username"].(string)
	if !ok {
		return Response{StatusCode: 500, Body: "Failed to parse username"}, nil
	}

	NewUser := User{Username: username, Bio: "", ProfilePicture: ""}

	// db.AutoMigrate(&User{})

	// https://stackoverflow.com/questions/30361671/how-can-i-check-for-errors-in-crud-operations-using-gorm
	if res := db.Create(&NewUser); res.Error != nil {
		return Response{StatusCode: 500, Body: res.Error.Error()}, nil
	} else {
		return Response{StatusCode: 200, Body: fmt.Sprint(NewUser.Username)}, nil
	}
}

// GET: Returns user info
func read(req events.APIGatewayV2HTTPRequest) (Response, error) {
	// Connect to the RDS Database
	db, err := connectDB()
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, err
	}

	// Get the user's username from the request
	userID := req.PathParameters["username"]

	// Get the user info from the database
	var user User
	result := db.Where("username = ?", userID).First(&user)

	if result.Error != nil {
		return Response{StatusCode: 404, Body: "User not found."}, nil
	}

	// Convert the user to JSON
	userJSON, err := json.Marshal(user)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, err
	}

	// Return the JSON response
	return Response{StatusCode: 200, Body: string(userJSON)}, nil
}

func update(req events.APIGatewayV2HTTPRequest) (Response, error) {
	// Connect to the RDS database
	db, err := connectDB()
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, err
	}

	// Get the user's username from the request
	username := req.PathParameters["username"]

	// Get the user info from the database
	var user User
	if result := db.Where("username = ?", username).First(&user); result.Error != nil {
		return Response{StatusCode: 404, Body: "User not found."}, nil
	}

	// Unmarshal the JSON request body into the user struct
	err = json.Unmarshal([]byte(req.Body), &user)
	if err != nil {
		return Response{StatusCode: 400, Body: "Invalid request body."}, nil
	}

	// Update the user in the database
	result := db.Save(&user)
	if result.Error != nil {
		return Response{StatusCode: 500, Body: result.Error.Error()}, result.Error
	}

	// Return a success response
	return Response{StatusCode: 200, Body: "User updated successfully."}, nil
}

func main() {
	lambda.Start(handler)
}
