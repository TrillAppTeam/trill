package models

import (
	"context"
	"fmt"
	"trill/src/utils"

	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/cognitoidentityprovider"
	"github.com/aws/aws-sdk-go-v2/service/s3"

	"gorm.io/driver/mysql"
	"gorm.io/gorm"
)

type CognitoClient struct {
	Client      *cognitoidentityprovider.Client
	AppClientId string
	UserPoolId  string
}

type HTTPError struct {
	Code int
	Err  error
}

func ConnectDB() (*gorm.DB, error) {
	var secrets = utils.GetSecrets()
	connectionString := fmt.Sprintf("%s:%s@tcp(%s:%s)/%s?allowNativePasswords=true&parseTime=true", secrets.User, secrets.Password, secrets.Host, secrets.Port, secrets.Database)
	if db, err := gorm.Open(mysql.Open(connectionString), &gorm.Config{}); err != nil {
		return nil, fmt.Errorf("error: failed to connect to AWS RDS: %w", err)
	} else {
		return db, nil
	}
}

func GetDBFromContext(ctx context.Context) (*gorm.DB, error) {
	if db, ok := ctx.Value("db").(*gorm.DB); !ok {
		return nil, fmt.Errorf("db could not be fetched from context")
	} else {
		return db, nil
	}
}

func InitCognitoClient(ctx context.Context) (*CognitoClient, error) {
	var secrets = utils.GetSecrets()
	cfg, err := config.LoadDefaultConfig(
		ctx, config.WithRegion("us-east-1"),
	)
	if err != nil {
		return nil, err
	}

	return &CognitoClient{
		cognitoidentityprovider.NewFromConfig(cfg),
		secrets.CognitoAppClientId,
		secrets.CognitoUserPoolId,
	}, nil
}

func InitS3Client(ctx context.Context) (*s3.Client, error) {
	cfg, err := config.LoadDefaultConfig(
		ctx, config.WithRegion("us-east-1"),
	)
	if err != nil {
		return nil, err
	}

	return s3.NewFromConfig(cfg), nil
}

func (e *HTTPError) Error() string {
	return e.Err.Error()
}
