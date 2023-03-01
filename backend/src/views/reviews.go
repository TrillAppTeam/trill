package views

import (
	"context"
	"time"
	"trill/src/models"
)

type Review struct {
	ReviewID       int       `json:"review_id"`
	Username       string    `json:"username"`
	AlbumID        string    `json:"album_id"`
	Rating         int       `json:"rating"`
	ReviewText     string    `json:"review_text"`
	CreatedAt      time.Time `json:"created_at"`
	UpdatedAt      time.Time `json:"updated_at"`
	Likes          int       `json:"likes"`
	RequestorLiked bool      `json:"requestor_liked"`
}

// Combines the two JSON's to one string
func MarshalReview(ctx context.Context, reviewModel *models.Review, requestor string) (string, error) {
	requestorLiked := false
	for _, user := range reviewModel.Likes {
		if user.Username == requestor {
			requestorLiked = true
			break
		}
	}

	review := Review{
		ReviewID:       reviewModel.ReviewID,
		Username:       reviewModel.Username,
		AlbumID:        reviewModel.AlbumID,
		Rating:         reviewModel.Rating,
		ReviewText:     reviewModel.ReviewText,
		CreatedAt:      reviewModel.CreatedAt,
		UpdatedAt:      reviewModel.UpdatedAt,
		Likes:          len(reviewModel.Likes),
		RequestorLiked: requestorLiked,
	}

	return Marshal(ctx, review)
}

func UnmarshalReview(ctx context.Context, marshalledReview string, reviewModel *models.Review) error {
	return Unmarshal(ctx, marshalledReview, reviewModel)
}
