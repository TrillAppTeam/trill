package models

import (
	"context"
)

type FavoriteAlbums struct {
	Username string
	AlbumID  string
}

func GetFavoriteAlbums(ctx context.Context, username string) (*[]FavoriteAlbums, error) {
	db, err := ConnectDB()
	if err != nil {
		return nil, err
	}

	var favoriteAlbums []FavoriteAlbums
	if err := db.Table("favorite_albums").Where("username = ?", username).Find(&favoriteAlbums).Error; err != nil {
		return nil, err
	}

	return &favoriteAlbums, nil
}

func CreateFavoriteAlbums(ctx context.Context, follows *Follows) error {
	if db, err := ConnectDB(); err != nil {
		return err
	} else if err := db.Create(&follows).Error; err != nil {
		return err
	}

	return nil
}

func DeleteFavoriteAlbums(ctx context.Context, followee string, follower string) error {
	if db, err := ConnectDB(); err != nil {
		return err
	} else if err := db.Where("followee = ? AND following = ?", followee, follower).Delete(&Follows{}).Error; err != nil {
		return err
	}

	return nil
}
