package models

import (
	"context"
)

type Like struct {
	Username string `gorm:"foreignKey:Username"` // `json:"username"`
	ReviewID int    `gorm:"foreignKey:ReviewID"` // `json:"review_id"`
}

func GetLikes(ctx context.Context, reviewID string) (*[]Like, error) {
	db, err := GetDBFromContext(ctx)
	if err != nil {
		return nil, err
	}

	var likes []Like
	if err := db.Where("review_id = ?", reviewID).Find(&likes).Error; err != nil {
		return nil, err
	} else {
		return &likes, nil
	}
}

func CreateLike(ctx context.Context, like *Like) error {
	if db, err := GetDBFromContext(ctx); err != nil {
		return err
	} else if err := db.Create(&like).Error; err != nil {
		return err
	}

	return nil
}

func DeleteLike(ctx context.Context, like *Like) error {
	if db, err := GetDBFromContext(ctx); err != nil {
		return err
	} else if err := db.Where("username = ? AND review_id = ?", &like.Username, &like.ReviewID).Delete(&like).Error; err != nil {
		return err
	}

	return nil
}
