#!/usr/bin/env bash

set -e

ytt \
  -f ./k8s/extension \
  -f extensions/uscities/uscities.client-extension-config.json \
  --data-value cpu=500m \
  --data-value image=uscities \
  --data-value memory=512Mi \
  --data-value serviceId=uscities \
  --data-value-yaml debugPort=8002 \
  --data-value "virtualInstanceId=$1" \
  --data-value-yaml initMetadata=true