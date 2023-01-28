package main

import (
	"context"
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

type User struct {
	gorm.Model
	FirstNames string // `sql:"varchar(200)"`
	LastName   string // `sql:"varchar(200)"`
	Username   string // `sql:"varchar(200)"`
	Password   string // `sql:"varchar(200)"`
	Email      string // `sql:"varchar(200)"`
	Bio        string // `sql:"varchar(200)"`
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
		return nil, fmt.Errorf("Error: Failed to connect to AWS RDS: %w", err)
	} else {
		return db, nil
	}
}

func handler(ctx context.Context, req events.APIGatewayProxyRequest) (Response, error) {
	switch req.HTTPMethod {
	case "POST":
		return create(ctx, req)
	// case "GET":
	// 	return read(req)
	// case "PUT":
	// 	return update(req)
	// case "DELETE":
	// 	return delete(req)
	default:
		err := fmt.Errorf("HTTP Method '%s' not allowed", req.HTTPMethod)
		return Response{StatusCode: 405, Body: err.Error()}, err
	}
}

func create(ctx context.Context, req events.APIGatewayProxyRequest) (Response, error) {
	_, err := connectDB()
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, err
	}
	return Response{StatusCode: 200, Body: "Success"}, nil

	// cfg, err := config.LoadDefaultConfig(
	// 	ctx, config.WithRegion("{aws-region}"),
	// )
	// if err != nil {
	// 	return Response{StatusCode: 500, Body: err.Error()}, err
	// }

	// cognito := cognitoidentityprovider.NewFromConfig(cfg)
	// req := cognito.SignUp(ctx, &cognitoidentityprovider.SignUpInput{
	// 	ClientId: aws.String(),
	// })

	// return Response{StatusCode: 200, Body: fmt.Sprintf("+v", req.RequestContext.Authorizer["claims"])}, nil

	// handle email in use
	// handle username in use

	// user := User{FirstName: "Based", LastName: "User", Username: "baseduser123", Password: "pass", Email: "123", Bio: "Sooo based"}
	// log.Printf("%+v\n", user)

	// db.AutoMigrate(&User{})

	// var users []User
	// log.Printf("%+v\n", users)

	// // db.Exec("INSERT INTO users (firstName, lastName, username, password, email, bio) VALUES ("Ash", "V", "avv", "pw", "av@g", "hi");")

	// // https://stackoverflow.com/questions/30361671/how-can-i-check-for-errors-in-crud-operations-using-gorm
	// if res := db.Create(&user); res.Error != nil {
	// 	return Response{StatusCode: 500, Body: res.Error.Error()}, res.Error
	// } else {
	// 	return Response{StatusCode: 200, Body: fmt.Sprint(user.ID, user.FirstName, user.LastName)}, nil
	// }
}

func main() {
	lambda.Start(handler)
}
