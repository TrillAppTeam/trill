package views

import (
	"context"
	"trill/src/models"
)

type Follows struct {
	Followee  string   `json:"followee"`
	Following []string `json:"following"`
}

// Combines the two JSON's to one string
func MarshalFollows(ctx context.Context, followsModel *[]models.Follows) (string, error) {
	following := make([]string, len(*followsModel))
	for i, f := range *followsModel {
		following[i] = f.Following
	}
	follows := Follows{
		Followee:  (*followsModel)[0].Followee,
		Following: following,
	}

	return Marshal(ctx, follows)
}

func UnmarshalFollows(ctx context.Context, marshalledFollows string, followsModel *models.Follows) error {
	return Unmarshal(ctx, marshalledFollows, followsModel)
}
