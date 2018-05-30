#!/usr/bin/env bash

function _execute_git() {
	if [ ! -d "${repos_parent_dir}/${repo_name}" ]; then
	
		local remote_origin="${origins[$remote_index]:?ERROR - file \'$origins_file\' does not have an entry on line $remote_index}"
		local remote_repo_url="${remote_origin}${repo_name}.git"
		
		echo
		echo "*** Repository ${remote_repo_url} ***"
		git clone "${remote_repo_url}"
		
		local status=$?
		if [ $status -eq 0 ]; then
			echo
		else
			echo
			echo "### Failed to clone ${repo_name} from ${remote_origin}"
			echo
			cd "${original_dir}"
			exit 1
		fi
	else
		echo "### Directory ${repos_parent_dir}/${repo_name} already exists, cannot clone into it."
		echo
	fi
}

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${script_dir}/assignVars.sh"
