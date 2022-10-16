#!/usr/bin/env bash

set -e

cd extensions/uscities

if [[ "$OSTYPE" == "darwin"* ]]; then
  export JAVA_HOME=$(/usr/libexec/java_home -v 11)
fi

mvn clean package

cp ../../k8s/tls/ca.crt .

docker build -t $EXPECTED_REF .