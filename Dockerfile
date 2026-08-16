FROM golang:1.24-alpine AS builder

RUN apk add --no-cache build-base libpcap-dev
WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY cmd ./cmd/
COPY pkg ./pkg/

RUN go build -o ./out/app ./cmd/main.go


FROM alpine:3.20

RUN apk add --no-cache openssl libpcap ca-certificates

WORKDIR /app

COPY --from=builder /app/out/app ./app
COPY static ./static/
COPY config.example.json ./config.example.json
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 80 443 443/udp

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["./app"]
