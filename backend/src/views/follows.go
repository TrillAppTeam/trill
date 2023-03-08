package views

import (
	"context"
	"trill/src/models"
)

type Follows struct {
	Users []string `json:"users"`
}

func UnmarshalFollows(ctx context.Context, marshalledFollows string, followsModel *models.Follows) error {
	return Unmarshal(ctx, marshalledFollows, followsModel)
}
