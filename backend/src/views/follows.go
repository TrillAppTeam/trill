package views

import (
	"context"
	"trill/src/models"
)

type Follows struct {
	Users []string `json:"users"`
}

func MarshalFollowing(ctx context.Context, followsModel *[]models.Follows) (string, error) {
	following := make([]string, len(*followsModel))
	for i, f := range *followsModel {
		following[i] = f.Following
	}
	follows := Follows{
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
	}

	return Marshal(ctx, follows)
}

func UnmarshalFollows(ctx context.Context, marshalledFollows string, followsModel *models.Follows) error {
	return Unmarshal(ctx, marshalledFollows, followsModel)
}
