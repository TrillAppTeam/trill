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

var (
	maxPopularAlbums = 10
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

func GetReviews(ctx context.Context, review *Review, following *[]User, paginate *Paginate) (*[]Review, error) {
	db, err := GetDBFromContext(ctx)
	if err != nil {
		return nil, err
	}
	queryBuilder, err := BuildQueryFromPaginate(db, paginate)
	if err != nil {
		return nil, err
	}

	prepend := ""
	if paginate.Sort == "popular" {
		prepend = "reviews."
	}

	query := make(map[string]interface{})
	if following != nil {
		usernames := make([]string, len(*following))
		for i, f := range *following {
			usernames[i] = f.Username
		}
		query[fmt.Sprintf("%susername", prepend)] = usernames
	}

	if len(review.AlbumID) != 0 {
		query[fmt.Sprintf("%salbum_id", prepend)] = review.AlbumID
	} else if len(review.Username) != 0 && following == nil {
		query[fmt.Sprintf("%susername", prepend)] = review.Username
	}

	var reviews *[]Review
	var result *gorm.DB
	switch paginate.Sort {
	case "newest":
		result = queryBuilder.Preload("Likes").Where(query).Order("created_at desc").Find(&reviews)
	case "oldest":
		result = queryBuilder.Preload("Likes").Where(query).Order("created_at asc").Find(&reviews)
	case "popular":
		result = queryBuilder.Preload("Likes").
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

func GetPopularAlbumsFromReviews(ctx context.Context, timespan string) (*[]string, error) {
	db, err := GetDBFromContext(ctx)
	if err != nil {
		return nil, err
	}

	var results *[]struct {
		AlbumID string
	}
	day := -24 * time.Hour
	threshold := time.Now()
	switch timespan {
	case "weekly":
		threshold = threshold.Add(7 * day)
	case "monthly":
		threshold = threshold.Add(30 * day)
	case "yearly":
		threshold = threshold.Add(365 * day)
	case "all":
		threshold = time.Time{}
	}

	err = db.Model(&Review{}).
		Select("album_id, COUNT(*) as count").
		Where("created_at >= ?", threshold).
		Group("album_id").
		Order("count DESC").
		Limit(maxPopularAlbums).
		Find(&results).Error
	if err != nil {
		return nil, err
	}

	albums := make([]string, maxPopularAlbums)
	for i, a := range *results {
		albums[i] = a.AlbumID
	}

	return &albums, nil
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
