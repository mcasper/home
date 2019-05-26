FROM golang:1.11-alpine

RUN \
  apk add --update --no-cache --virtual .build-deps \
  git

ADD app $GOPATH/src/movies/app
ADD bin $GOPATH/src/movies/bin
ADD conf $GOPATH/src/movies/conf
ADD messages $GOPATH/src/movies/messages
ADD migrations $GOPATH/src/movies/migrations
ADD public $GOPATH/src/movies/public

WORKDIR $GOPATH/src/movies/

RUN go get github.com/revel/cmd/revel
RUN go get -d -v
RUN go build -ldflags "-s -w"
