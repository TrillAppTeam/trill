package models

import (
	"context"
)

type Follows struct {
	Followee  string `gorm:"foreignKey:Username"`
	Following string `gorm:"foreignKey:Username"`
}

// TODO consolidate GetFollowing and GetFollowers
func GetFollowing(ctx context.Context, followee string) (*[]User, error) {
	db, err := GetDBFromContext(ctx)
	if err != nil {
		return nil, err
	}

	var following []Follows
	if err := db.Where("followee = ?", followee).Find(&following).Error; err != nil {
		return nil, err
	}

	usernames := make([]string, len(following))
	for i, f := range following {
		usernames[i] = f.Following
	}
	users, err := GetUsers(ctx, usernames)
	if err != nil {
		return nil, err
	}

	return users, nil
}

func GetFollowers(ctx context.Context, followee string) (*[]User, error) {
	db, err := GetDBFromContext(ctx)
	if err != nil {
		return nil, err
	}

	var followers []Follows
	if err := db.Where("following = ?", followee).Find(&followers).Error; err != nil {
		return nil, err
	}

	usernames := make([]string, len(followers))
	for i, f := range followers {
		usernames[i] = f.Followee
	}
	users, err := GetUsers(ctx, usernames)
	if err != nil {
		return nil, err
	}

	return users, nil
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

// true if followee follows following
func IsFollowing(ctx context.Context, followee string, following string) (bool, error) {
	db, err := GetDBFromContext(ctx)
	if err != nil {
		return false, err
	}

	var count int64
	result := db.Model(&Follows{}).Where("following = ? AND followee = ?", following, followee).Count(&count)
	if result.Error != nil {
		return false, result.Error
	}

	return count > 0, nil
}
