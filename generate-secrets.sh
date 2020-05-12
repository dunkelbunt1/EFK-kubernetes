#!/bin/bash
# Usage: STACK_VERSION=7.6.2 DNS_NAME=elasticsearch NAMESPACE=efk-log ./create-elastic-certificates.sh

# ELASTICSEARCH
docker run --name escerts --env $DNS_NAME -i -w /app docker.elastic.co/elasticsearch/elasticsearch:7.6.2  /bin/sh -c " \
                elasticsearch-certutil ca --out /app/elastic-stack-ca.p12 --pass '' && \
                elasticsearch-certutil cert --name $DNS_NAME --dns $DNS_NAME --ca /app/elastic-stack-ca.p12 --pass '' --ca-pass '' --out /app/elastic-certificates.p12" && \
docker cp escerts:/app/elastic-certificates.p12 ./ && \
docker rm -f escerts && \
openssl pkcs12 -nodes -passin pass:'' -in elastic-certificates.p12 -out elastic-certificate.pem && \
kubectl-n $NAMESPACE create secret generic elastic-certificates --from-file=elastic-certificates.p12 && \
kubectl -n $NAMESPACE create secret generic elastic-certificate-pem --from-file=elastic-certificate.pem && \
#kubectl -n $NAMESPACE create secret generic elastic-credentials  --from-literal=password=$password --from-literal=username=elastic && 
rm -f elastic-certificates.p12 elastic-certificate.pem elastic-stack-ca.p12