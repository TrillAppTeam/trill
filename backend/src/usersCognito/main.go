package main

import (
	"context"
	"fmt"
	"log"
	"os"

	"gorm.io/driver/mysql"
	"gorm.io/gorm"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go-v2/service/cognitoidentityprovider"
)

const SECRETS_PATH = "../../.secrets.yml"

type CognitoEvent = events.CognitoEventUserPoolsPostConfirmation

type CognitoClient struct {
	Client      *cognitoidentityprovider.Client
	AppClientId string
	UserPoolId  string
}

type Secrets struct {
	host               string `yaml:"MYSQLHOST"`
	port               string `yaml:"MYSQLPORT"`
	database           string `yaml:"MYSQLDATABASE"`
	user               string `yaml:"MYSQLUSER"`
	password           string `yaml:"MYSQLPASS"`
	region             string `yaml:"AWS_DEFAULT_REGION"`
	cognitoAppClientId string `yaml:"COGNITO_APP_CLIENT_ID"`
	cognitoUserPoolId  string `yaml:"COGNITO_USER_POOL_ID"`
}

type User struct {
	Username       string `gorm:"varchar(128);primarykey"`
	Bio            string `gorm:"varchar(1024)"`
	ProfilePicture string `gorm:"varchar(512)"`
}

var secrets = Secrets{
	os.Getenv("MYSQLHOST"),
	os.Getenv("MYSQLPORT"),
	os.Getenv("MYSQLDATABASE"),
	os.Getenv("MYSQLUSER"),
	os.Getenv("MYSQLPASS"),
	os.Getenv("AWS_DEFAULT_REGION"),
	os.Getenv("COGNITO_APP_CLIENT_ID"),
	os.Getenv("COGNITO_USER_POOL_ID"),
}

// https://github.com/gugazimmermann/fazendadojuca/blob/master/animals/main.go

func connectDB() (*gorm.DB, error) {
	connectionString := fmt.Sprintf("%s:%s@tcp(%s:%s)/%s?allowNativePasswords=true&parseTime=true", secrets.user, secrets.password, secrets.host, secrets.port, secrets.database)
	if db, err := gorm.Open(mysql.Open(connectionString), &gorm.Config{}); err != nil {
		return nil, fmt.Errorf("error: failed to connect to AWS RDS: %w", err)
	} else {
		return db, nil
	}
}

func create(ctx context.Context, req CognitoEvent) (CognitoEvent, error) {
	db, err := connectDB()
	if err != nil {
		log.Println(err.Error())
		return req, err
	}

	// // make new user
	// username, ok := req.RequestContext.Authorizer.Lambda["username"].(string)
	// if !ok {
	// 	log.Println("Failed to cast usfmtername")
	// 	return req, nil
	// }

	NewUser := User{Username: req.UserName, Bio: "", ProfilePicture: ""}

	// https://stackoverflow.com/questions/30361671/how-can-i-check-for-errors-in-crud-operations-using-gorm
	if res := db.Create(&NewUser); res.Error != nil {
		log.Println(res.Error.Error())
		return req, res.Error
	} else {
		return req, nil
	}
}

func main() {
	lambda.Start(create)
}
