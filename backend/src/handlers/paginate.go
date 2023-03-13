package handlers

import (
	"context"
	"errors"
	"fmt"
	"strconv"
	"trill/src/models"
)

var (
	ErrorLimitParse   error = errors.New("failed to parse limit")
	ErrorLimitTooHigh error = fmt.Errorf("maximum limit of %d exceeded", maxLimit)
	ErrorPage         error = errors.New("failed to parse page")
	// ErrorSort  error = errors.New("failed to parse sort")
)

var (
	maxLimit int = 20
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
				return nil, PaginateError{Err: ErrorLimitParse}
			}
			if limit > maxLimit {
				return nil, PaginateError{Err: ErrorLimitTooHigh}
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
