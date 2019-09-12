from github import Github
import sys
import os

PATH_PROJECTS_FOLDER = 'desktop/code/projects'
# NOTE: Check if folder_name exists is handled by the shell script.
project_name = str(sys.argv[1])
# NOTE: This is a GitHub Personal Access Token. Set yours as an environment variable or replace with: gtoken = YOUR_TOKEN.
gtoken = os.environ.get('G_TOKEN')
user = Github(gtoken).get_user()


def repo_check():
    for repo in user.get_repos():
        if repo.name == project_name:
            print(f'Repository {project_name} already exists.')
            exit(100)


def create():
    user.create_repo(project_name)
    print(f'Repo {project_name} created.')


if __name__ == '__main__':
    repo_check()
    create()
