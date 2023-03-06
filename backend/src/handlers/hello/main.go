package main

import (
	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

// Response is of type APIGatewayProxyResponse since we're leveraging the
// AWS Lambda Proxy Request functionality (default behavior)
//
// https://serverless.com/framework/docs/providers/aws/events/apigateway/#lambda-proxy-integration
type Response events.APIGatewayV2HTTPResponse

func Handler(req events.APIGatewayV2HTTPRequest) (Response, error) {
	// yummers
	return Response{StatusCode: 200, Body: "Hello"}, nil
}

func main() {
	lambda.Start(Handler)
}
