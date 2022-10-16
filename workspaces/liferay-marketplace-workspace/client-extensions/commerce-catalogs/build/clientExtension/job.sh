#!/bin/bash

OAUTH2_PROFILE="commerce-catalogs"

set -e

VERBOSE_FLAG=""

JOB_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

echo "########################"
echo "JOB DIR = $JOB_DIR"

echo "########################"
echo "Mounted Config:"
find /etc/liferay/lxc/ext-init-metadata -type l -not -ipath "*/..data" -print -exec sed 's/^/    /' {} \; -exec echo "" \;
find /etc/liferay/lxc/dxp-metadata -type l -not -ipath "*/..data" -print -exec sed 's/^/    /' {} \; -exec echo "" \;

echo "########################"
DXP_HOST=$(cat /etc/liferay/lxc/dxp-metadata/com.liferay.lxc.dxp.mainDomain)
OAUTH2_CLIENTID=$(cat /etc/liferay/lxc/ext-init-metadata/${OAUTH2_PROFILE}.oauth2.headless.server.client.id)
OAUTH2_SECRET=$(cat /etc/liferay/lxc/ext-init-metadata/${OAUTH2_PROFILE}.oauth2.headless.server.client.secret)

echo "DXP_HOST: ${DXP_HOST}"
echo "OAUTH2_PROFILE: ${OAUTH2_PROFILE}"
echo "OAUTH2_CLIENTID: ${OAUTH2_CLIENTID}"
echo "OAUTH2_SECRET: ${OAUTH2_SECRET}"

echo "########################"
TOKEN_RESULT=$(\
	curl \
		-s \
		$VERBOSE_FLAG \
		-X POST \
		"https://${DXP_HOST}/o/oauth2/token" \
		-H 'Content-type: application/x-www-form-urlencoded' \
		-d "grant_type=client_credentials&client_id=${OAUTH2_CLIENTID}&client_secret=${OAUTH2_SECRET}" \
		--cacert ../ca.crt \
		| jq -r '.')
echo "TOKEN_RESULT: ${TOKEN_RESULT}"

ACCESS_TOKEN=$(jq -r '.access_token' <<< $TOKEN_RESULT)

echo "ACCESS_TOKEN: ${ACCESS_TOKEN}"

if [ "${ACCESS_TOKEN}" == "null" ];then
	exit 1
fi

process_batch() {
	echo "########################"
	echo "######### BATCH ${1}"

	rm -rf /tmp/items

	jq -r '.items' "${1}" > /tmp/items


	# TODO: The URL '.actions.batch.href' should actually be available on any
	# resources that support batch and we should be able to fetch it without
	# manipulation aside from stripping the protocol and domain.
	local BASE_HREF=$(jq -r '.actions.create.href' ${1})
	BASE_HREF="/${BASE_HREF#*://*/}"
	echo "BASE_HREF=${BASE_HREF}"

	local BATCH_HREF=$(jq -r '.actions.createBatch.href' ${1})
	BATCH_HREF="/${BATCH_HREF#*://*/}"
	echo "BATCH_HREF=${BATCH_HREF}"

	local RESULT=$(\
		curl \
			-s \
			$VERBOSE_FLAG \
			-X 'POST' \
			"https://${DXP_HOST}${BATCH_HREF}?createStrategy=INSERT" \
			-H 'accept: application/json' \
			-H 'Content-Type: application/json' \
			-H "Authorization: Bearer ${ACCESS_TOKEN}" \
			-d "@/tmp/items" \
			--cacert ../ca.crt \
			| jq -r '.')

	if [ "${RESULT}x" == "x" ]; then
		echo "An error occured"
		exit 1
	fi

	echo "RESULT=${RESULT}"

	local BATCH_EXTERNAL_REFERENCE_CODE=$(jq -r '.externalReferenceCode' <<< "$RESULT")

	local BATCH_STATUS="INITIAL"

	until [ "${BATCH_STATUS}" == "COMPLETED" ] || [ "${BATCH_STATUS}" == "FAILED" ] || [ "${BATCH_STATUS}" == "NOT_FOUND" ]; do
		RESULT=$(\
			curl \
				-s \
				$VERBOSE_FLAG \
				-X 'GET' \
				"https://${DXP_HOST}/o/headless-batch-engine/v1.0/import-task/by-external-reference-code/${BATCH_EXTERNAL_REFERENCE_CODE}" \
				-H 'accept: application/json' \
				-H "Authorization: Bearer ${ACCESS_TOKEN}" \
				--cacert ../ca.crt \
				| jq -r '.')

		BATCH_STATUS=$(jq -r '.executeStatus//.status' <<< "$RESULT")

		echo "BATCH STATUS: ${BATCH_STATUS}"
	done
}

for i in $(find . -type f -name *.data.batch-engine.json); do
	process_batch $i
done
