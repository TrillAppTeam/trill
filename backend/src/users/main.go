package main

import (
	"fmt"
	"log"
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
}

type User struct {
	gorm.Model
	FirstName string // `sql:"varchar(200)"`
	LastName  string // `sql:"varchar(200)"`
	Username  string // `sql:"varchar(200)"`
	Password  string // `sql:"varchar(200)"`
	Email     string // `sql:"varchar(200)"`
	Bio       string // `sql:"varchar(200)"`
}

var secrets = Secrets{
	os.Getenv("MYSQLHOST"),
	os.Getenv("MYSQLPORT"),
	os.Getenv("MYSQLDATABASE"),
	os.Getenv("MYSQLUSER"),
	os.Getenv("MYSQLPASS"),
}

func Handler(req events.APIGatewayProxyRequest) (Response, error) {
	connectionString := fmt.Sprintf(
		"%s:%s@tcp(%s:%s)/%s?allowNativePasswords=true", secrets.user, secrets.password, secrets.host, secrets.port, secrets.database,
	)

	db, err := gorm.Open(mysql.Open(connectionString), &gorm.Config{})

	if err != nil {
		log.Fatal("Error: Failed to connect to AWS RDS.")
	}

	user := User{FirstName: "Based", LastName: "User", Username: "baseduser123", Password: "pass", Email: "123", Bio: "Sooo based"}
	log.Printf("%+v\n", user)

	db.AutoMigrate(&User{})

	var users []User
	log.Printf("%+v\n", users)

	// db.Exec("INSERT INTO users (firstName, lastName, username, password, email, bio) VALUES ("Ash", "V", "avv", "pw", "av@g", "hi");")

	// https://stackoverflow.com/questions/30361671/how-can-i-check-for-errors-in-crud-operations-using-gorm
	if res := db.Create(&user); res.Error != nil {
		return Response{StatusCode: 500, Body: res.Error.Error()}, res.Error
	} else {
		return Response{StatusCode: 200, Body: fmt.Sprint(user.ID, user.FirstName, user.LastName)}, nil
	}
}

func main() {
	lambda.Start(Handler)
}
