#!/bin/bash

creategitrepo(){
    local GITHUB_USERNAME=$GITHUB_USER
    local GITHUB_TOKEN=$GITHUB_API_TOKEN
    
    local COLOR_ERROR="\e[31m"
    local COLOR_OK="\e[32m"
    local COLOR_DEFAULT="\e[39m"

    local name=""
    local description=""
    local is_private=false
    local error_options=false

    while getopts ":d:hop" FLAG; do
        case $FLAG in
            d)
                description=$OPTARG
                ;;
            h)
                _help_creategitrepo
                return 0
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
    fi
    
    _echo_ok "Remote repository $name created (Status Code: $response)."
    _echo_ok_next

    return 0
}

_echo_error(){
    echo -e "${COLOR_ERROR}ERROR:\t$1${COLOR_DEFAULT}" >&2
}

_echo_ok(){
    echo -e "${COLOR_OK}OK:\t$1${COLOR_DEFAULT}" >&2
}

_echo_ok_next(){
    echo -e "${COLOR_OK}NEXT:\tNavigate to project's folder and run:

    \tgit init
    \tgit remote add origin https://github.com/$GITHUB_USERNAME/$name.git
    ${COLOR_DEFAULT}"
}

_help_creategitrepo(){
    echo "
Usage:  create-git-repo [-d \"Some description\"] [-p] [-h] <repository-name>

Where:  -d \"text\"   Adds description (None by default)
        -p          Sets visibility to Private (Public by default)
        -h          Displays help

Info:   Shell script automating GitHub remote repository creation."
}

creategitrepo "$@"