package main

import (
	"fmt"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

// Response is of type APIGatewayProxyResponse since we're leveraging the
// AWS Lambda Proxy Request functionality (default behavior)
//
// https://serverless.com/framework/docs/providers/aws/events/apigateway/#lambda-proxy-integration
type Response events.APIGatewayProxyResponse

func Handler(req events.APIGatewayV2HTTPRequest) (Response, error) {
	// yummers
	fmt.Printf("%+v\n", req.RequestContext.Authorizer.Lambda["username"])
	return Response{StatusCode: 200}, nil
}

func main() {
	lambda.Start(Handler)
}
