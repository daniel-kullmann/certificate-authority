#!/bin/sh
# How to generate your own certificate authority

CA_NAME="daniel-ca"

set -e -u

if ! test -f "${CA_NAME}".key; then
    # Generate key for certificate authority (CA)
    openssl genrsa -des3 -out "${CA_NAME}".key 2048
else
    echo "${CA_NAME}".key exists already.
fi

if ! test -f "${CA_NAME}".crt; then
    # Self-sign CA key, generating the certificate
    openssl req -x509 -new -nodes -key "${CA_NAME}".key -sha256 -days 3650 -out "${CA_NAME}".crt
else
    echo "${CA_NAME}".crt exists already.
fi

