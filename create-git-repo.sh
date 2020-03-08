#!/bin/bash

creategitrepo(){
    local PATH_PROJECTS_FOLDER=~/desktop/code/projects
    local PATH_PYTHON_SCRIPT=~/desktop/code/python/git_repo_script
    local FILE_PYTHON_SCRIPT=create-git-repo.py
    local GITHUB_USERNAME=harluss

    local IS_PRIVATE=false
    local DESCRIPTION=""
    local ERROR_OPTIONS=false
    local EDITOR_OPEN=false

    local COLOR_ERROR="\e[31m"
    local COLOR_OK="\e[32m"
    local COLOR_DEFAULT="\e[39m"

    while getopts ":d:hop" FLAG; do
        case $FLAG in
            d)
                DESCRIPTION=$OPTARG
                ;;
            h)
                _help_creategitrepo $0
                return 0
                ;;
            o)
                EDITOR_OPEN=true
                ;;
            p)
                IS_PRIVATE=true
                ;;
            \?)
                _echo_error "Invalid option: -$OPTARG"
                ERROR_OPTIONS=true
                ;;
            :)
                _echo_error "Option -$OPTARG requires an argument."
                ERROR_OPTIONS=true
                ;;
        esac
    done

    if [[ $ERROR_OPTIONS == true ]]; then
        return 1
    fi

    shift $((OPTIND -1))

    if [[ ! $1 ]]; then
        _echo_error "Repository name is missing."
        _help_creategitrepo $0
        return 1
    fi

    cd

    if [[ -d "$PATH_PROJECTS_FOLDER/$1" ]]; then
        _echo_error "Folder $1/ already exist."
        return 1
    fi

    cd

    if [[ ! -f "$PATH_PYTHON_SCRIPT/$FILE_PYTHON_SCRIPT" ]]; then   
        _echo_error "Scirpt $FILE_PYTHON_SCRIPT does NOT exist."
        return 1
    fi

    # Run python script to create a GitHub repository (pass repository name, private boolean and description)
    python $PATH_PYTHON_SCRIPT/$FILE_PYTHON_SCRIPT $1 $IS_PRIVATE "$DESCRIPTION"

    # Python script will return 0 for success and 99 if an error occurred
    if (( $? == 0 )); then
        # Create a folder, readme file, commit and push to the new repo
        cd $PATH_PROJECTS_FOLDER
        mkdir $1 && _echo_ok "Folder $1/ created."
        cd $1 
        touch README.md && _echo_ok "README.md file created."
        echo "# $1" >> README.md
        git init && _echo_ok "Local repository initiated."
        git add .
        git commit -m "initial commit" && _echo_ok "Initial commit done."
        git remote add origin https://github.com/$GITHUB_USERNAME/$1.git && _echo_ok "Remote repository added."
        git push -u origin master && _echo_ok "Commit pushed to the remote repository."

        if [[ $EDITOR_OPEN == true ]]; then
            code .
            return 0
        fi
    else
        return $?
    fi
}

_echo_error(){
    echo -e "${COLOR_ERROR}ERROR:\t$1${COLOR_DEFAULT}" >&2
}

_echo_ok(){
    echo -e "${COLOR_OK}OK:\t$1${COLOR_DEFAULT}" >&2
}

_help_creategitrepo(){
echo "
Usage:  $1 [-d \"Some description.\"] [-o] [-p] [-h] <repository-name>

Where:
        -d \"text\"   Adds description (None by default)
        -h          Help
        -o          Opens project in VS Code
        -p          Sets visibility to Private (Public by default)

Info:   Shell/Python scripts automating GitHub repository creation process.
        Uses Python script to create remote Git repository and bash commands to create
        local folder (of the same name as the repository) with README.md file,
        initiates git, makes initial commit and pushes it to the repository."
}

creategitrepo "$@"