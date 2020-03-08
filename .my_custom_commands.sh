#!/bin/bash

create-git-repo(){
    local PATH_BASH_SCRIPT=~/desktop/code/python/git_repo_script
    local FILE_BASH_SCRIPT=create-git-repo.sh

    bash $PATH_BASH_SCRIPT/$FILE_BASH_SCRIPT "$@"
}