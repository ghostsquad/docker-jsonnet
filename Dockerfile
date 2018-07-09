# stage: jsonnet
FROM golang:1.10.3-alpine3.7 as jsonnet

# git is not includinged in the alpine image, they will not fix this
# https://github.com/docker-library/golang/issues/80
RUN apk add --no-cache git

# For whatever reason, when running `go get` for go-jsonnet, I get this error
# cannot find package "github.com/fatih/color" in any of...
# explicitly getting that package seems to resolve the issue
RUN set -ex; \
    go get github.com/fatih/color; \
    go get github.com/google/go-jsonnet; \
    cd $GOPATH/src/github.com/google/go-jsonnet/jsonnet; \
    go build;

FROM alpine:3.7

COPY --from=jsonnet /go/src/github.com/google/go-jsonnet/jsonnet/jsonnet /usr/local/bin/jsonnet

RUN jsonnet --version
