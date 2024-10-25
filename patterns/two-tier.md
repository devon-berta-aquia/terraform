# two tier - In Progress
## Introduction
This approach is best used when we have an established deployment that we need to repeat multiple times for different environments. Usually when the architecture has been solidified and we will be performing small iterative changes for future support. The code may start out as one large terraform and then be broken down into base component modules followed by abstraction or deployment modules depending on the need and goal. Deployments being for repeating the deployment of existing resources in a known configuration and abstractions for providing a means of standardizing a common component between different providers with a common input structure.
## Examples
### 1. Deployment - bucket, autoscale group, load balancer, vpc
* Objectives:
    * implement a standard set of base component modules for required resources
    * implement a single module that can be called to provision multiple environments in a consistent manner customized by a common input object
* Inputs:
    * object: deployment object with needed configuration to fill in all required fields to the module without having to repeat every variable in calling terraform
        * deployment-name: The base name applied as part of all resource naming for deployment
        * deployment-name-prefix: prefix applied as part of all resource naming for deployment
        * deployment-name-suffix: suffix applied as part of all resource naming for deployment
        * autoscale-max-instances: the maximum number of instances in autoscale group
        * autoscale-min-instances: the minimum number of instances in autoscale group
        * autoscale-image: the desired image to be used by the autoscale group
        * vpc-cidr-list: a list of available cidr ranges for vpc configuration across azs
        * vpc-desired-azs: a number of azs for cidrs to be spread across
        * load-balancer-frontend-ports: a list of ports to map through to autoscale group instances
        * load-balancer-frontend-public: boolean to determine if lb is publicly accessible
* Modules:
    * aws-object-store
    * aws-autoscale-group
    * aws-load-balancer
    * aws-networking
* Providers required:
    * aws: single provider being called for a particular region, module can be called multiple times with provider aliases to achieve multiple region deployments
#### terraform sequence diagram for deployment example
``` mermaid
sequenceDiagram


```
### 2. Abstractions - network
* Objectives:
    * We want to implement the creation of a common network layout in two cloud providers
    * We want a common set of inputs
    * The user consuming the module should require limited knowledge of the underlying modules being called
    * we want to implement this such that if an input is passed in that only contains information for one cloud provider then it still executes
* Inputs:
    * 
* Modules:
    * aws-networking: Creates a VPC and related resources in the desired region of AWS
    * gcp-networking: Creates a VPC and related resources in the desired region of GCP
* Providers required:
    * aws: one or more regional provider blocks for aws in the calling terraform file
    * google: one or more regional provider blocks for aws in the calling terraform file
#### terraform sequence diagram for abstractions example
``` mermaid
sequenceDiagram


```