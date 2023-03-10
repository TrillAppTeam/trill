package handlers

import (
	"context"
	"errors"
	"fmt"
	"strconv"
	"trill/src/models"
)

var (
	ErrorLimit error = errors.New("failed to parse limit")
	ErrorPage  error = errors.New("failed to parse page")
	// ErrorSort  error = errors.New("failed to parse sort")
)

type PaginateError struct {
	Err error
}

func (e PaginateError) Error() string {
	return fmt.Sprintf("pagination error: %s", e.Err.Error())
}

func GetPaginateFromRequest(ctx context.Context, req Request) (*models.Paginate, error) {
	limit := models.PAGINATE_DEFAULT_LIMIT
	page := models.PAGINATE_DEFAULT_PAGE
	sort := models.PAGINATE_DEFAULT_SORT

	var err error
	for param, value := range req.QueryStringParameters {
		switch param {
		case "limit":
			limit, err = strconv.Atoi(value)
			if err != nil {
				return nil, PaginateError{Err: ErrorLimit}
			}
		case "page":
			page, err = strconv.Atoi(value)
			if err != nil {
				return nil, PaginateError{Err: ErrorPage}
			}
		case "sort":
			sort = value
		}
	}

	return &models.Paginate{
		Limit: limit,
		Page:  page,
		Sort:  sort,
	}, nil
}
