package views

import (
	"context"
	"trill/src/models"
)

type FullUser struct {
	Username         string        `json:"username"`
	Bio              string        `json:"bio"`
	Email            string        `json:"email,omitempty"`
	Nickname         string        `json:"nickname"`
	ProfilePicture   string        `json:"profile_picture"`
	Following        []models.User `json:"following"`
	Followers        []models.User `json:"followers"`
	RequestorFollows bool          `json:"requestor_follows"`
	FollowsRequestor bool          `json:"follows_requestor"`
}

// Combines the two JSON's to one string
func MarshalFullUser(ctx context.Context, userModel *models.User, privateCognitoUserModel *models.PrivateCognitoUser,
	following *[]models.User, followers *[]models.User, requestorFollows bool, followsRequestor bool) (string, error) {
	user := FullUser{
		Username:         userModel.Username,
		Nickname:         userModel.Nickname,
		Bio:              userModel.Bio,
		ProfilePicture:   userModel.ProfilePicture,
		Email:            privateCognitoUserModel.Email,
		Following:        *following,
		Followers:        *followers,
		RequestorFollows: requestorFollows,
		FollowsRequestor: followsRequestor,
	}

	return Marshal(ctx, user)
}

func MarshalUsers(ctx context.Context, userModels *[]models.User) (string, error) {
	return Marshal(ctx, userModels)
}

func UnmarshalUser(ctx context.Context, marshalledUser string, userModel *models.User) error {
	return Unmarshal(ctx, marshalledUser, userModel)
}
