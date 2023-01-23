package main

import (
	"context"
	"errors"
	"fmt"
	"net/http"
	"os"
	"strings"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/cognitoidentityprovider"

	"github.com/lestrrat-go/jwx/jwk"
	"github.com/lestrrat-go/jwx/jwt"
)

const SECRETS_PATH = "../../.secrets.yml"

type Response events.APIGatewayProxyResponse

type Secrets struct {
	host               string `yaml:"MYSQLHOST"`
	port               string `yaml:"MYSQLPORT"`
	database           string `yaml:"MYSQLDATABASE"`
	user               string `yaml:"MYSQLUSER"`
	password           string `yaml:"MYSQLPASS"`
	region             string `yaml:"AWS_DEFAULT_REGION"`
	cognitoAppClientId string `yaml:"COGNITO_APP_CLIENT_ID"`
	cognitoUserPoolId  string `yaml:"COGNITO_USER_POOL_ID"`
}

var secrets = Secrets{
	os.Getenv("MYSQLHOST"),
	os.Getenv("MYSQLPORT"),
	os.Getenv("MYSQLDATABASE"),
	os.Getenv("MYSQLUSER"),
	os.Getenv("MYSQLPASS"),
	os.Getenv("AWS_DEFAULT_REGION"),
	os.Getenv("COGNITO_APP_CLIENT_ID"),
	os.Getenv("COGNITO_USER_POOL_ID"),
}

type CognitoClient struct {
	Client      *cognitoidentityprovider.Client
	AppClientId string
	UserPoolId  string
}

var ErrorCognitoClient = errors.New("could not retrieve CognitoClient from context")

var ErrorAuthorizationHeader = errors.New("missing or invalid authorization header")

func initClient(ctx context.Context) (*CognitoClient, error) {
	cfg, err := config.LoadDefaultConfig(
		ctx, config.WithRegion("{aws-region}"),
	)
	if err != nil {
		return nil, err
	}

	return &CognitoClient{
		cognitoidentityprovider.NewFromConfig(cfg),
		secrets.cognitoAppClientId,
		secrets.cognitoUserPoolId,
	}, nil
}

func verifyToken(ctx context.Context, req events.APIGatewayProxyRequest) (Response, error) {
	cognitoClient, err := initClient(ctx)
	if err != nil {
		return Response{StatusCode: http.StatusInternalServerError, Body: err.Error()}, err
	}

	authHeader := req.Headers["Authorization"]
	splitAuthHeader := strings.Split(authHeader, " ")
	if len(splitAuthHeader) != 2 {
		return Response{StatusCode: http.StatusBadRequest, Body: ErrorCognitoClient.Error()}, ErrorCognitoClient
	}

	pubKeyURL := "https://cognito-idp.%s.amazonaws.com/%s/.well-known/jwks.json"

	formattedUrl := fmt.Sprintf(pubKeyURL, secrets.region, cognitoClient.UserPoolId)
	keySet, err := jwk.Fetch(ctx, formattedUrl)
	if err != nil {
		return Response{StatusCode: http.StatusInternalServerError, Body: err.Error()}, err
	}

	token, err := jwt.Parse(
		[]byte(splitAuthHeader[1]),
		jwt.WithKeySet(keySet),
		jwt.WithValidate(true),
	)
	if err != nil {
		return Response{StatusCode: http.StatusInternalServerError, Body: err.Error()}, err
	}

	return Response{StatusCode: 200, Body: fmt.Sprintf("%s", token)}, nil
}

func main() {
	lambda.Start(verifyToken)
}
