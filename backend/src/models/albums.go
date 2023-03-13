package models

import (
	"context"
)

type FavoriteAlbum struct {
	Username string
	AlbumID  string
}

type ListenLaterAlbum struct {
	Username string
	AlbumID  string
}

func GetFavoriteAlbums(ctx context.Context, username string) (*[]FavoriteAlbum, error) {
	db, err := GetDBFromContext(ctx)
	if err != nil {
		return nil, err
	}

	var favoriteAlbums []FavoriteAlbum
	if err := db.Where("username = ?", username).Find(&favoriteAlbums).Error; err != nil {
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

func GetListenLaterAlbums(ctx context.Context, username string) (*[]ListenLaterAlbum, error) {
	db, err := GetDBFromContext(ctx)
	if err != nil {
		return nil, err
	}

	var listenLaterAlbums []ListenLaterAlbum
	if err := db.Where("username = ?", username).Find(&listenLaterAlbums).Error; err != nil {
		return nil, err
	}

	return &listenLaterAlbums, nil
}

func CreateListenLaterAlbum(ctx context.Context, listenLaterAlbum *ListenLaterAlbum) error {
	if db, err := GetDBFromContext(ctx); err != nil {
		return err
	} else if err := db.Create(&listenLaterAlbum).Error; err != nil {
		return err
	}

	return nil
}

func DeleteListenLaterAlbum(ctx context.Context, listenLaterAlbum *ListenLaterAlbum) error {
	if db, err := GetDBFromContext(ctx); err != nil {
		return err
	} else if err := db.Where("username = ? AND album_id = ?", &listenLaterAlbum.Username, &listenLaterAlbum.AlbumID).Delete(&listenLaterAlbum).Error; err != nil {
		return err
	}

	return nil
}
