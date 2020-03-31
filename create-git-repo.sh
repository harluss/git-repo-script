#!/bin/bash

creategitrepo(){
    local PATH_PROJECTS_FOLDER=~/desktop/code/projects
    local GITHUB_USERNAME=$GITHUB_USER
    local GITHUB_TOKEN=$GITHUB_API_TOKEN
    
    local COLOR_ERROR="\e[31m"
    local COLOR_OK="\e[32m"
    local COLOR_DEFAULT="\e[39m"

    local name=""
    local description=""
    local is_private=false
    local error_options=false
    local editor_open=false

    while getopts ":d:hop" FLAG; do
        case $FLAG in
            d)
                description=$OPTARG
                ;;
            h)
                _help_creategitrepo
                return 0
                ;;
            o)
                editor_open=true
                ;;
            p)
                is_private=true
                ;;
            \?)
                _echo_error "Invalid option: -$OPTARG."
                error_options=true
                ;;
            :)
                _echo_error "Option -$OPTARG requires an argument."
                error_options=true
                ;;
        esac
    done

    if [[ $error_options == true ]]; then
        return 1
    fi

    shift $((OPTIND -1))
    name=$1

    if [[ ! $name ]]; then
        _echo_error "Repository name is missing."
        _help_creategitrepo
        return 1
    fi

    if [[ -d "$PATH_PROJECTS_FOLDER/$name" ]]; then
        _echo_error "Folder $PATH_PROJECTS_FOLDER/$name/ already exist."
        return 1
    fi

    git ls-remote https://github.com/$GITHUB_USERNAME/$name 2>/dev/null

    if (( $? == 0 )); then
        _echo_error "Remote repository $name already exist."
        return 1
    fi

    local github_data='{ 
        "name": "'$name'", 
        "description": "'$description'", 
        "private": '$is_private'
        }'

    response=$(curl -s -o /dev/null -w %{http_code} -H "Authorization: token $GITHUB_TOKEN" -d "$github_data" https://api.github.com/user/repos)

    if (( $response != 201 )); then
        _echo_error "Remote repository creation failed (Status Code: $response)."
        return 1
    else
        _echo_ok "Remote repository $name created (Status Code: $response)."
    fi
        
    mkdir -p $PATH_PROJECTS_FOLDER/$name && _echo_ok "Folder $name/ created."
    cd $PATH_PROJECTS_FOLDER/$name 
    touch README.md && echo "# $name" >> README.md && _echo_ok "README.md file created."

    git init && _echo_ok "Local repository initiated."
    git add .
    git commit -m "initial commit" && _echo_ok "Initial commit done."
    git remote add origin https://github.com/$GITHUB_USERNAME/$name.git && _echo_ok "Remote repository added."
    git push -u origin master && _echo_ok "Initial commit pushed to the remote repository."

    if [[ $editor_open == true ]]; then
        code .
    fi

    return 0
}

_echo_error(){
    echo -e "${COLOR_ERROR}ERROR:\t$1${COLOR_DEFAULT}" >&2
}

_echo_ok(){
    echo -e "${COLOR_OK}OK:\t$1${COLOR_DEFAULT}" >&2
}

_help_creategitrepo(){
echo "
Usage:  create-git-repo [-d \"Some description.\"] [-o] [-p] [-h] <repository-name>

Where:
        -d \"text\"   Adds description (None by default)
        -h          Help
        -o          Opens project in VS Code
        -p          Sets visibility to Private (Public by default)

Info:   Shell script automating GitHub repository creation process.
        Creates remote Git repository and local folder with an empty README.md file, 
        initiates local Git repository, makes initial commit, adds remote repository 
        and pushes to it."
}

creategitrepo "$@"