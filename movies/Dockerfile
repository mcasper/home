FROM golang:1.11-alpine

RUN \
  apk add --update --no-cache --virtual .build-deps \
  git

ADD app $GOPATH/src/movies/
ADD bin $GOPATH/src/movies/
ADD conf $GOPATH/src/movies/
ADD messages $GOPATH/src/movies/
ADD migrations $GOPATH/src/movies/
ADD public $GOPATH/src/movies/

WORKDIR $GOPATH/src/movies/

RUN go get -d -v
RUN go build -ldflags "-s -w"
