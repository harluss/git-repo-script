from github import Github, GithubObject
import sys
import os

COLOR_ERROR = '\33[31m'
COLOR_OK = '\33[32m'
COLOR_DEFAULT = '\33[39m'


def input_get():
    # NOTE: Check if project name exists is handled by the bash script.
    proj_name = str(sys.argv[1])
    proj_priv = True if sys.argv[2].lower() == 'true' else GithubObject.NotSet
    proj_desc = str(sys.argv[3]) if str(sys.argv[3]) else GithubObject.NotSet

    return proj_name, proj_priv, proj_desc


def user_get():
    # NOTE: GitHub Personal Access Token set as an environment variable G_TOKEN.
    gtoken = os.environ.get('G_TOKEN')
    user = Github(gtoken).get_user()

    return user


def repo_exists_check(user, proj_name):
    try:
        repos = user.get_repos()
    except Exception as ex:
        print_error(ex)
        exit(99)

    for repo in repos:
        if repo.name == proj_name:
            print_error(f'Repository {proj_name} already exists.')
            exit(99)


def repo_create(user, proj_name, proj_priv, proj_desc):
    try:
        repo = user.create_repo(
            proj_name, description=proj_desc, private=proj_priv)
    except Exception as ex:
        print_error(ex)
        exit(99)
    else:
        print_ok(f'Remote repository {repo.name} created.')
        exit(0)


def print_error(message):
    print(f'{COLOR_ERROR}ERROR:\t{message}{COLOR_DEFAULT}')


def print_ok(message):
    print(f'{COLOR_OK}OK:\t{message}{COLOR_DEFAULT}')


def main():
    proj_name, proj_priv, proj_desc = input_get()
    user = user_get()
    repo_exists_check(user, proj_name)
    repo_create(user, proj_name, proj_priv, proj_desc)


if __name__ == '__main__':
    main()
