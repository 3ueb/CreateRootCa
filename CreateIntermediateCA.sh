#!/bin/bash

set -xe

rm -rf intermediateCa/rsa/ intermediateCa/ecdsa/ intermediateCa/eddsa/
mkdir -p intermediateCa/rsa/ intermediateCa/ecdsa/ intermediateCa/eddsa/

openssl req -nodes \
          -newkey rsa:3072 \
          -keyout intermediateCa/rsa/inter.key \
          -out intermediateCa/rsa/inter.req \
          -sha256 \
          -batch \
          -passout file:passwordIntermediateCa.txt \
          -config openssl_intermediate.conf

# ecdsa
openssl ecparam -name prime256v1 -out intermediateCa/ecdsa/nistp256.pem

openssl req -nodes \
          -newkey ec:intermediateCa/ecdsa/nistp256.pem \
          -keyout intermediateCa/ecdsa/inter.key \
          -out intermediateCa/ecdsa/inter.req \
          -sha256 \
          -batch \
          -days 3000 \
          -passout file:passwordIntermediateCa.txt \
          -config openssl_intermediate.conf

# eddsa
openssl genpkey -algorithm Ed25519 -out intermediateCa/eddsa/inter.key


openssl req -nodes \
          -new \
          -key intermediateCa/eddsa/inter.key \
          -out intermediateCa/eddsa/inter.req \
          -sha256 \
          -batch \
          -passout file:passwordIntermediateCa.txt \
          -config openssl_intermediate.conf


for kt in rsa ecdsa eddsa ; do
  openssl x509 -req \
            -in intermediateCa/$kt/inter.req \
            -out intermediateCa/$kt/inter.cert \
            -CA rootCa/$kt/ca.cert \
            -CAkey rootCa/$kt/ca.key \
            -sha256 \
            -days 3650 \
            -set_serial 123 \
            -passin file:passwordRootCa.txt \
            -extensions v3_inter -extfile openssl_intermediate.conf
done

