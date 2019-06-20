FROM golang:1.11-alpine

RUN \
  apk add --update --no-cache --virtual .build-deps \
  git

ADD go.mod $GOPATH/src/tasks-backend/go.mod
ADD go.sum $GOPATH/src/tasks-backend/go.sum
ADD migrations $GOPATH/src/tasks-backend/migrations
ADD server $GOPATH/src/tasks-backend/server
ADD gqlgen.yml $GOPATH/src/tasks-backend/gqlgen.yml
ADD schema.graphql $GOPATH/src/tasks-backend/schema.graphql
ADD *.go $GOPATH/src/tasks-backend/

WORKDIR $GOPATH/src/tasks-backend/

RUN go get -d -v
RUN go build -ldflags "-s -w"
