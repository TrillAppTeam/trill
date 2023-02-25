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
	ProfilePicture string `json:"profilePicture"`
}

// Combines the two JSON's to one string
func MarshalUser(ctx context.Context, userModel *models.User, publicCognitoUserModel *models.PublicCognitoUser,
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

func UnmarshalUser(ctx context.Context, marshalledUser string, userModel *models.User) error {
	return Unmarshal(ctx, marshalledUser, userModel)
}
