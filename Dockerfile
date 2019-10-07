FROM golang:1.11-alpine3.8 as build

RUN apk add -U --no-cache ca-certificates git bash openssl

COPY ./ /go/src/github.com/awslabs/aws-sigv4-proxy
WORKDIR /go/src/github.com/awslabs/aws-sigv4-proxy

RUN go build -o app github.com/awslabs/aws-sigv4-proxy && \
    mv ./app /go/bin && \
    openssl genrsa -des3 -passout pass:x -out server.pass.key 2048 && \
    openssl rsa -passin pass:x -in server.pass.key -out server.key && \
    rm server.pass.key && \
    openssl req -new -key server.key -out server.csr \
        -subj "/C=UK/ST=Warwickshire/L=Leamington/O=OrgName/OU=IT Department/CN=example.com" && \
    openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt && \
    mv ./server.* /go/bin


FROM alpine:3.8

WORKDIR /opt/
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=build /go/bin/app /opt/
COPY --from=build /go/bin/server.* /opt/

ENTRYPOINT [ "/opt/app" ]
