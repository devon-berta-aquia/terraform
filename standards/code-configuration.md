# code and configuration standards - In Progress

## Definitions:
* Code: TF files written in HCL or JSON that implement the logic and resource definitions required to implement the required infrastructure or component settings
* Configuration: TFVARS files written in HCL or JSON that implement the required input values for the code
* Module: A folder of TF files written with the purpose of being reused to provision a set of resources in a specific structure that aligns with a set of compliance or implementation standards. Must be reusable and provide a standard generic set of inputs that will deliver a secure by default implementation of the desired resources

## Introduction
In terraform there are multiple approaches to handling configuration and code we will explore some of them here:
### Code and configuration single repository:
This approach involves placing configurations and code in a single repository typically on a main branch that is branched to feature branches. Testing occurs in lower or dedicated development environments first before being merged back to main.
* pros:
    * Works well for simple terraform not leveragin modules
    * allow for very specific but potentially duplicative terraform to be created
    * ships easily as one repository is required to complete a plan and apply
* cons:
    * versioning code becomes difficult as configuration and code are coupled with multiple versions of configuration stored along side multiple versions of code
    * reuse typically involves extensive copy and paste operations to reproduce same configurations in another repository with extensive find and replace work to update items such as name fields and resource names for new use cases
    * Often leads to complex or difficult to read terraform implementations as resource count grows over time maybe spread among many files which creates readability challenges when reviewing implicit resource dependencies
    * Must update input configurations at time of code changes in order to ensure compatibility and maintain existing environments. If not done then existing environments may not be able to be changed in situations required quick response which because the configurations are not consistent with required inputs.
### Code and configuration seperate repositories:
This approach involves placing configurations and code in seperate repositories. Development of code changes is branched from main and tested in dev or lower environments before being merged to main. Consuming code should be done through versioned releases of code that are targetted via input configurations. Changes to schema for configuration inputs must be updated in configuration files along with desired version of code to be used in deployment.
* Pros:
    * Code is version and there is finite control over which version of code is being executed againist
    * Configuration is seperate from code meaning there are fewer issues attempting to maintain the correct input configuration.
    * Existing environments can be updated iteratively instead of being forced to update configuration and code changes at the same time. Leads to better control over release and rollout of changes.
* Cons:
    * Introduces some oppertunity for existing deployment configurations to fall behind but will still be able to be run with current versions
### Code, configuration and modules seperate repositories:

* Pros:
    * 
* Cons:
    * 
