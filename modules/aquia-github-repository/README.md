# Aquia Github Single Repository module
## Purpose:
This module is intended to implement the standard repository configuration for aquia repos.

## Usage:
The module can be used with the below example code:
```
provider "github" {
    # add configuration here for the organization connection or as environment variables
}

module "repoistory" {
    source = "../aquia-github-repository"
    repo = "test-repo"
    admins = ["bob","fred"]
}
```

## Resources:
* github_repoistory: repository
* github_branch_protection: repository-main-protection
* github_team: admins-team
* github_team: contributors-team
* gihtub_team_membership: contributors-team
* gihtub_team_membership: admins-team
* github_team_repository: admins-team-mapping
* github_team_repository: contributors-team-mapping

## Variables:
* repo: a string representing the name of the repo
* admins: a list of strings representing github user ids of users to be configured as admins