#!/bin/bash

function send_slack_message() {
	SLACK_MESSAGE=$1

	echo "$SLACK_MESSAGE"

	if [ -z "$SLACK_ENDPOINT" ] ; then return 0; fi

	TIMESTAMP=$(date)
	LOG_URL="https://console.${LCP_INFRASTRUCTURE_DOMAIN}/projects/${LCP_PROJECT_ID}/services/${LCP_SERVICE_ID}/logs?instanceId=${HOSTNAME}&logServiceId=${LCP_SERVICE_ID}"

	SLACK_MESSAGE_TEXT="${TIMESTAMP} *${LCP_PROJECT_ID}*->*${LCP_SERVICE_ID}* <${LOG_URL}|${HOSTNAME}> \n>$SLACK_MESSAGE"

	curl -X POST --data-urlencode "payload={'channel': '${SLACK_CHANNEL}', 'username': 'devopsbot', 'text': '${SLACK_MESSAGE_TEXT}', 'icon_emoji': ':robot_face:'}" ${SLACK_ENDPOINT}
}

send_slack_message "Import job starting"

echo "Cloning repo"

mkdir -p ~/.ssh

echo "-----BEGIN OPENSSH PRIVATE KEY-----" > ~/.ssh/id_rsa
echo "$LIFERAY_LEARN_GITHUB_DEPLOY_KEY" | fold -w 64 >> ~/.ssh/id_rsa
echo "-----END OPENSSH PRIVATE KEY-----" >> ~/.ssh/id_rsa

chmod 600 ~/.ssh/id_rsa

ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts

REPO_FOLDER=~/liferay-learn

git clone -b ${LIFERAY_LEARN_GITHUB_BRANCH} --depth 1 --single-branch "${LIFERAY_LEARN_GITHUB_REPO}" $REPO_FOLDER

git -C $REPO_FOLDER log

GIT_COMMIT=$(git -C $REPO_FOLDER log -1 --pretty="%B %H %aN")

send_slack_message "Cloned repo *${LIFERAY_LEARN_GITHUB_REPO}* commit: *${GIT_COMMIT//$'\n'/}*"

cd $REPO_FOLDER/docs || exit

export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/
export PATH=$JAVA_HOME/bin:$PATH

java -version

if [ -z "$SKIP_UPDATE_EXAMPLES" ] ; then
	echo "Running update_examples.sh"

	UPDATE_EXAMPLES_LOG_FILE=~/update_examples.log

	./update_examples.sh prod 2> $UPDATE_EXAMPLES_LOG_FILE

	UPDATE_EXAMPLES_RC=$?

	echo "update_examples.sh error log:"
	cat $UPDATE_EXAMPLES_LOG_FILE

	ERROR_COUNT=$(wc -l < $UPDATE_EXAMPLES_LOG_FILE)

	send_slack_message "update_examples.sh finished with return code $UPDATE_EXAMPLES_RC. $ERROR_COUNT entries in error log file."
fi

if [ -z "$SKIP_GENERATE_ZIPS" ] ; then
	cd $REPO_FOLDER/docs || exit

	for docs_dir_name in $(find . -maxdepth 4 -mindepth 4 -type f -name "contents.rst" -printf "%h\n" )
	do
		language=$(echo "${docs_dir_name}" | cut -f4 -d'/')
		product=$(echo "${docs_dir_name}" | cut -f2 -d'/')
		version=$(echo "${docs_dir_name}" | cut -f3 -d'/')

		product_version_language_dir_name=$(echo "${product}"/"${version}"/"${language}")

		for zip_dir_name in $(find "${product_version_language_dir_name}" -name *.zip -type d)
		do
			pushd "${zip_dir_name}"

			zip_file_name=$(basename "${zip_dir_name}")

			7z a ${zip_file_name} ../${zip_file_name}\

			7z rn ${zip_file_name} ${zip_file_name} ${zip_file_name%.*}

			popd

			output_dir_name=$(dirname "/public_html/${zip_dir_name}")
			output_dir_name=$(dirname "${output_dir_name}")
			output_dir_name=$(dirname "${output_dir_name}")

			mkdir -p "/${output_dir_name}"

			mv "${zip_dir_name}"/"${zip_file_name}" "${output_dir_name}"
		done
	done
fi

echo "Starting java import"

export JAVA_HOME=/opt/java/openjdk
export PATH=$JAVA_HOME/bin:$PATH

java -version

if [ -z "$LIFERAY_OAUTH_CLIENT_ID" ] ; then
	export LIFERAY_OAUTH_CLIENT_ID
	LIFERAY_OAUTH_CLIENT_ID=$(cat /etc/liferay/lxc/ext-init-metadata/liferay-learn-dxp-importer.oauth2.headless.server.client.id)
fi

if [ -z "$LIFERAY_OAUTH_CLIENT_SECRET" ] ; then
	export LIFERAY_OAUTH_CLIENT_SECRET
	LIFERAY_OAUTH_CLIENT_SECRET=$(cat /etc/liferay/lxc/ext-init-metadata/liferay-learn-dxp-importer.oauth2.headless.server.client.secret)
fi

if [ -z "$LIFERAY_URL" ] ; then
	export LIFERAY_URL
	LIFERAY_URL=https://$(cat /etc/liferay/lxc/dxp-metadata/com.liferay.lxc.dxp.mainDomain)
fi

java -Xmx2048m -agentlib:jdwp=transport=dt_socket,address=*:${DEBUG_PORT:-8001},server=y,suspend=n -jar /app.jar

IMPORT_RC=$?

if [ $IMPORT_RC -ne 0 ]; then
	send_slack_message ":red-alert: Import job finished with return code ${IMPORT_RC}"
else
	send_slack_message ":sunflower: Import job finished with return code ${IMPORT_RC}"
fi

exit 0