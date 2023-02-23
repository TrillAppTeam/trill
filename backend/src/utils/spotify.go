package utils

import (
	"bytes"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"net/url"
)

type SpotifyToken struct {
	AccessToken string `json:"access_token"`
	TokenType   string `json:"token_type"`
	ExpiresIn   int    `json:"expires_in"`
}

func GetSpotifyToken() (*SpotifyToken, error) {
	var secrets = GetSecrets()

	client := &http.Client{}
	body := url.Values{}
	body.Set("grant_type", "client_credentials")
	authHeader := base64.StdEncoding.EncodeToString([]byte(secrets.SpotifyID + ":" + secrets.SpotifySecret))

	reqBody := bytes.NewBufferString(body.Encode())
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

	var token SpotifyToken
	err = json.NewDecoder(tokenResp.Body).Decode(&token)
	if err != nil {
		return nil, err
	}

	return &token, nil
}

func DoSpotifyRequest(token *SpotifyToken, reqURL string) (*bytes.Buffer, error) {
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

	return &buf, nil
}
