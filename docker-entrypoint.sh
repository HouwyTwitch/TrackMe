#!/bin/sh
set -e

CERT_DIR=/app/certs
mkdir -p "$CERT_DIR"

if [ ! -f "$CERT_DIR/chain.pem" ] || [ ! -f "$CERT_DIR/key.pem" ]; then
    echo "Generating self-signed certificate in $CERT_DIR..."
    openssl req -x509 -newkey rsa:4096 \
        -keyout "$CERT_DIR/key.pem" \
        -out "$CERT_DIR/chain.pem" \
        -sha256 -days 365 -nodes \
        -subj "/CN=localhost" >/dev/null 2>&1
fi

if [ ! -f /app/config.json ]; then
    echo "config.json not found; copying default from config.example.json..."
    cp /app/config.example.json /app/config.json
fi

exec "$@"
