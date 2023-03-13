package views

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"trill/src/models"
)

type SpotifyView interface {
	Marshal(context.Context) (string, error)
}

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
	Albums []SpotifyAlbum `json:"albums"`
}

type SpotifyAlbumSearch struct {
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

func (s *SpotifyAlbum) Marshal(ctx context.Context) (string, error) {
	return Marshal(ctx, s)
}

func (s *SpotifyAlbums) Marshal(ctx context.Context) (string, error) {
	return Marshal(ctx, s.Albums)
}

func (s *SpotifyAlbumSearch) Marshal(ctx context.Context) (string, error) {
	return Marshal(ctx, s.Albums.Items)
}

func UnmarshalSpotify(ctx context.Context, marshalledSpotify []byte, spotifyView SpotifyView) *SpotifyError {
	errorResponse := new(SpotifyError)
	json.Unmarshal(marshalledSpotify, &errorResponse)
	if errorResponse.Error != nil {
		return errorResponse
	}

	json.Unmarshal(marshalledSpotify, spotifyView)
	fmt.Printf("%+v\n", spotifyView)
	return nil
}

func MarshalFavoriteAlbum(ctx context.Context, unmarshalledFavoriteAlbums *FavoriteAlbum) (string, error) {
	return Marshal(ctx, unmarshalledFavoriteAlbums)
}

func UnmarshalFavoriteAlbum(ctx context.Context, marshalledFavoriteAlbum string, favoriteAlbumModel *models.FavoriteAlbum) error {
	return Unmarshal(ctx, marshalledFavoriteAlbum, favoriteAlbumModel)
}
