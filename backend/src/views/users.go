package views

import (
	"context"
	"trill/src/models"
)

type User struct {
	Username       string `json:"username"`
	Bio            string `json:"bio"`
	Email          string `json:"email,omitempty"`
	Nickname       string `json:"nickname,omitempty"`
	ProfilePicture string `json:"profile_picture"`
}

// Combines the two JSON's to one string
func MarshalFullUser(ctx context.Context, userModel *models.User, publicCognitoUserModel *models.PublicCognitoUser,
	privateCognitoUserModel *models.PrivateCognitoUser) (string, error) {
	user := User{
		Username:       userModel.Username,
		Bio:            userModel.Bio,
		Email:          privateCognitoUserModel.Email,
		Nickname:       publicCognitoUserModel.Nickname,
		ProfilePicture: userModel.ProfilePicture,
	}

	return Marshal(ctx, user)
}

func MarshalUsers(ctx context.Context, userModels *[]models.User) (string, error) {
	return Marshal(ctx, userModels)
}

func UnmarshalUser(ctx context.Context, marshalledUser string, userModel *models.User) error {
	return Unmarshal(ctx, marshalledUser, userModel)
}

func UnmarshalPublicCognitoUser(ctx context.Context, marshalledPublicCognitoUser string, publicCognitoUserModel *models.PublicCognitoUser) error {
	return Unmarshal(ctx, marshalledPublicCognitoUser, publicCognitoUserModel)
}
