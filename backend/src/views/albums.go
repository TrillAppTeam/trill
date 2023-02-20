package views

import (
	"context"
	"encoding/json"
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

func MarshalSpotifyAlbum(ctx context.Context, unmarshalledSpotifyAlbum *SpotifyAlbum) (string, error) {
	return Marshal(ctx, unmarshalledSpotifyAlbum)
}

func UnmarshalSpotifyAlbum(ctx context.Context, marshalledSpotifyAlbum []byte, spotifyAlbumView *SpotifyAlbum) error {
	err := json.Unmarshal(marshalledSpotifyAlbum, spotifyAlbumView)
	if err != nil {
		return err
	}
	return nil
}

func MarshalSpotifyAlbums(ctx context.Context, unmarshalledSpotifyAlbums *[]SpotifyAlbum) (string, error) {
	return Marshal(ctx, unmarshalledSpotifyAlbums)
}

func UnmarshalSpotifyAlbums(ctx context.Context, marshalledSpotifyAlbums []byte, spotifyAlbumsView *SpotifyAlbums) error {
	err := json.Unmarshal(marshalledSpotifyAlbums, spotifyAlbumsView)
	if err != nil {
		return err
	}
	return nil
}
