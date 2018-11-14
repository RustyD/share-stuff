#!/usr/bin/env bash

function _execute_git() {

	if [ -d "${repos_parent_dir}/${repo_name}"  ]; then

		cd "${repos_parent_dir}/${repo_name}"

		echo
		echo "*** Repository ${repo_name} ***"
		git status

		local status=$?
		if [ $status -eq 0 ]; then
			echo 
		else
			echo
			echo "### Failed to 'status' ${repo_name}"
			echo
		fi

	else
		echo	
		echo "### Folder (local repository) ${repos_parent_dir}/${repo_name} does not yet exist."
		echo	
	fi

}

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${script_dir}/assignVars.sh"
