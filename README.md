# Shell / Python Script Automating GitHub Repo Creation

Python script automating GitHub repository creation process, triggered by a shell script that creates a local repository with a README.md file then commits and pushes it to the newly created repo. 

### Setup
Add the content of `.my_custom_commands.sh` to your custom commands `.sh` file or add a path to this file to your `.bash_profile` or `.zshrc` or whatever config file your shell uses. Example:
```
source ~/.my_custom_commands.sh
```
Install Python packages with:
```
pip install -r requirements.txt
```
Change paths in `.sh` script:
```
PATH_PROJECTS_FOLDER=desktop/code/projects              # Change this path to your projects folder
PATH_PYTHON_SCRIPT=desktop/code/python/git_repo_script  # Change this path to your python script location
FILE_PYTHON_SCRIPT=creategitrepo.py                     # Change this filename to your python script filename

git remote add origin https://github.com/harluss/$1.git # Change harlus to your GitHub username
```
And in `.py` script:
```
PATH_PROJECTS_FOLDER = 'desktop/code/projects'          # Same as above, to your projects folder

gtoken = os.environ.get('G_TOKEN')                      # This is a GitHub Personal Access Token. Set yours as an environment variable or replace with: gtoken = YOUR_TOKEN.
```

### Usage
```
creategitrepo your_project_name
```
It will check if GitHub repo and local folder with `your_project_name` exists, if so it will stop and return appropriate message, if not it will continue and create them.
### Packages
```
PyGithub==1.43.8
```