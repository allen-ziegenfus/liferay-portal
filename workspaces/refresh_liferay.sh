#!/bin/bash

function main {
	for dir in ./liferay-*workspace
	do
		if [ -e ${dir}.temp ]
		then
			echo "${dir}.temp already exists."

			exit 1
		fi

		mv ${dir} ${dir}.temp

		mkdir ${dir}

		cp -R sample-minimal-workspace/* ${dir}

		rm -fr ${dir}/client-extensions/*

		cp -R ${dir}.temp/client-extensions/* ${dir}/client-extensions

		rm -fr ${dir}.temp
	done
}

main "${@}"