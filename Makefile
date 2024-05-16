SHELL=/bin/bash

build:
	GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o bootstrap main.go

package:
	GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o bootstrap main.go && \
	zip -r lambda.zip bootstrap
