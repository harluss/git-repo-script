# Shell Script Automating GitHub Repo Creation

Creates remote Git repository and local folder with an empty README.md file, initiates local Git repository, makes initial commit, adds remote repository and pushes to it.

### Setup
Add the content of `.my_custom_commands.sh` to your custom commands `.sh` file or add the path to this file to your `.bash_profile` or `.zshrc` or whatever config file your shell uses. Example:
```
source ~/.my_custom_commands.sh
```
This will allow you to run the script from any location by just typing `create-git-repo` with appropriate arguments (see Usage below), without the need of changing folders or using `bash create-git-repo.sh`.

Change paths in `.my-custom-commands.sh`:
```
PATH_BASH_SCRIPT=~/desktop/code/projects/git-repo-script    # Change this path to your script location
```

In `create-git-repo.sh`:
```
PATH_PROJECTS_FOLDER=~/desktop/code/projects                # Change this to your projects folder
GITHUB_USERNAME=$GITHUB_USER                                # Change this to your GitHub username
GITHUB_TOKEN=$GITHUB_API_TOKEN                              # Change this to your GitHub token
```

### Usage
```
create-git-repo [-d "Some description."] [-o] [-p] [-h] <repository-name>

Where:
        -d "text"   Adds description (None by default)
        -h          Help
        -o          Opens project in VS Code
        -p          Sets visibility to Private (Public by default)
```
It will check if GitHub repository and local folder with `repository-name` exist, if so it will stop and return appropriate message, if not it will continue and create them.
### Note:
You may need to run `chmod +x create-git-repo.sh` to add execute permission.