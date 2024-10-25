# Single Tier - In Progress
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
#### Terraform execution sequence for S3 Buckets
``` mermaid
sequenceDiagram
terraform apply command ->> terraform: 1. runing apply command

inputs ->> terraform: 2. terraform ingests inputs to calculate and compare with state

terraform ->> data source - security groups: 3a. terraform looks up security groups by tag via data source

terraform ->> security groups: 3b. terraform checks for state of security groups and calculates changes

terraform ->> access policy: 3c. terraform  checks for state of access policy and calculates access policy changes

data source - security groups ->> access policy: 4a. data source value inputed to security groups

terraform ->> s3 bucket:  3d. terraform checks for state of s3 bucket and calculates s3 bucket changes

security groups ->> plan: 4b. result of security group resource stored in plan

access policy ->> plan: 5. result of access policy stored in plan

access policy ->> s3 bucket: 6. access policy value inputed to s3 bucket resource

s3 bucket ->> plan: 7. result of s3 bucket stored in plan

plan ->> approve: 8. plan is approved

approve ->> apply: 9. apply starts

security groups ->> provision order 1: 10a. security group created in aws

access policy ->> provision order 1: 10b. access policy created in aws

provision order 1 ->> terraform state: 11. Updated with resource state

provision order 1 ->> s3 bucket: 12. after access policy created s3 bucket provisioning started

s3 bucket ->> provision order 2: 13. s3 bucket created in aws

provision order 2 ->> terraform state: 14. Updated with resource state

terraform state ->> terraform: 15. provisioning complete

terraform ->> terraform apply command: 16. command returns
```
### 2. EC2 Instances
* Objectives:
    * Create ec2 instance that is secured and accessible in a given region as defined by configuration.
    * The ec2 instance should be not be publicly accessible unless specifically required and should be tagged with appropriate labels that it can be referenced by other automation.
* Inputs:
    * Region: Where the bucket needs to be deployed
    * Publicly accessible: Boolean to determine if public access is allowed or not
    * name: A friendly name used to identify the bucket
    * name prefix: a prefix appended to the name on creation
    * name suffix: a suffix appended to the name on creation
    * network tag: tag for the desired network to deploy the instance in
    * allowed tags: a list of tags on security groups allowed to access the bucket
    * bucket tags: a list of tags to apply to the bucket and resources within the module
    * size: a size type for the instance to determine cpu and memory
    * storage: a list of objects to be iterated through for allocated storage types
        * type: A string representing file, block, temp or other storage type
        * size: quantity of space allocated in gigabytes
        * iops type: a string of high or low
        * throughput: a string type of high or low
    * user data template file: path to user data template file to be rendered and submitted with ec2 instance resource
* Resources:
    * security group: creates security groups
    * ec2 instance
    * instance launch template
    * ebs volume
    * instance store
    * dns record
* data sources:
    * security groups by tag: Looks up security groups by tag to iterate through updating and allowing access to the bucket
    * network groups by tag: Looks up network by tag to find network in correct vpc to deploy into
#### Terraform execution sequence for EC2 Instance
tbd

### 3. load balancer
* Objectives:
    * 
* Inputs:
    * 
* Resources:
    * 
* data sources:
    * 
#### Terraform execution sequence for Load Balancer
tbd
### 4. VPCs

* Objectives:
    * 
* Inputs:
    * 
* Resources:
    * 
* data sources:
    * 
#### Terraform execution sequence for VPC
tbd