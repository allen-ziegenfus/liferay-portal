#!/bin/bash

echo "Cloning repo"

mkdir -p ~/.ssh

echo "-----BEGIN OPENSSH PRIVATE KEY-----" > ~/.ssh/id_rsa
echo "$LIFERAY_LEARN_GITHUB_DEPLOY_KEY" | fold -w 64 >> ~/.ssh/id_rsa
echo "-----END OPENSSH PRIVATE KEY-----" >> ~/.ssh/id_rsa

chmod 600 ~/.ssh/id_rsa

ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts

git clone --depth 1 "${LIFERAY_LEARN_GITHUB_REPO}" /opt/liferay-learn

git -C /opt/liferay-learn log

cd /opt/liferay-learn/docs || exit

if [ -z "$SKIP_UPDATE_EXAMPLES" ] ; then
	echo "Running update_examples.sh"

	./update_examples.sh prod
fi

echo "Starting java import"

java -Xmx2048m -agentlib:jdwp=transport=dt_socket,address=*:${DEBUG_PORT:-8001},server=y,suspend=n -jar /app.jar