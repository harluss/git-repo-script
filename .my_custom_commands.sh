#!/bin/bash

create-git-repo(){
    local PATH_BASH_SCRIPT=~/code/projects/git-repo-script
    local FILE_BASH_SCRIPT=create-git-repo.sh

    bash $PATH_BASH_SCRIPT/$FILE_BASH_SCRIPT "$@"
}