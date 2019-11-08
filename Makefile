.PHONY: build build-alpine clean test help default

BIN_NAME=gomar

VERSION := $(shell grep "const Version " version/version.go | sed -E 's/.*"(.+)"$$/\1/')
GIT_COMMIT=$(shell git rev-parse HEAD)
GIT_DIRTY=$(shell test -n "`git status --porcelain`" && echo "+CHANGES" || true)
BUILD_DATE=$(shell date '+%Y-%m-%d-%H:%M:%S')
IMAGE_NAME := "derphilipp/gomar"

default: test

help:
	@echo 'Management commands for gomar:'
	@echo
	@echo 'Usage:'
	@echo '    make build           Compile the project.'
	# @echo '    make get-deps        runs dep ensure, mostly used for ci.'

	@echo '    make clean           Clean the directory tree.'
	@echo


get-deps:
	echo "Skipped due to use of go.mod"
	# dep ensure

clean:
	@test ! -e bin/${BIN_NAME} || rm bin/${BIN_NAME}

test:
	go test -v -covermode=count -coverprofile=coverage.out ./...

build:
	@echo "building ${BIN_NAME} ${VERSION}"
	@echo "GOPATH=${GOPATH}"
	CGO_ENABLED=0 go build -ldflags "-X github.com/derphilipp/gomar/version.GitCommit=${GIT_COMMIT}${GIT_DIRTY} -X github.com/derphilipp/gomar/version.BuildDate=${BUILD_DATE}" -o bin/${BIN_NAME}

install_tools:
	go get github.com/mitchellh/gox
	go get github.com/tcnksm/ghr
	go get github.com/axw/gocov/gocov
	go get github.com/mattn/goveralls
	go get golang.org/x/tools/cmd/cover

coveralls:
	goveralls -coverprofile=coverage.out -service travis-ci -repotoken ${COVERALLS_TOKEN}
