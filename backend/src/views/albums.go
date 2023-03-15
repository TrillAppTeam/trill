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
	Name        string `json:"name"`
	ID          string `json:"id"`
	ReleaseDate string `json:"release_date"`

	Artists []struct {
		ID   string `json:"id"`
		Name string `json:"name"`
		Type string `json:"type"`
		URI  string `json:"uri"`
	} `json:"artists"`
	Images []struct {
		URL    string `json:"url"`
		Height int    `json:"height"`
		Width  int    `json:"width"`
	} `json:"images"`

	AverageRating float64 `json:"average_rating,omitempty"`
	NumRatings    int     `json:"num_ratings,omitempty"`

	RequestorReviewed  bool `json:"requestor_reviewed,omitempty"`
	RequestorFavorited bool `json:"requestor_favorited,omitempty"`
	InListenLater      bool `json:"in_listen_later,omitempty"`

	Label      string   `json:"label"`
	Genres     []string `json:"genres"`
	Popularity int      `json:"popularity"`

	URI          string `json:"uri"`
	Href         string `json:"href"`
	ExternalUrls struct {
		Spotify string `json:"spotify"`
	} `json:"external_urls"`

	AlbumType string `json:"album_type"`
	Type      string `json:"type"`
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

func MarshalDetailedAlbum(ctx context.Context, album SpotifyAlbum, reviewStats models.ReviewStats) (string, error) {
	album.AverageRating = reviewStats.AverageRating
	album.NumRatings = reviewStats.NumRatings
	album.RequestorReviewed = reviewStats.RequestorReviewed

	return Marshal(ctx, album)
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
