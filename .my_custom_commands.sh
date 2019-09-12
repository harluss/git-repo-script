#!/bin/bash

function creategitrepo(){
    PATH_PROJECTS_FOLDER=desktop/code/projects              # Change this path to your projects folder
    PATH_PYTHON_SCRIPT=desktop/code/python/git_repo_script  # Change this path to your python script location
    FILE_PYTHON_SCRIPT=creategitrepo.py                     # Change this filename to your python script filename

    # Check if project_name was passed in
    if [ ! $1 ]
    then
        echo "Project name is missing (creategitrepo project_name)."
        return
    fi

    cd

    # Check if folder already exists
    if [ -d "$PATH_PROJECTS_FOLDER/$1" ]
    then
        echo "Folder $1 already exist."
        return
    fi

    cd

    # Check if Python script exists
    if [ ! -f "$PATH_PYTHON_SCRIPT/$FILE_PYTHON_SCRIPT" ]
    then   
        echo "Scirpt $FILE_PYTHON_SCRIPT does NOT exist."
        return
    fi

    # Run python script that will create a GitHub repo
    python $PATH_PYTHON_SCRIPT/$FILE_PYTHON_SCRIPT $1

    # Python script will print message and return 100 if Git repo already exists
    if [ $? -eq 100 ]
    then
        return
    fi
    
    # Create a folder, readme file, commit and push to the new repo
    cd $PATH_PROJECTS_FOLDER
    mkdir $1
    cd $1
    touch README.md
    echo "# $1" >> README.md
    git init
    git add .
    git commit -m "initial commit"
    git remote add origin https://github.com/harluss/$1.git    # Change harluss to your username
    git push -u origin master
}