package internal

import (
	"context"
	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/ec2"
	"os"
)

// GenerateCustomResolverConfig used for `localstack` integration for lambda localhost development
func GenerateCustomResolverConfig(ctx context.Context) (aws.Config, error) {
	if len(os.Getenv("STS_LOCAL")) > 0 && len(os.Getenv("STS_LOCAL_HOST")) > 0 {
		customResolver := aws.EndpointResolverWithOptionsFunc(
			func(service, region string, opts ...interface{}) (aws.Endpoint, error) {
				return aws.Endpoint{
					PartitionID:   "aws",
					URL:           os.Getenv("STS_LOCAL_HOST"),
					SigningRegion: os.Getenv("REGION"),
				}, nil
			})

		cfg, err := config.LoadDefaultConfig(ctx,
			config.WithRegion(os.Getenv("REGION")),
			config.WithEndpointResolverWithOptions(customResolver))

		if err != nil {
			panic(err)
			return aws.Config{}, err
		}
		return cfg, nil
	} else {
		cfg, err := config.LoadDefaultConfig(context.TODO())
		if err != nil {
			panic(err)
			return aws.Config{}, err
		}
		return cfg, nil
	}
}


// EC2Client create and return *ec2.Client
func EC2Client(ctx context.Context) *ec2.Client {
	cfg, err := GenerateCustomResolverConfig(ctx)

	if err != nil {
		return nil

	}
	client := ec2.NewFromConfig(cfg)
	return client
}
