# register the project name with dev-env
PROJECT_NAME="${PWD##*/}"
echo "Hit enter to accept default"

# get the project name
echo -n "Project Name ($PROJECT_NAME): "
read answer
if [[ $answer ]]; then
    PROJECT_NAME=$answer
fi
