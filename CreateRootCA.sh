#!/bin/bash

set -xe

rm -rf rootCa/rsa/ rootCa/ecdsa/ rootCa/eddsa/
mkdir -p rootCa/rsa/ rootCa/ecdsa/ rootCa/eddsa/

openssl req  \
          -x509 \
          -days 3650 \
          -newkey rsa:4096 \
          -keyout rootCa/rsa/ca.key \
          -out rootCa/rsa/ca.cert \
          -sha256 \
          -batch \
          -passout file:passwordRootCa.txt \
          -config rootCa.conf

# ecdsa
openssl ecparam -name secp384r1 -out rootCa/ecdsa/nistp384.pem

openssl req  \
          -x509 \
          -newkey ec:rootCa/ecdsa/nistp384.pem \
          -keyout rootCa/ecdsa/ca.key \
          -out rootCa/ecdsa/ca.cert \
          -sha256 \
          -batch \
          -days 3650 \
          -passout file:passwordRootCa.txt \
          -config rootCa.conf

# eddsa
openssl genpkey -algorithm Ed25519 -out rootCa/eddsa/ca.key

openssl req  \
          -x509 \
          -key rootCa/eddsa/ca.key \
          -out rootCa/eddsa/ca.cert \
          -sha256 \
          -batch \
          -days 3650 \
          -passout file:passwordRootCa.txt \
          -config rootCa.conf


