package utils

import (
	"os"
)

type Secrets struct {
	Host               string `yaml:"MYSQLHOST"`
	Port               string `yaml:"MYSQLPORT"`
	Database           string `yaml:"MYSQLDATABASE"`
	User               string `yaml:"MYSQLUSER"`
	Password           string `yaml:"MYSQLPASS"`
	Region             string `yaml:"AWS_DEFAULT_REGION"`
	CognitoAppClientId string `yaml:"COGNITO_APP_CLIENT_ID"`
	CognitoUserPoolId  string `yaml:"COGNITO_USER_POOL_ID"`
}

func GetSecrets() Secrets {
	return Secrets{
		os.Getenv("MYSQLHOST"),
		os.Getenv("MYSQLPORT"),
		os.Getenv("MYSQLDATABASE"),
		os.Getenv("MYSQLUSER"),
		os.Getenv("MYSQLPASS"),
		os.Getenv("AWS_DEFAULT_REGION"),
		os.Getenv("COGNITO_APP_CLIENT_ID"),
		os.Getenv("COGNITO_USER_POOL_ID"),
	}
}
