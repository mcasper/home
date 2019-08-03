FROM golang:1.11-alpine

RUN \
  apk add --update --no-cache --virtual .build-deps \
  gcc \
  git \
  libc-dev

ENV PROJECT_ROOT $GOPATH/src/github.com/mcasper/home/tasks-backend

ADD go.mod $PROJECT_ROOT/go.mod
ADD go.sum $PROJECT_ROOT/go.sum
ADD migrations $PROJECT_ROOT/migrations
ADD server $PROJECT_ROOT/server
ADD gqlgen.yml $PROJECT_ROOT/gqlgen.yml
ADD schema.graphql $PROJECT_ROOT/schema.graphql
ADD *.go $PROJECT_ROOT/

WORKDIR $PROJECT_ROOT

ENV GO111MODULE on

RUN go get -d -v
RUN go build -ldflags "-s -w"
