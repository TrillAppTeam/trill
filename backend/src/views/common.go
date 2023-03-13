package views

import (
	"bytes"
	"context"
	"encoding/json"
)

var DefaultHeaders = map[string]string{
	"Content-Type":                     "application/json",
	"Access-Control-Allow-Origin":      "*",
	"Access-Control-Allow-Credentials": "true",
}

func Marshal(ctx context.Context, view interface{}) (string, error) {
	var buf bytes.Buffer
	response, err := json.Marshal(view)
	if err != nil {
		return "", err
	}
	json.HTMLEscape(&buf, response)
	return buf.String(), nil
}

func Unmarshal(ctx context.Context, marshalled string, model interface{}) error {
	return json.Unmarshal([]byte(marshalled), &model)
}
