# Single Repository Code and Configuration Model
## Introduction
This model aims to show how to apply code and configuration in the same repository typically along side application code.
The purpose is to show case how to consume such a repository for deployment with terraform.
## Example design:
``` mermaid
graph
subgraph Region A
    subgraph VPC
        subgraph Public
            subgraph Public A
                Internet-Gateway-1-A <--> Load-Balancer-1-A
            end
            subgraph Public B
                Internet-Gateway-1-B <--> Load-Balancer-1-B
            end
            subgraph Public C
                Internet-Gateway-1-C <--> Load-Balancer-1-C
            end
            Load-Balancer-1
            Internet-Gateway-1
        end
        subgraph Internal
            subgraph Internal A
                nat-gateway-A <-->
                autoscale-group-1-instance-A <-->
                rational-database-service-1-instance-A
            end
            subgraph Internal B
                nat-gateway-B <-->
                autoscale-group-1-instance-B <-->
                rational-database-service-1-instance-B
            end
            subgraph Internal C
                nat-gateway-C <-->
                autoscale-group-1-instance-C <-->
                rational-database-service-1-instance-C
            end
            rational-database-service-1
            autoscale-group-1
        end
        Load-Balancer-1 <--> autoscale-group-1
        Internet-Gateway-1 <--> Load-Balancer-1
        Internet-Gateway-1 <--> Internet-Gateway-1-A & Internet-Gateway-1-B & Internet-Gateway-1-C
        autoscale-group-1 <--> autoscale-group-1-instance-A & autoscale-group-1-instance-B & autoscale-group-1-instance-C
        rational-database-service-1 <--> rational-database-service-1-instance-A & rational-database-service-1-instance-B & rational-database-service-1-instance-C
        Load-Balancer-1 <--> Load-Balancer-1-A & Load-Balancer-1-B & Load-Balancer-1-C
        
    end
end
```
``` mermaid

architecture-beta
    group public(tdesign:internet)[Public]
    group api(logos:aws-elb)[API]

    service db(logos:aws-aurora)[Database] in api
    service disk1(logos:aws-glacier)[Storage] in api
    service disk2(logos:aws-s3)[Storage] in api
    service server(logos:aws-ec2)[Server] in api

    db:L -- R:server
    disk1:T -- B:server
    disk2:T -- B:db

```
## File structure:
* Environments folder: folder holding all of the enviornment configurations files
    * dev.tfvars:
        * development environment configuration file
    * prod.tfvars:
        * production environment configuration file
    * staging.tfvars:
        * staging environment configuration file
    * {branch}.tfvars:
        * branch specific environment configuration file used for local testing and validation
* Modules folder: folder holding local modules developed for repository
    * VPC Module: folder holding VPC module
        * main.tf:
            * terraform file holding main configurations such as modules or resources
        * data.tf:
            * terraform file holding data source configurations
        * output.tf:
            * terraform file with output definitions
        * terraform.tf:
            * terraform file with terraform stanza configurations like required providers and versions
        * variables.tf:
            * terraform file with variable definitions
    * ASG Module: folder holding autoscale group module
        * templates: folder containing template files
            * user-data: user data template file used in launch template
        * main.tf:
            * terraform file holding main configurations such as modules or resources
        * data.tf:
            * terraform file holding data source configurations
        * output.tf:
            * terraform file with output definitions
        * terraform.tf:
            * terraform file with terraform stanza configurations like required providers and versions
        * variables.tf:
            * terraform file with variable definitions
    * LB Module: folder holding load balancer module
        * main.tf:
            * terraform file holding main configurations such as modules or resources
        * data.tf:
            * terraform file holding data source configurations
        * output.tf:
            * terraform file with output definitions
        * terraform.tf:
            * terraform file with terraform stanza configurations like required providers and versions
        * variables.tf:
            * terraform file with variable definitions
* main.tf:
    * terraform file holding main configurations such as modules or resources
* data.tf:
    * terraform file holding data source configurations
* output.tf:
    * terraform file with output definitions
* provider.tf:
    * terraform file with provider configurations
* terraform.tf:
    * terraform file with terraform stanza configurations like required providers and versions
* variables.tf:
    * terraform file with variable definitions

## CI/CD Workflow:
### Development workflow:
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