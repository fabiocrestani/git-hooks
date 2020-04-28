# This is a pre commit hook which prevent some file extensions to be commited into feature branches

echo "Calling pre-commit-hook.sh"

# If you are in this branch, the hook will not take action
branch_to_skip="master"

git_branch=$(git rev-parse --abbrev-ref HEAD)
list_of_files=$(git diff --cached --name-only --diff-filter=ACM)

echo "Current branch is $git_branch"

if [ $git_branch == $branch_to_skip ]; then
	echo "Pre-commit hook will not take action in branch $git_branch"
	exit 0
else
  
	found_forbidden_files=0
	while read line
	do
		filename="${line##*/}"
		extension="${line##*.}"
		
		# Forbidden extensions
		if [[ $extension == "txt" ]] || [[ $extension == "bin" ]]; then
			echo "Forbidden extension found in $line"
			echo "Please remove all $extension files from the staging area"
			echo ""
			found_forbidden_files=1
		fi
	done <<< "$list_of_files"
fi

if [[ $found_forbidden_files -eq 1 ]]; then
	echo "Found forbidden files. Please remove these files before commiting"
	exit 1
else
	exit 0
fi


