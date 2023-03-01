package main

import (
	"context"
	"fmt"
	"strconv"
	"trill/src/models"
	"trill/src/views"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"gorm.io/gorm"
)

type Request = events.APIGatewayV2HTTPRequest
type Response = events.APIGatewayV2HTTPResponse

var db *gorm.DB

func handler(ctx context.Context, req events.APIGatewayV2HTTPRequest) (Response, error) {
	if db == nil {
		var err error
		db, err = models.ConnectDB()
		if err != nil {
			return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
		}
	}
	ctx = context.WithValue(ctx, "db", db)

	switch req.RequestContext.HTTP.Method {
	case "GET":
		return getLikeCount(ctx, req)
	case "PUT":
		return like(ctx, req)
	case "DELETE":
		return unlike(ctx, req)
	default:
		err := fmt.Errorf("HTTP Method '%s' not allowed", req.RequestContext.HTTP.Method)
		return Response{StatusCode: 405, Body: err.Error()}, err
	}
}

// Given a reviewID, get the number of likes for that review
// @PARAMS are QueryStringParameters: "review_id"
// Postman: GET - /likes?review_id={reviewID}
// TODO: If review does not exist, throw error
func getLikeCount(ctx context.Context, req Request) (Response, error) {
	// Get the review ID
	reviewID, ok := req.QueryStringParameters["reviewID"]
	if !ok {
		return Response{StatusCode: 500, Body: "Failed to parse review ID", Headers: views.DefaultHeaders}, nil
	}

	// Given the review ID, find the users who liked it
	likes, err := models.GetLikes(ctx, reviewID)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}

	// Serialize users into JSON; Return usersJSON if we want the list of users
	// usersJSON, err := json.Marshal(likeUsers)
	// if err != nil {
	// 	return Response{StatusCode: 500, Body: err.Error()}, err
	// }

	return Response{StatusCode: 200, Body: fmt.Sprint(len(*likes)), Headers: views.DefaultHeaders}, nil
}

// User likes a review
// Postman: PUT - /likes
func like(ctx context.Context, req Request) (Response, error) {
	username, ok := req.RequestContext.Authorizer.Lambda["username"].(string)
	if !ok {
		return Response{StatusCode: 500, Body: "Failed to get current user", Headers: views.DefaultHeaders}, nil
	}

	stringReviewID, ok := req.QueryStringParameters["reviewID"]
	reviewID, err := strconv.Atoi(stringReviewID)
	if !ok || err != nil {
		return Response{StatusCode: 500, Body: "Failed to parse album ID", Headers: views.DefaultHeaders}, nil
	}

	like := models.Like{
		Username: username,
		ReviewID: reviewID,
	}

	// Add new like to the database
	err = models.CreateLike(ctx, &like)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}

	return Response{
		StatusCode: 201,
		Body: fmt.Sprintf("Successfully added new like to review %d from %s to database.",
			like.ReviewID, like.Username),
		Headers: views.DefaultHeaders,
	}, nil
}

// User unlikes a review
// Postman: DELETE - /likes
func unlike(ctx context.Context, req events.APIGatewayV2HTTPRequest) (Response, error) {
	username, ok := req.RequestContext.Authorizer.Lambda["username"].(string)
	if !ok {
		return Response{StatusCode: 500, Body: "Failed to get current user", Headers: views.DefaultHeaders}, nil
	}

	// Get the username from the request params
	stringReviewID, ok := req.QueryStringParameters["reviewID"]
	reviewID, err := strconv.Atoi(stringReviewID)
	if !ok || err != nil {
		return Response{StatusCode: 500, Body: "Failed to parse album ID", Headers: views.DefaultHeaders}, nil
	}

	like := models.Like{
		Username: username,
		ReviewID: reviewID,
	}

	// Delete the requested Like from the database
	err = models.DeleteLike(ctx, &like)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}

	return Response{
		StatusCode: 200,
		Body: fmt.Sprintf("Successfully removed like to review %d from %s to database.",
			like.ReviewID, like.Username),
		Headers: views.DefaultHeaders,
	}, nil
}

func main() {
	lambda.Start(handler)
}
