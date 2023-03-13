package views

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"trill/src/models"
)

type SpotifyAlbum struct {
	AlbumType    string `json:"album_type"`
	ExternalUrls struct {
		Spotify string `json:"spotify"`
	} `json:"external_urls"`
	Href   string `json:"href"`
	ID     string `json:"id"`
	Images []struct {
		URL    string `json:"url"`
		Height int    `json:"height"`
		Width  int    `json:"width"`
	} `json:"images"`
	Name        string   `json:"name"`
	ReleaseDate string   `json:"release_date"`
	Type        string   `json:"type"`
	URI         string   `json:"uri"`
	Genres      []string `json:"genres"`
	Label       string   `json:"label"`
	Popularity  int      `json:"popularity"`
	Artists     []struct {
		ID   string `json:"id"`
		Name string `json:"name"`
		Type string `json:"type"`
		URI  string `json:"uri"`
	} `json:"artists"`
}

type SpotifyAlbums struct {
	Albums struct {
		Href     string         `json:"href"`
		Items    []SpotifyAlbum `json:"items"`
		Limit    int            `json:"limit"`
		Next     string         `json:"next"`
		Offset   int            `json:"offset"`
		Previous string         `json:"previous"`
		Total    int            `json:"total"`
	} `json:"albums"`
}

type SpotifyError struct {
	Error *struct {
		Status  int    `json:"status"`
		Message string `json:"message"`
	} `json:"error"`
}

type FavoriteAlbum struct {
	Username string `json:"username"`
	AlbumID  string `json:"album_id"`
}

var (
	ErrorSpotifyAlbumCast  error = errors.New("invalid type for unmarshalledSpotifyAlbum")
	ErrorSpotifyAlbumsCast error = errors.New("invalid type for unmarshalledSpotifyAlbums")
)

func MarshalSpotifyAlbum(ctx context.Context, unmarshalledSpotifyAlbum interface{}) (string, error) {
	return Marshal(ctx, unmarshalledSpotifyAlbum)
}

func MarshalSpotifyAlbums(ctx context.Context, unmarshalledSpotifyAlbums interface{}) (string, error) {
	fmt.Printf("in marshalspotifyalbums: %p\n", &unmarshalledSpotifyAlbums)
	fmt.Printf("%+v\n", unmarshalledSpotifyAlbums)
	spotifyAlbums, ok := unmarshalledSpotifyAlbums.(*SpotifyAlbums)
	if !ok {
		return "", ErrorSpotifyAlbumsCast
	}
	return Marshal(ctx, spotifyAlbums.Albums.Items)
}

func UnmarshalSpotify(ctx context.Context, marshalledSpotify []byte, spotifyView interface{}) *SpotifyError {
	errorResponse := new(SpotifyError)
	json.Unmarshal(marshalledSpotify, &errorResponse)
	if errorResponse.Error != nil {
		return errorResponse
	}

	json.Unmarshal(marshalledSpotify, spotifyView)
	return nil
}

func MarshalFavoriteAlbum(ctx context.Context, unmarshalledFavoriteAlbums *FavoriteAlbum) (string, error) {
	return Marshal(ctx, unmarshalledFavoriteAlbums)
}

func UnmarshalFavoriteAlbum(ctx context.Context, marshalledFavoriteAlbum string, favoriteAlbumModel *models.FavoriteAlbum) error {
	return Unmarshal(ctx, marshalledFavoriteAlbum, favoriteAlbumModel)
}
