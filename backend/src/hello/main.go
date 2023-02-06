package main

import (
	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

// Response is of type APIGatewayProxyResponse since we're leveraging the
// AWS Lambda Proxy Request functionality (default behavior)
//
// https://serverless.com/framework/docs/providers/aws/events/apigateway/#lambda-proxy-integration
type Response events.APIGatewayProxyResponse

// Handler is our lambda handler invoked by the `l/bin/sh: 1: make: not foundambda.Start` function call
func Handler(req events.APIGatewayProxyRequest) (Response, error) {
	// yummers
	return Response{StatusCode: 200}, nil
}

func main() {
	lambda.Start(Handler)
}
