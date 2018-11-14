#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

readonly original_dir="$( pwd )"

readonly filename=${1:-repos.txt}
readonly repos_file="${script_dir}/${filename}"
readonly origins_file="${script_dir}/origins.txt"

# Check that the command line supplied (or default) 'repos file' exists
if [ ! -f "${repos_file}"  ]; then
	echo "### File \'${repos_file}' does not exist!"
	exit 1
fi

cd "${script_dir}/.."
readonly repos_parent_dir="$( pwd )" 

# Read the 'repos_file' into the 'repos' array
while IFS= read -r line; do
    repos+=("$line")
done < "${repos_file}"

# Check that the 'repos' array has more than zero elements
if ! [[ "${#repos[@]}" -gt 0 ]]; then
	echo "### File \'${script_dir}/${arg1}' should contain a list of repositories"
	exit 1
fi

# Read the 'origins_file' into the 'origins' array
while IFS= read -r line; do
    origins+=("$line")
done < "${origins_file}"

# Loop through all the elements in the  'repos' array
for repo_line in "${repos[@]}"
do

	trim_line="${repo_line#"${repo_line%%[![:space:]]*}"}"  # Remove leading whitespace

	if ! [[ -z ${trim_line} ]]; then    # Only 'process' non-empty lines

		IFS=',' read -r -a repo_info <<< "${trim_line}" # Read trim_line into an array of REPO
		repo_name="${repo_info[0]}"

		if ! echo "${repo_name}" | grep -E '^#' > /dev/null # Check for a 'comment' line
		then

			if [[ "${#repo_info[@]}" -gt 1 ]]; then

				remote_index="${repo_info[1]:-0}"
				repo_branch="${repo_info[2]:-master}"

				IFS=' #' read -r -a repo_info <<< "${repo_branch}"  # Split to remove trailing space and comment
				repo_branch="${repo_info[0]:-master}"

				#echo "dir:${repo_name}, index:${remote_index}, branch:${repo_branch}."	

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
