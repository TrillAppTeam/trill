package main

import (
	"context"
	"errors"
	"fmt"
	"os"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/cognitoidentityprovider"
	"github.com/lestrrat-go/jwx/jwk"
	"github.com/lestrrat-go/jwx/jwt"
)

const SECRETS_PATH = "../../.secrets.yml"

type Response events.APIGatewayCustomAuthorizerResponse

type CognitoClient struct {
	Client      *cognitoidentityprovider.Client
	AppClientId string
	UserPoolId  string
}

type Secrets struct {
	host               string `yaml:"MYSQLHOST"`
	port               string `yaml:"MYSQLPORT"`
	database           string `yaml:"MYSQLDATABASE"`
	user               string `yaml:"MYSQLUSER"`
	password           string `yaml:"MYSQLPASS"`
	cognitoAppClientId string `yaml:"COGNITO_APP_CLIENT_ID"`
	cognitoUserPoolId  string `yaml:"COGNITO_USER_POOL_ID"`
}

var secrets = Secrets{
	os.Getenv("MYSQLHOST"),
	os.Getenv("MYSQLPORT"),
	os.Getenv("MYSQLDATABASE"),
	os.Getenv("MYSQLUSER"),
	os.Getenv("MYSQLPASS"),
	os.Getenv("COGNITO_APP_CLIENT_ID"),
	os.Getenv("COGNITO_USER_POOL_ID"),
}

var (
	ErrorAuthorizationHeader = errors.New("missing or invalid authorization header")
	ErrorUsernameNotFound    = errors.New("username not found in token")
)

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

func verifyToken(ctx context.Context, req events.APIGatewayCustomAuthorizerRequest) (Response, error) {
	cognitoClient, err := initClient(ctx)
	if err != nil {
		return Response{}, err
	}

	authHeader := req.AuthorizationToken
	/*splitAuthHeader := strings.Split(authHeader, " ")
	if len(splitAuthHeader) != 2 {
		return Response{}, ErrorAuthorizationHeader
	}*/

	pubKeyURL := "https://cognito-idp.%s.amazonaws.com/%s/.well-known/jwks.json"
	formattedURL := fmt.Sprintf(pubKeyURL, "us-east-1", cognitoClient.UserPoolId) // TODO: change region to var

	keySet, err := jwk.Fetch(ctx, formattedURL)
	if err != nil {
		return Response{}, err
	}

	token, err := jwt.Parse(
		// []byte(splitAuthHeader[1]),
		[]byte(authHeader),
		jwt.WithKeySet(keySet),
		jwt.WithValidate(true),
		jwt.WithClaimValue("token_use", "access"),
		jwt.WithRequiredClaim("username"),
	)
	if err != nil {
		return Response{}, err
	}

	fmt.Printf("Token value: %v+\n", token)

	username, found := token.Get("username")
	if !found {
		return Response{}, ErrorUsernameNotFound
	}

	return generatePolicy(username.(string), "Allow", req.MethodArn), nil
}

func generatePolicy(principalID, effect, resource string) Response {
	authResponse := Response{PrincipalID: principalID}

	if effect != "" && resource != "" {
		authResponse.PolicyDocument = events.APIGatewayCustomAuthorizerPolicy{
			Version: "2012-10-17",
			Statement: []events.IAMPolicyStatement{
				{
					Action:   []string{"execute-api:Invoke"},
					Effect:   effect,
					Resource: []string{resource},
				},
			},
		}
	}
	return authResponse
}

func main() {
	lambda.Start(verifyToken)
}
