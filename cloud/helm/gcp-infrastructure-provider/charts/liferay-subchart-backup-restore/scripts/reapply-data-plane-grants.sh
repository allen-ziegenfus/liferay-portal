#!/bin/sh

set -o errexit
set -o nounset

function main {
	local data_inactive="{{ "{{" }}inputs.parameters.data-inactive}}"
	local liferay_infrastructure_name="{{ "{{" }}inputs.parameters.liferay-infrastructure-name}}"

	local job_name="${liferay_infrastructure_name}-db-grant-${data_inactive}"
	local user_name="${liferay_infrastructure_name}-db-user-${data_inactive}"

	local reference_timestamp

	reference_timestamp=$(date --utc "+%Y-%m-%dT%H:%M:%SZ")

	kubectl \
		annotate \
		users.sql.gcp.m.upbound.io \
		"${user_name}" \
		"liferay.cloud/reapply-grants-timestamp=${reference_timestamp}" \
		--overwrite

	local timeout

	timeout=$(($(date +%s) + {{ .Values.liferayInfrastructure.waitTimeoutSeconds }}))

	while [ $(date +%s) -lt ${timeout} ]
	do
		local ready_condition

		ready_condition=$( \
			kubectl \
				get \
				users.sql.gcp.m.upbound.io \
				"${user_name}" \
				--output jsonpath="{.status.conditions[?(@.type==\"Ready\")]}" 2>/dev/null)

		[ -z "${ready_condition}" ] && ready_condition="{}"

		local last_transition_time

		last_transition_time=$(echo "${ready_condition}" | jq --raw-output ".lastTransitionTime // \"\"")

		local status

		status=$(echo "${ready_condition}" | jq --raw-output ".status // \"False\"")

		if [ "${status}" = "True" ] && [ -n "${last_transition_time}" ] && [ "$(expr "${last_transition_time}" \> "${reference_timestamp}")" = "1" ]
		then
			break
		fi

		sleep 10
	done

	if [ $(date +%s) -ge ${timeout} ]
	then
		echo "The system timed out waiting for the User \"${user_name}\" to reconcile after ${reference_timestamp}." >&2

		exit 1
	fi

	local job_manifest

	job_manifest=$( \
		kubectl \
			get \
			objects.kubernetes.m.crossplane.io \
			"${job_name}" \
			--output json \
			| jq ".spec.forProvider.manifest")

	kubectl \
		delete \
		job \
		"${job_name}" \
		--ignore-not-found \
		--wait

	printf "%s" "${job_manifest}" | kubectl apply --filename -

	kubectl \
		wait \
		--for=condition=complete \
		--timeout={{ .Values.liferayInfrastructure.waitTimeoutSeconds }}s \
		job/"${job_name}"
}

main