package handlers

import (
	"context"
	"trill/src/views"
)

func UnmarshalSpotify(ctx context.Context, buf []byte, spotifyView interface{}) *Response {
	if err := views.UnmarshalSpotify(ctx, buf, spotifyView); err != nil {
		spotifyError := err.Error
		return &Response{
			StatusCode: spotifyError.Status,
			Body:       "Spotify request error: " + spotifyError.Message,
			Headers:    views.DefaultHeaders,
		}
	}

	return nil
}

func GenerateResponseFromSpotifyBody(ctx context.Context, buf []byte,
	spotifyView interface{}, marshaller func(context.Context, interface{}) (string, error)) Response {
	if resp := UnmarshalSpotify(ctx, buf, spotifyView); resp != nil {
		return *resp
	}
	if body, err := marshaller(ctx, spotifyView); err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}
	} else {
		return Response{StatusCode: 200, Body: body, Headers: views.DefaultHeaders}
	}
}
