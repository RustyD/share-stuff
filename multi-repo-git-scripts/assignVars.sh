#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

readonly original_dir="$( pwd )"

cd "${script_dir}/../.."
readonly repos_parent_dir="$( pwd )" 
readonly repos_file="${script_dir}/repos.txt"
readonly origins_file="${script_dir}/origins.txt"

mapfile -t repos < "${repos_file}"
mapfile -t origins < "${origins_file}"

for repo_line in "${repos[@]}"
do

	trim_line="${repo_line#"${repo_line%%[![:space:]]*}"}"  # Remove leading whitespace
	
	if ! [[ -z ${trim_line} ]]; then    # Process non-empty lines
	
		IFS=',' read -r -a repo_info <<< "${trim_line}" # Read trim_line into an array of REPO
		repo_name="${repo_info[0]}"
		
		if ! [[ "${repo_name}" =~ ^# ]]; then   # Commented out lines begin with '#'

			if [[ "${#repo_info[@]}" -gt 1 ]]; then
			
				remote_index="${repo_info[1]:-0}"
				repo_branch="${repo_info[2]:-master}"
			
				IFS=' #' read -r -a repo_info <<< "${repo_branch}"  # Split to remove trailing space and comment
				repo_branch="${repo_info[0]:-master}"
						
				echo "dir:${repo_name}, index:${remote_index}, branch:${repo_branch}."	
					
				_execute_git
				
			else
				echo "### Repo info line needs 'repo_name,remote_index,repo_branch'   but is:  ${trim_line}"
			fi	

		else 
			echo "### Skip comment: ${trim_line}"
		fi
	fi

done

cd "${original_dir}"
