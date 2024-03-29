package utils

import (
	"bytes"
	"context"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"net/url"
	"strings"
)

type SpotifyToken struct {
	AccessToken string `json:"access_token"`
	TokenType   string `json:"token_type"`
	ExpiresIn   int    `json:"expires_in"`
}

var (
	AlbumAPIURL       string = "https://api.spotify.com/v1/albums/%s"
	AlbumsAPIURL      string = "https://api.spotify.com/v1/albums?ids=%s"
	AlbumSearchAPIURL string = "https://api.spotify.com/v1/search?q=%s&type=album"
)

func GetSpotifyToken() (*SpotifyToken, error) {
	var secrets = GetSecrets()

	client := &http.Client{}
	body := url.Values{}
	body.Set("grant_type", "client_credentials")
	authHeader := base64.StdEncoding.EncodeToString([]byte(secrets.SpotifyID + ":" + secrets.SpotifySecret))

	reqBody := strings.NewReader(body.Encode())
	request, err := http.NewRequest("POST", "https://accounts.spotify.com/api/token", reqBody)
	if err != nil {
		return nil, err
	}

	request.Header.Set("Authorization", "Basic "+authHeader)
	request.Header.Set("Content-Type", "application/x-www-form-urlencoded")

	tokenResp, err := client.Do(request)
	if err != nil {
		return nil, err
	}
	defer tokenResp.Body.Close()

	if tokenResp.StatusCode != http.StatusOK {
		res, _ := io.ReadAll(tokenResp.Body)
		return nil, fmt.Errorf("Status when requesting token: " + tokenResp.Status + "\n" + string(res))
	}

	var token SpotifyToken
	err = json.NewDecoder(tokenResp.Body).Decode(&token)
	if err != nil {
		return nil, err
	}

	return &token, nil
}

func DoSpotifyRequest(ctx context.Context, apiURL string, query string) ([]byte, error) {
	token, err := GetSpotifyToken()
	if err != nil {
		return nil, err
	}

	encodedQuery := url.QueryEscape(query)
	reqURL := fmt.Sprintf(apiURL, encodedQuery)
	request, err := http.NewRequest("GET", reqURL, nil)
	if err != nil {
		return nil, err
	}

	client := &http.Client{}
	tokenHeaderVal := fmt.Sprintf("Bearer %s", token.AccessToken)
	request.Header.Add("Authorization", tokenHeaderVal)
	r, err := client.Do(request)
	if err != nil {
		return nil, err
	}
	defer r.Body.Close()

	var buf bytes.Buffer
	_, err = io.Copy(&buf, r.Body)
	if err != nil {
		return nil, err
	}

	return buf.Bytes(), nil
}
