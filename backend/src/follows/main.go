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

type Follows struct {
	Followee		string    `gorm:"foreignKey:Username"`
	Following		string    `gorm:"foreignKey:Username"`
}

type User struct {
	Username      	string    	`gorm:"primarykey;unique"`
	Bio           	string    
	ProfilePicture 	string    
	Followers		[]Follows 	`gorm:"foreignkey:Followee"`
	Following 		[]Follows 	`gorm:"foreignkey:Following"`
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

func handler(ctx context.Context, req events.APIGatewayV2HTTPRequest) (Response, error) {
	switch req.RequestContext.HTTP.Method {
	case "POST":
		return create(ctx, req)
	// case "GET":
	// 	return read(req)
	case "DELETE":
		return delete(req)
	default:
		err := fmt.Errorf("HTTP Method '%s' not allowed", req.RequestContext.HTTP.Method)
		return Response{StatusCode: 405, Body: err.Error()}, err
	}
}

// Create a follow relationship 
// @PARAMS - followee (string), following (string)
func create(ctx context.Context, req events.APIGatewayV2HTTPRequest) (Response, error) {
	db, err := connectDB()
	if err != nil {
		return Response{ StatusCode: 500, Body: err.Error() }, err
	}
	// db.AutoMigrate(&User{})
	// db.AutoMigrate(&Follows{})

	// TO DO: Update database to be uuid instead of username, reflect here
	// Unmarshal JSON request body into a Follows struct
	friends := new(Follows)
	err = json.Unmarshal([]byte(req.Body), &friends)
	if err != nil {
		return Response{StatusCode: 400, Body: "Invalid request data format"}, err
	}

	// Add the follow relationship to the database
	err = db.Create(&friends).Error
	if err != nil {
		return Response{StatusCode: 500, Body: "Error inserting data into database"}, err
	}

	// Woo Hoo !!!
	return Response{
		StatusCode: 201,
		Body:       "Successfully added to database",
	}, nil
}

// Get's list of people the user is following
// @PARAMS - username (string)
// func read(req events.APIGatewayProxyRequest) (Response, error) {
// 	db, err := connectDB()
// 	if err != nil {
// 		return Response{StatusCode: 500, Body: err.Error()}, err
// 	}

// 	// Get the username from the JSON request body
// 	username, ok := req.QueryStringParameters["username"]

// 	// Given the username, find 

// 	friends := new(Follows)
// 	err = json.Unmarshal([]byte(req.Body), &friends)
// 	if err != nil {
// 		return Response{StatusCode: 400, Body: "Invalid request data format"}, err
// 	}

// 	var followings []Following
// 	if err := db.Where("userID = ?", userID).Find(&followings).Error; err != nil {
// 		return Response{StatusCode: 500, Body: err.Error()}, err
// 	}

// 	followingsJSON, err := json.Marshal(followings)
// 	if err != nil {
// 		return Response{StatusCode: 500, Body: err.Error()}, err
// 	}

// 	return Response{StatusCode: 200, Body: string(followingsJSON)}, nil
// }

// User unfollows someone
func delete(req events.APIGatewayV2HTTPRequest) (Response, error) {
	db, err := connectDB()
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, err
	}

	// Get the followee and follower from the JSON request
	unfriend := new(Follows)
	err = json.Unmarshal([]byte(req.Body), &unfriend)
	if err != nil {
		return Response{StatusCode: 400, Body: "Invalid request data format"}, err
	}

	// Find these two values in the database
	if err := db.Where("followee = ? AND following = ?", &unfriend.Followee, &unfriend.Following).Delete(&unfriend).Error; err != nil {
		return Response{StatusCode: 404, Body: "Cannot delete."}, nil
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