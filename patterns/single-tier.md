# Single Tier
## Introduction
This approach is best used when starting out to test and validate individual modules or trying to create base modules that can be combined later. Your goal should be to implement a component of infrastructure in a secure by default configuration with minimal inputs required to achieve the desired configuration. The scope should be limited and be able to be slotted into other modules for specific deployments later.

## Examples
### 1. S3 Buckets
* Objectives:
    * Create S3 bucket that is secured and accessible in a given region as defined by configuration.
    * The bucket should be not be publicly accessible unless specifically required and should be tagged with appropriate labels that it can be referenced by other automation.
* Inputs:
    * Region: Where the bucket needs to be deployed
    * Publicly accessible: Boolean to determine if public access is allowed or not
    * name: A friendly name used to identify the bucket
    * name prefix: a prefix appended to the name on creation
    * name suffix: a suffix appended to the name on creation
    * allowed tags: a list of tags on security groups allowed to access the bucket
    * bucket tags: a list of tags to apply to the bucket and resources within the module
* Resources:
    * security group: creates security groups
    * s3 bucket
    * access policy
* data sources:
    * security groups by tag: Looks up security groups by tag to iterate through updating and allowing access to the bucket
::: mermaid
sequenceDiagram
terraform apply ->> terraform: runing apply command

inputs ->> terraform: terraform ingests inputs to calculate and compare with state

terraform ->> data source - security groups: terraform looks up security groups by tag via data source

terraform ->> security groups: terraform checks for state of security groups and calculates changes

terraform ->> access policy: terraform  checks for state of access policy and calculates access policy changes

data source - security groups ->> access policy: data source value inputed to security groups

terraform ->> s3 bucket:  terraform checks for state of s3 bucket and calculates s3 bucket changes

security groups ->> plan: result of security group resource stored in plan

access policy ->> plan: result of access policy stored in plan

access policy ->> s3 bucket: access policy value inputed to s3 bucket resource

s3 bucket ->> plan: result of s3 bucket stored in plan

plan ->> approve: plan is approved

approve ->> apply: apply starts

security groups ->> provision order 1: security group created in aws

access policy ->> provision order 1: access policy created in aws

provision order 1 ->> terraform state: Updated with resource state

provision order 1 ->> s3 bucket: after access policy created s3 bucket provisioning started

s3 bucket ->> provision order 2: s3 bucket created in aws

provision order 2 ->> terraform state: Updated with resource state

terraform state ->> terraform: provisioning complete
:::
### 2. EC2 Instances

### 3. load balancer

### 4. VPCs

