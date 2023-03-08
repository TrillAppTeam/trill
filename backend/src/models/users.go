package models

import (
	"context"
	"errors"
	"log"
	"net/http"

	"github.com/aws/aws-sdk-go-v2/service/cognitoidentityprovider"
	"gorm.io/gorm"
)

type PrivateCognitoUser struct {
	Email string
}

type User struct {
	Username       string `json:"username" gorm:"varchar(128);primarykey"`
	Nickname       string `json:"nickname" gorm:"varchar(128)"`
	Bio            string `json:"bio" gorm:"varchar(1024)"`
	ProfilePicture string `json:"profile_picture" gorm:"varchar(512)"`
}

func GetPrivateCognitoUser(ctx context.Context, authToken string) (*PrivateCognitoUser, error) {
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
	for _, v := range cogInfo.UserAttributes {
		if *v.Name == "email" {
			email = *v.Value
		}
	}

	if len(email) == 0 {
		return nil, errors.New("could not find user email")
	}

	return &PrivateCognitoUser{
		Email: email,
	}, nil
}

func GetUser(ctx context.Context, username string) (*User, error) {
	db, err := GetDBFromContext(ctx)
	if err != nil {
		return nil, err
	}

	// find and get user info from db
	var user User
	result := db.Where("username = ?", username).First(&user)
	if result.Error != nil {
		if errors.Is(result.Error, gorm.ErrRecordNotFound) {
			return nil, &HTTPError{Code: http.StatusNotFound, Err: errors.New("User not found in RDS")}
		} else {
			return nil, result.Error
		}
	}

	return &user, nil
}

func GetUsers(ctx context.Context, usernames []string) (*[]User, error) {
	db, err := GetDBFromContext(ctx)
	if err != nil {
		return nil, err
	}

	var users []User
	if err := db.Where("username IN ?", usernames).Find(&users).Error; err != nil {
		return nil, err
	}

	return &users, nil
}

func SearchUser(ctx context.Context, username string) (*[]User, error) {
	db, err := GetDBFromContext(ctx)
	if err != nil {
		return nil, err
	}

	var users []User
	// if err := db.Where("SOUNDEX(username) = SOUNDEX(?)", username).Limit(50).Find(&users).Error; err != nil {
	// if err := db.Where("MATCH(username) AGAINST(? IN BOOLEAN MODE)", searchTerm).Limit(50).Find(&users).Error; err != nil {
	if err := db.Where("username LIKE ?", "%"+username+"%").Find(&users).Error; err != nil {
		return nil, err
	}
	return &users, nil
}

func UpdateUser(ctx context.Context, user *User) error {
	db, err := GetDBFromContext(ctx)
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
	db, err := GetDBFromContext(ctx)
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
