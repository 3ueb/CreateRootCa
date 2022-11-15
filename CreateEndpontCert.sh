#!/bin/bash

set -xe

rm -rf endpoint/rsa/ endpoint/ecdsa/ endpoint/eddsa/
mkdir -p endpoint/rsa/ endpoint/ecdsa/ endpoint/eddsa/


openssl req  \
          -newkey rsa:2048 \
          -keyout endpoint/rsa/end.key \
          -out endpoint/rsa/end.req \
          -sha256 \
          -batch \
          -passout file:passwordEndpointCert.txt \
          -config openssl_EndpointCert.conf


# ecdsa
openssl ecparam -name prime256v1 -out endpoint/ecdsa/nistp256.pem

openssl req \
          -newkey ec:endpoint/ecdsa/nistp256.pem \
          -keyout endpoint/ecdsa/end.key \
          -out endpoint/ecdsa/end.req \
          -sha256 \
          -batch \
          -days 2000 \
          -passout file:passwordEndpointCert.txt \
          -config openssl_EndpointCert.conf

# eddsa

# TODO: add support for Ed448
# openssl genpkey -algorithm Ed448 -out eddsa/ca.key
openssl genpkey -algorithm Ed25519 -out endpoint/eddsa/end.key

openssl req \
          -new \
          -key endpoint/eddsa/end.key \
          -out endpoint/eddsa/end.req \
          -sha256 \
          -batch \
          -passout file:passwordEndpointCert.txt \
          -config openssl_EndpointCert.conf

for kt in rsa ecdsa eddsa ; do
  openssl x509 -req \
            -in endpoint/$kt/end.req \
            -out endpoint/$kt/end.cert \
            -CA intermediateCa/$kt/inter.cert \
            -CAkey intermediateCa/$kt/inter.key \
            -sha256 \
            -days 2000 \
            -set_serial 456 \
            -passin file:passwordIntermediateCa.txt \
            -extensions v3_end -extfile openssl_EndpointCert.conf

  cat intermediateCa/$kt/inter.cert rootCa/$kt/ca.cert > endpoint/$kt/end.chain
  cat endpoint/$kt/end.cert intermediateCa/$kt/inter.cert rootCa/$kt/ca.cert > endpoint/$kt/end.fullchain

done

