package models

import (
	"context"
)

type FavoriteAlbum struct {
	Username string
	AlbumID  string
}

func GetFavoriteAlbums(ctx context.Context, username string) (*[]FavoriteAlbum, error) {
	db, err := GetDBFromContext(ctx)
	if err != nil {
		return nil, err
	}

	var favoriteAlbums []FavoriteAlbum
	if err := db.Table("favorite_albums").Where("username = ?", username).Find(&favoriteAlbums).Error; err != nil {
		return nil, err
	}

	return &favoriteAlbums, nil
}

func CreateFavoriteAlbum(ctx context.Context, favoriteAlbum *FavoriteAlbum) error {
	if db, err := GetDBFromContext(ctx); err != nil {
		return err
	} else if err := db.Create(&favoriteAlbum).Error; err != nil {
		return err
	}

	return nil
}

func DeleteFavoriteAlbum(ctx context.Context, favoriteAlbum *FavoriteAlbum) error {
	if db, err := GetDBFromContext(ctx); err != nil {
		return err
	} else if err := db.Where("username = ? AND album_id = ?", &favoriteAlbum.Username, &favoriteAlbum.AlbumID).Delete(&favoriteAlbum).Error; err != nil {
		return err
	}

	return nil
}
