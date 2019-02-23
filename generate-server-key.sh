#!/bin/sh
# How to generate a server certificate signed by your own CA

set -e -u

if test -z "${1:-}"; then
    echo "Usage: $0 SERVER-NAME"
    exit 1
fi

SERVER_NAME="$1"

if ! test -f ./certificate-authority.conf; then
    # Create CA files if they are missing; set CA_NAME environment variable
    ./generate-ca.sh
fi
. ./certificate-authority.conf

if ! test -f "${SERVER_NAME}".key; then
    # Generate key for server
    openssl genrsa -out "${SERVER_NAME}".key 2048
else
    echo "${SERVER_NAME}".key exists already.
fi


if ! test -f "${SERVER_NAME}".csr; then
    # Generate certificate signing request (CSR) for that key
    # Make sure to use the server's name as FQDN
    openssl req -new -days 365 -key "${SERVER_NAME}".key -out "${SERVER_NAME}".csr
else
    echo "${SERVER_NAME}".csr exists already.
fi


if ! test -f "${SERVER_NAME}".crt; then
    # Sign the server key with the certificate authority
    openssl x509 -req -in "${SERVER_NAME}".csr -CA "${CA_NAME}".crt -CAkey "${CA_NAME}".key -CAcreateserial -out "${SERVER_NAME}".crt
else
    echo "${SERVER_NAME}".crt exists already.
fi

