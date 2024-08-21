FROM golang:1.23-alpine3.20 AS build

ARG consul_version=1.17.3
ADD https://releases.hashicorp.com/consul/${consul_version}/consul_${consul_version}_linux_amd64.zip /usr/local/bin
RUN cd /usr/local/bin && unzip consul_${consul_version}_linux_amd64.zip

ARG vault_version=1.15.5
ADD https://releases.hashicorp.com/vault/${vault_version}/vault_${vault_version}_linux_amd64.zip /usr/local/bin
RUN cd /usr/local/bin && unzip vault_${vault_version}_linux_amd64.zip

RUN apk update && apk upgrade && apk add --no-cache git libcap
WORKDIR /src
COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go mod tidy 
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go mod vendor
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go test -mod=vendor -trimpath -ldflags "-s -w" 
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -mod=vendor -trimpath -ldflags "-s -w"
RUN setcap CAP_NET_BIND_SERVICE=+eip /src/fabio

FROM alpine:3.20
RUN apk update && apk upgrade && apk add --no-cache ca-certificates
COPY --from=build /src/fabio /usr/bin
ADD fabio.properties /etc/fabio/fabio.properties
EXPOSE 9998 9999
ENTRYPOINT ["/usr/bin/fabio"]
CMD ["-cfg", "/etc/fabio/fabio.properties"]
