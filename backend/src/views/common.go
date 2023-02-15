package views

import (
	"bytes"
	"context"
	"encoding/json"
)

func Marshal(ctx context.Context, view interface{}) (string, error) {
	var buf bytes.Buffer
	response, err := json.Marshal(view)
	if err != nil {
		return "", err
	}
	json.HTMLEscape(&buf, response)
	return buf.String(), nil
}
