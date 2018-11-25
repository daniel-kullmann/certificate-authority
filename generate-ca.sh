#!/bin/sh
# How to generate your own certificate authority

set -e -u

if test -f ./certificate-authority.conf; then
    . ./certificate-authority.conf
    if test -n "$1" && test "$1" != "$CA_NAME"; then
        echo "Name of certificate authority was already defined (it is '$CA_NAME'). No need to call $0 with a parameter anymore."
        exit 1
    fi
else
    if test -n "$1"; then
        CA_NAME="$1"
    else
        echo -n "Please enter name of certificate authority (e.g. myca):"
        read CA_NAME
    fi
    echo "CA_NAME='$CA_NAME'" > ./certificate-authority.conf
fi

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

