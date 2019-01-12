FROM golang:1.11-alpine

RUN \
  apk add --update --no-cache --virtual .build-deps \
  git

ADD key.pem $GOPATH/src/auth/key.pem
ADD key.pem.pub $GOPATH/src/auth/key.pem.pub
ADD *.go $GOPATH/src/auth/

WORKDIR $GOPATH/src/auth/

RUN go get -d -v
RUN go build -ldflags "-s -w"
