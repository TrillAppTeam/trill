package main

import (
	"bytes"
	"context"
	"fmt"
	"io"
	"io/ioutil"
	"mime/multipart"
	"strings"
	"trill/src/handlers"
	"trill/src/models"
	"trill/src/views"

	"github.com/aws/aws-lambda-go/lambda"
	"gorm.io/gorm"
)

type Request = handlers.Request
type Response = handlers.Response

var db *gorm.DB

func handler(ctx context.Context, req Request) (Response, error) {
	var initCtx context.Context
	var err error
	initCtx, db, err = handlers.InitContext(ctx, db)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}

	switch req.RequestContext.HTTP.Method {
	case "GET":
		if _, ok := req.QueryStringParameters["search"]; ok {
			return search(initCtx, req)
		} else {
			return get(initCtx, req)
		}
	case "PUT":
		return update(initCtx, req)
	default:
		err := fmt.Errorf("HTTP method '%s' not allowed", req.RequestContext.HTTP.Method)
		return Response{StatusCode: 405, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}
}

func search(ctx context.Context, req Request) (Response, error) {
	search := req.QueryStringParameters["search"]
	users, err := models.SearchUser(ctx, search)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}

	body, err := views.MarshalUsers(ctx, users)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}

	return Response{StatusCode: 200, Body: body, Headers: views.DefaultHeaders}, nil
}

func get(ctx context.Context, req Request) (Response, error) {
	requestor, ok := req.RequestContext.Authorizer.Lambda["username"].(string)
	if !ok {
		return Response{StatusCode: 500, Body: "failed to parse username", Headers: views.DefaultHeaders}, nil
	}

	var body, userToGet string
	username, ok := req.QueryStringParameters["username"]
	privateCognitoUser := &models.PrivateCognitoUser{}
	if !ok { // get public + private info
		var err error
		userToGet = requestor
		authToken := strings.Split((req.Headers["authorization"]), " ")[1]
		privateCognitoUser, err = models.GetPrivateCognitoUser(ctx, authToken)
		if err != nil {
			return Response{StatusCode: 500, Body: err.Error()}, nil
		}
	} else { // get public info
		userToGet = username
	}

	user, err := models.GetUser(ctx, userToGet)
	if err != nil {
		if httpErr, ok := err.(*models.HTTPError); ok {
			return Response{StatusCode: httpErr.Code, Body: httpErr.Error()}, nil
		}
		return Response{StatusCode: 500, Body: err.Error()}, nil
	}

	following, err := models.GetFollowing(ctx, userToGet)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}

	followers, err := models.GetFollowers(ctx, userToGet)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}

	requestorFollows, err := models.IsFollowing(ctx, requestor, userToGet)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}

	followsRequestor, err := models.IsFollowing(ctx, userToGet, requestor)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}

	body, err = views.MarshalFullUser(ctx, user, privateCognitoUser, following, followers, requestorFollows, followsRequestor)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error()}, nil
	}

	return Response{
		StatusCode: 200,
		Body:       body,
		Headers:    views.DefaultHeaders,
	}, nil
}

func update(ctx context.Context, req Request) (Response, error) {
	username, ok := req.RequestContext.Authorizer.Lambda["username"].(string)
	if !ok {
		return Response{StatusCode: 500, Body: "failed to parse username", Headers: views.DefaultHeaders}, nil
	}

	user, err := models.GetUser(ctx, username)
	if err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}

	parts := strings.Split(req.Headers["content-type"], "boundary=")
	if len(parts) < 2 {
		// temp response body
		var headers string
		for k, v := range req.Headers {
			headers += fmt.Sprintf("%s: %s\n", k, v)
		}
		return Response{StatusCode: 400, Body: fmt.Sprintf("Missing boundary from content-type header\n\n%s", headers), Headers: views.DefaultHeaders}, nil
	}
	boundary := parts[1]
	mr := multipart.NewReader(bytes.NewReader([]byte(req.Body)), boundary)

	for {
		part, err := mr.NextPart()
		if err != nil {
			if err == io.EOF {
				break
			}
			// temp response body
			return Response{StatusCode: 400, Body: fmt.Sprintf("error reading multipart body: %s\n\nboundary: %s\n\nbody:\n%s", err.Error(), boundary, req.Body), Headers: views.DefaultHeaders}, nil
		}
		switch part.FormName() {
		case "nickname":
			nicknameBytes, err := ioutil.ReadAll(part)
			if err != nil {
				return Response{StatusCode: 400, Body: fmt.Sprintf("error reading nickname field: %s", err.Error()), Headers: views.DefaultHeaders}, nil
			}
			user.Nickname = string(nicknameBytes)
		case "bio":
			bioBytes, err := ioutil.ReadAll(part)
			if err != nil {
				return Response{StatusCode: 400, Body: fmt.Sprintf("error reading bio field: %s", err.Error()), Headers: views.DefaultHeaders}, nil
			}
			user.Bio = string(bioBytes)
		case "profilePicture":
			profilePictureBytes, err := ioutil.ReadAll(part)
			if err != nil {
				return Response{StatusCode: 400, Body: fmt.Sprintf("error reading profilePicture field: %s", err.Error()), Headers: views.DefaultHeaders}, nil
			}
			user.ProfilePicture = string(profilePictureBytes)
			// sess := session.Must(session.NewSession())
			// s3Client := s3.New(sess, aws.NewConfig().WithRegion("us-west-2"))
			// key := fmt.Sprintf("profilePictures/%s.png", username)
			// _, err = s3Client.PutObject(&s3.PutObjectInput{
			// 	Bucket: aws.String("your-s3-bucket-name"),
			// 	Key:    aws.String(key),
			// 	Body:   bytes.NewReader(profilePicture),
			// })
			// if err != nil {
			// 	return Response{StatusCode: 500, Body: fmt.Sprintf("error uploading profilePicture to S3: %s", err.Error()), Headers: views.DefaultHeaders}, nil
			// }
			// profilePictureURL = fmt.Sprintf("https://your-s3-bucket-name.s3-us-west-2.amazonaws.com/%s", key)
			// user.ProfilePicture = string(profilePictureURL)
		}
	}

	if err = models.UpdateUser(ctx, user); err != nil {
		return Response{StatusCode: 500, Body: err.Error(), Headers: views.DefaultHeaders}, nil
	}

	return Response{StatusCode: 200, Body: "user updated successfully", Headers: views.DefaultHeaders}, nil
}

func main() {
	lambda.Start(handler)
}
