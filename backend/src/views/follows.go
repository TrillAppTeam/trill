package views

import (
	"context"
	"trill/src/models"
)

type Follows struct {
<<<<<<< HEAD
	Followee  string   `json:"followee"`
	Following []string `json:"following"`
}

// Combines the two JSON's to one string
func MarshalFollows(ctx context.Context, followsModel *[]models.Follows) (string, error) {
=======
	Users []string `json:"users"`
}

func MarshalFollowing(ctx context.Context, followsModel *[]models.Follows) (string, error) {
>>>>>>> main
	following := make([]string, len(*followsModel))
	for i, f := range *followsModel {
		following[i] = f.Following
	}
	follows := Follows{
<<<<<<< HEAD
		Followee:  (*followsModel)[0].Followee,
		Following: following,
=======
		Users: following,
	}

	return Marshal(ctx, follows)
}

func MarshalFollowers(ctx context.Context, followsModel *[]models.Follows) (string, error) {
	followers := make([]string, len(*followsModel))
	for i, f := range *followsModel {
		followers[i] = f.Followee
	}
	follows := Follows{
		Users: followers,
>>>>>>> main
	}

	return Marshal(ctx, follows)
}

func UnmarshalFollows(ctx context.Context, marshalledFollows string, followsModel *models.Follows) error {
	return Unmarshal(ctx, marshalledFollows, followsModel)
}
