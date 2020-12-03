FROM golang:1.15-alpine

RUN \
  apk add --update --no-cache --virtual .build-deps \
  git

RUN go get github.com/revel/revel
RUN go get github.com/revel/cmd/revel

ADD app $GOPATH/src/github.com/mcasper/home/movies/app
ADD bin $GOPATH/src/github.com/mcasper/home/movies/bin
ADD conf $GOPATH/src/github.com/mcasper/home/movies/conf
ADD messages $GOPATH/src/github.com/mcasper/home/movies/messages
ADD migrations $GOPATH/src/github.com/mcasper/home/movies/migrations
ADD public $GOPATH/src/github.com/mcasper/home/movies/public

WORKDIR $GOPATH/src/github.com/mcasper/home/movies/
