#!/usr/bin/env bash

function _execute_git() {

	if [ -d "${repos_parent_dir}/${repo_name}"  ]; then

		if [ ! -z "${repo_branch}" ] ; then

			cd "${repos_parent_dir}/${repo_name}"

			if [[ `git status --porcelain` ]]; then
				echo
				echo "### Skipping repository ${repo_name} because it has outstanding changes."
				git status
				echo
			else 

				if [[ `git branch --list ${repo_branch}` ]]; then

					echo
					echo "*** Repository ${repo_name}, branch ${repo_branch} ***"
					git checkout "${repo_branch}" && git merge --ff-only

					local status=$?
					if [ $status -eq 0 ]; then
						echo
					else
						echo
						echo "### Failed to merge branch ${repo_branch} in repository ${repo_name}"
						echo
					fi
				else
					echo
					echo "### Branch ${repo_branch} does not exist in repository ${repo_name}."
					echo
				fi
			fi

		else
			echo
			echo "### In order for this script to fast forward merge in ${repo_name}, a branch needs to be specified (typically 'development' or 'master')"
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
