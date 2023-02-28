package models

import (
	"context"
)

type Follows struct {
	Followee  string `gorm:"foreignKey:Username"`
	Following string `gorm:"foreignKey:Username"`
}

func GetFollowing(ctx context.Context, followee string) (*[]Follows, error) {
	db, err := GetDBFromContext(ctx)
	if err != nil {
		return nil, err
	}

	var following []Follows
	if err := db.Where("followee = ?", followee).Find(&following).Error; err != nil {
		return nil, err
	}

	return &following, nil
}

func GetFollowers(ctx context.Context, followee string) (*[]Follows, error) {
	db, err := GetDBFromContext(ctx)
	if err != nil {
		return nil, err
	}

	var followers []Follows
	if err := db.Where("following = ?", followee).Find(&followers).Error; err != nil {
		return nil, err
	}

	return &followers, nil
}

func CreateFollow(ctx context.Context, follows *Follows) error {
	if db, err := GetDBFromContext(ctx); err != nil {
		return err
	} else if err := db.Create(&follows).Error; err != nil {
		return err
	}

	return nil
}

func DeleteFollow(ctx context.Context, follows *Follows) error {
	if db, err := GetDBFromContext(ctx); err != nil {
		return err
	} else if err := db.Where("followee = ? AND following = ?", follows.Followee, follows.Following).Delete(follows).Error; err != nil {
		return err
	}

	return nil
}
