# Shell / Python Script Automating GitHub Repo Creation

Uses Python script to create remote Git repository and bash commands to create local folder (of the same name as the repository) with README.md file, initiates git, makes initial commit and pushes it to the repository.

### Setup
Install Python packages with:
```
pip install -r requirements.txt
```
Add the content of `.my_custom_commands.sh` to your custom commands `.sh` file or add the path to this file to your `.bash_profile` or `.zshrc` or whatever config file your shell uses. Example:
```
source ~/.my_custom_commands.sh
```
This will allow you to run the script from any location by just typing `create-git-repo` with appropriate arguments (see Usage below), without the need of changing folders or using `bash create-git-repo.sh`.

Change paths in `.my-custom-commands.sh`:
```
PATH_BASH_SCRIPT=~/desktop/code/python/git_repo_script      # Change this path to your script location
```

In `create-git-repo.sh`:
```
PATH_PROJECTS_FOLDER=~/desktop/code/projects                # Change this path to your projects folder
PATH_PYTHON_SCRIPT=~/desktop/code/python/git_repo_script    # Change this path to your python script location (same as bash script above)
GITHUB_USERNAME=harluss                                     # Change this username to your GitHub username
```
And in `create-git-repo.py`:
```
gtoken = os.environ.get('G_TOKEN')                          # This is a GitHub Personal Access Token. Set yours as an environment variable or replace with: gtoken = YOUR_TOKEN.
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
It will check if GitHub repo and local folder with `repository-name` exists, if so it will stop and return appropriate message, if not it will continue and create them.
### Note:
You may need to run `chmod +x create-git-repo.sh` to add execute permission.
### Packages
```
PyGithub==1.43.8
```