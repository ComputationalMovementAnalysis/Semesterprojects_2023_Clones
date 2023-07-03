
# add all submodules
awk -F, '{ system("git submodule add " $2 " " $1)}' df.csv

# get last commit of each submodule and add export as csv
git submodule foreach --quiet 'echo "$path",$(git log -1 --format="%ai")' > submodule_commits.csv
