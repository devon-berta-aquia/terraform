# Single Repository Code and Configuration Model
## Introduction
This model aims to show how to apply code and configuration in the same repository typically along side application code.
The purpose is to show case how to consume such a repository for deployment with terraform.

## File structure:
* Environments folder: folder holding all of the enviornment configurations files
    * dev.tfvars: development environment configuration file
    * prod.tfvars: production environment configuration file
    * staging.tfvars: staging environment configuration file
    * {branch}.tfvars: branch specific environment configuration file used for local testing and validation
* Modules folder:
* main.tf
* data.tf
* output.tf
* provider.tf
* terraform.tf
* variables.tf

## CI/CD Workflow:
### Stages workflow:
``` mermaid
sequenceDiagram
git clone ->> git branch: clone and then checkout working branch
git branch ->> development: development done on branch
development ->> deploy dev: jenkins stage run to deploy to dev
deploy dev ->> pull request: Pull request to main is made
pull request ->> jenkins workflow: Jenkins workflow started
jenkins workflow ->> staging jenkins stage: pull branch and deploy to staging
staging jenkins stage ->> testing and validation: run tests after deployment
testing and validation ->> pull request: results posted to pull request
pull request ->> approval: approval given on pull request
approval ->> merge main: Code merged to main
merge main ->> jenkins workflow: Jenkins workflow started
jenkins workflow ->> production jenkins stage: pull branch and deploy to staging
production jenkins stage ->> testing and validation: run tests after deployment
```
### Stage Breakdown:
``` mermaid
sequenceDiagram
workflow ->> git clone: clone repository into agent runner
git clone ->> set working directory: set working directory to repository path
set working directory ->> terraform lint: lint the files to check for errors
terraform lint ->> terraform init: initialize directory, load modules and state
terraform init ->> terraform plan: execute terraform plan and output plan
terraform plan ->> approval: Approval gate on plan changes
approval ->> terraform apply: terraform apply ran after approval with auto accept
terraform apply ->> applied changes: Changes applied to target infrastructure
applied changes ->> terraform outputs: Outputs sent to ci/cd pipeline
terraform outputs ->> next steps: next steps use outputs or not
next steps ->> workflow: workflow ends after next steps completed
```