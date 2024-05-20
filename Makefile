SHELL=/bin/bash
GO_VERSION=go1.22.0.linux-amd64.tar.gz
RELEASE_DIR=release
INSTALL-DEPS:
	wget --verbose https://go.dev/dl/$(GO_VERSION)
	tar xf $(GO_VERSION)
	mv -v go ~/

build:
	echo "export PATH=$PATH:~/go/bin" >> ~/.bashrc
	mkdir $(RELEASE_DIR)
	GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o release/bootstrap main.go

package:
	GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o bootstrap main.go && \
	zip -r lambda.zip bootstrap
