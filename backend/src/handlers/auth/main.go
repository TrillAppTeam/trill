package main

import (
	"context"
	"errors"
	"fmt"
	"strings"
	"trill/src/utils"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/cognitoidentityprovider"
	"github.com/lestrrat-go/jwx/jwk"
	"github.com/lestrrat-go/jwx/jwt"
)

type Request = events.APIGatewayV2CustomAuthorizerV2Request
type Response = events.APIGatewayV2CustomAuthorizerIAMPolicyResponse

type CognitoClient struct {
	Client      *cognitoidentityprovider.Client
	AppClientId string
	UserPoolId  string
}

var (
	ErrorAuthorizationHeader = errors.New("missing or invalid authorization header")
	ErrorUsernameNotFound    = errors.New("username not found in token")
	ErrorCantCastUsername    = errors.New("cannot cast username")
)

func initClient(ctx context.Context) (*CognitoClient, error) {
	cfg, err := config.LoadDefaultConfig(
		ctx, config.WithRegion("us-east-1"),
	)
	if err != nil {
		return nil, err
	}

	secrets := utils.GetSecrets()
	return &CognitoClient{
		cognitoidentityprovider.NewFromConfig(cfg),
		secrets.CognitoAppClientId,
		secrets.CognitoUserPoolId,
	}, nil
}

func verifyToken(ctx context.Context, req Request) (Response, error) {
	cognitoClient, err := initClient(ctx)
	if err != nil {
		return generatePolicy("", nil, "Deny", req.RouteArn, ErrorAuthorizationHeader), nil
	}

	authHeader := req.Headers["authorization"]
	// fmt.Printf("authHeader: %s\n", authHeader)
	splitAuthHeader := strings.Split(authHeader, " ")
	if len(splitAuthHeader) != 2 {
		return generatePolicy("", nil, "Deny", req.RouteArn, ErrorAuthorizationHeader), nil
	}

	pubKeyURL := "https://cognito-idp.%s.amazonaws.com/%s/.well-known/jwks.json"
	formattedURL := fmt.Sprintf(pubKeyURL, "us-east-1", cognitoClient.UserPoolId) // TODO: change region to var
	keySet, err := jwk.Fetch(ctx, formattedURL)
	if err != nil {
		return generatePolicy("", nil, "Deny", req.RouteArn, err), nil
	}

	// fmt.Println(splitAuthHeader[1])
	token, err := jwt.Parse(
		[]byte(splitAuthHeader[1]),
		jwt.WithKeySet(keySet),
		jwt.WithValidate(true),
		jwt.WithClaimValue("token_use", "access"),
		jwt.WithRequiredClaim("username"),
	)
	if err != nil {
		return generatePolicy("", nil, "Deny", req.RouteArn, err), nil
	}

	// fmt.Printf("Token value: %+v\n", token)

	rawUsername, found := token.Get("username")
	if !found {
		return generatePolicy("", nil, "Deny", req.RouteArn, ErrorUsernameNotFound), nil
	}
	username, ok := rawUsername.(string)
	if !ok {
		return generatePolicy("", nil, "Deny", req.RouteArn, ErrorCantCastUsername), nil
	}

	responseContext := map[string]interface{}{
		"username": username,
		"userID":   token.Subject(),
	}
	return generatePolicy(username, responseContext, "Allow", req.RouteArn, nil), nil
}

func generatePolicy(principalID string, responseContext map[string]interface{}, effect string, resource string, err error) Response {
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

	authResponse.Context = make(map[string]interface{})
	if err != nil {
		authResponse.Context["message"] = err.Error()
	} else {
		authResponse.Context = responseContext
	}

	// fmt.Printf("%+v\n", authResponse)
	return authResponse
}

func main() {
	lambda.Start(verifyToken)
}
