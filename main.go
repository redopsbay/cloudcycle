package main

import (
	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/redopsbay/cloudcycle/internal/job"
	"context"
)

func Handler(ctx context.Context, event events.CloudWatchEvent) {
	job.Terminator(ctx)
}

func main() {
	lambda.Start(Handler)
}
