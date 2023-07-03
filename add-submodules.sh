awk -F, '{ system("git submodule add " $2 " " $1)}' df.csv
