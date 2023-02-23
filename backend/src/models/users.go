package models

import (
	"context"
	"errors"
	"log"

	"github.com/aws/aws-sdk-go-v2/service/cognitoidentityprovider"
)

type CognitoUser struct {
	Email    string
	Nickname string
}

type User struct {
	// gorm.Model
	// CreatedAt      time.Time
	// UpdatedAt      time.Time
	// DeletedAt      time.Time `gorm:"index"`
	Username       string `gorm:"varchar(128);primarykey"`
	Bio            string `gorm:"varchar(1024)"`
	ProfilePicture string `gorm:"varchar(512)"`
}

func GetCognitoUser(ctx context.Context, authToken string) (*CognitoUser, error) {
	cognitoClient, err := InitCognitoClient(ctx)
	if err != nil {
		return nil, err
	}

	cognitoUserInput := cognitoidentityprovider.GetUserInput{
		AccessToken: &authToken,
	}

	cogInfo, err := cognitoClient.Client.GetUser(ctx, &cognitoUserInput)
	if err != nil {
		return nil, err
	}

	// get email from user attributes
	email := ""
	nickname := ""
	for _, v := range cogInfo.UserAttributes {
		if *v.Name == "email" {
			email = *v.Value
		} else if *v.Name == "nickname" {
			nickname = *v.Value
		}
	}

	if len(email) == 0 {
		return nil, errors.New("could not find user email")
	} else if len(nickname) == 0 {
		return nil, errors.New("could not find user nickname")
	}

	return &CognitoUser{
		Email:    email,
		Nickname: nickname,
	}, nil
}

func GetUser(ctx context.Context, username string) (*User, error) {
	db, err := ConnectDB()
	if err != nil {
		return nil, err
	}

	// find and get user info from db
	var user User
	result := db.Where("username = ?", username).First(&user)
	if result.Error != nil {
<<<<<<< HEAD
		return nil, result.Error
=======
		return nil, errors.New("user not found in RDS")
>>>>>>> main
	}

	return &user, nil
}

func UpdateUser(ctx context.Context, user *User) error {
	db, err := ConnectDB()
	if err != nil {
		return err
	}

	updatedUser := db.Save(&user)
	if updatedUser.Error != nil {
		return updatedUser.Error
	}

	return nil
}

func CreateUser(ctx context.Context, user *User) error {
	db, err := ConnectDB()
	if err != nil {
		return err
	}

	// https://stackoverflow.com/questions/30361671/how-can-i-check-for-errors-in-crud-operations-using-gorm
	if res := db.Create(&user); res.Error != nil {
		log.Println(res.Error.Error())
		return res.Error
	} else {
		return nil
	}
}
