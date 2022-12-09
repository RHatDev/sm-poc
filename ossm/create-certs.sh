#!/bin/bash

echo "Creating certificates"
openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:2048 -subj '/O=example Inc./CN=opentlc.com' -keyout opentlc.com.key -out opentlc.com.crt


openssl req -out server.server.svc.cluster.local.csr -newkey rsa:2048 -nodes -keyout server.server.svc.cluster.local.key -subj "/CN=server.server.svc.cluster.local/O=some organization"

openssl x509 -req -sha256 -days 365 -CA opentlc.com.crt -CAkey opentlc.com.key -set_serial 0 -in server.server.svc.cluster.local.csr -out server.server.svc.cluster.local.crt


openssl req -out client.opentlc.com.csr -newkey rsa:2048 -nodes -keyout client.opentlc.com.key -subj "/CN=client.opentlc.com/O=client organization"
openssl x509 -req -sha256 -days 365 -CA opentlc.com.crt -CAkey opentlc.com.key -set_serial 1 -in client.opentlc.com.csr -out client.opentlc.com.crt


oc create -n server secret tls server-certs --key server.server.svc.cluster.local.key --cert server.server.svc.cluster.local.crt
oc create -n server secret generic ca-certs --from-file=opentlc.com.crt


kubectl create secret -n client generic client-credential --from-file=tls.key=client.opentlc.com.key \
  --from-file=tls.crt=client.opentlc.com.crt --from-file=ca.crt=opentlc.com.crt

cat client.opentlc.com.crt opentlc.com.crt > client.pem
openssl pkcs12 -export -out client.p12 -in client.pem -inkey client.opentlc.com.key


