package models

import (
	"context"
	"errors"
	"fmt"
	"time"

	"gorm.io/gorm"
)

type Review struct {
	ReviewID   int
	Username   string
	AlbumID    string
	Rating     int
	ReviewText string    `json:"review_text"`
	CreatedAt  time.Time `gorm:"default:CURRENT_TIMESTAMP"`
	UpdatedAt  time.Time `gorm:"default:CURRENT_TIMESTAMP"`
	Likes      []Like    `gorm:"foreignKey:ReviewID;references:ReviewID;constraint:OnDelete:CASCADE;"`
}

var (
	ErrorReviewNotFound   error = errors.New("review does not exist")
	ErrorInvalidArguments error = errors.New("invalid arguments provided to GetReviews")
)

func GetReview(ctx context.Context, username string, albumID string) (*Review, error) {
	db, err := GetDBFromContext(ctx)
	if err != nil {
		return nil, err
	}

	var review *Review
	if result := db.Preload("Likes").Where("username = ? AND album_id = ?", username, albumID).Limit(1).Find(&review); result.Error != nil {
		return nil, err
	} else if result.RowsAffected == 0 {
		return nil, ErrorReviewNotFound
	} else {
		return review, nil
	}
}

func GetReviews(ctx context.Context, review *Review, following *[]Follows, sort string) (*[]Review, error) {
	db, err := GetDBFromContext(ctx)
	if err != nil {
		return nil, err
	}

	prepend := ""
	if sort == "popular" {
		prepend = "reviews."
	}

	query := make(map[string]interface{})
	if following != nil {
		followingUsernames := make([]string, len(*following))
		for i, f := range *following {
			followingUsernames[i] = f.Following
		}
		query[fmt.Sprintf("%susername", prepend)] = followingUsernames
	}

	if len(review.AlbumID) != 0 {
		query[fmt.Sprintf("%salbum_id", prepend)] = review.AlbumID
	} else if len(review.Username) != 0 && following == nil {
		query[fmt.Sprintf("%susername", prepend)] = review.Username
	}

	var reviews *[]Review
	var result *gorm.DB
	switch sort {
	case "newest":
		result = db.Preload("Likes").Where(query).Order("created_at desc").Find(&reviews)
	case "oldest":
		result = db.Preload("Likes").Where(query).Order("created_at asc").Find(&reviews)
	case "popular":
		result = db.Preload("Likes").
			Joins("LEFT JOIN likes ON reviews.review_id = likes.review_id").
			Where(query).
			Group("reviews.review_id").
			Order("COUNT(likes.review_id) DESC").
			Find(&reviews)
	}
	if err := result.Error; err != nil {
		return nil, err
	}

	return reviews, nil
}

func CreateReview(ctx context.Context, review *Review) error {
	if db, err := GetDBFromContext(ctx); err != nil {
		return err
	} else if updateRes := db.Model(&review).Where("username = ? AND album_id = ?", &review.Username, &review.AlbumID).Updates(&review); updateRes.Error != nil {
		return err
	} else if updateRes.RowsAffected == 0 {
		err = db.Create(&review).Error
		if err != nil {
			return err
		}
	}

	return nil
}

func DeleteReview(ctx context.Context, review *Review) error {
	if db, err := GetDBFromContext(ctx); err != nil {
		return err
	} else if err := db.Model(&review).Where("username = ? AND album_id = ?", &review.Username, &review.AlbumID).Delete(&review).Error; err != nil {
		return err
	}

	return nil
}
