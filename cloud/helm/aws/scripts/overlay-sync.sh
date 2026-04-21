#!/bin/sh

set -o errexit
set -o nounset

function main {
	if [ "${#}" -ne 3 ]
	then
		_log_json "Usage: ${0} <provider-type> <from-path> <into-path>." "ERROR"

		exit 1
	fi

	local bucket_name="${LIFERAY_OVERLAY_BUCKET_NAME:-${S3_BUCKET_ID:-}}"
	local from_path="${2}"
	local into_path="${3}"

	if [ -z "${bucket_name}" ]
	then
		_log_json "No overlay bucket found (checked LIFERAY_OVERLAY_BUCKET_NAME and S3_BUCKET_ID). Skipping sync." "ERROR"

		exit 1
	fi

	local include_pattern=""

	if echo "${from_path}" | grep -q "\*"
	then
		include_pattern="${from_path##*/}"
		from_path="${from_path%/*}"
	fi

	local source_uri="s3://${bucket_name}/${from_path}"
	local target_path="/temp/${into_path}"

	_log_json "Syncing from \"${source_uri}\" to \"${target_path}\"."

	if [ -n "${include_pattern}" ]
	then
		aws s3 sync "${source_uri}" "${target_path}" --exclude "*" --include "${include_pattern}"
	else
		aws s3 sync "${source_uri}" "${target_path}"
	fi

	_log_json "Sync completed successfully."
}

function _log_json {
	local escaped_message

	escaped_message=$(echo "${1}" | sed 's/"/\\"/g')

	local script_name

	script_name=$(basename "${0}")

	local severity="${2:-INFO}"

	local timestamp

	timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

	printf '{"message": "%s", "script": "%s", "severity": "%s", "timestamp": "%s"}\n' "${escaped_message}" "${script_name}" "${severity}" "${timestamp}"
}

main "${@}"