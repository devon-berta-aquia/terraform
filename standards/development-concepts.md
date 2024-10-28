# Development concepts for terraform code and management

## Introduction
When developing terraform to deploy infrastructure or components of infrastructure that maybe consumed by other terraform deployments it is important to consider how the resultant resources will be consumed and leveraged. The reasoning being to ensure if shared among many other terraform deployments or systems that the resultant resources remain stable and consistent with expectations set with the consumers. This means core infrastructure should be deployed in such a way it can be consumed similiar to version apis that provide a contract and consistent behavior for consumption. This is to ensure reliability of the shared components.
## Module Considerations:
* When deploying infrastructure such as VPCs, load balancers, s3 buckets or other shared resources please consider establishing tags that can be used to identify the resource or its security groups so these can be looked up and do not need to referred to directly by unique identifiers like ARN or UUIDs. This enables dependent modules to be aware of the resource via a friendly name that will remain constant throughout the lifecycle of the shared component.
* In dependent modules if possible lookup resource references via data sources rather then passing values between modules. There are times that resources are created outside of the existing terraform context that need to be consumed and this approach allows you to leverage the cloud or other data source provider as a source of truth for your modules data.
* Shared components provisioned in terraform establish behaviors and expectations with consumers this means that breaking changes may cause all dependent modules to require changes to work. To mitigate this adopting version and deploying new versions of shared resources that can be selected via tags allows for iterative adoption and transition to new infrastructure without impacting existing workflows that may have different migration schedules.
* For each module you can leverage a shared repository and sub folder structure if calling modules via folder path of cloned repos in ci/cd or via accessible github path in your parent modules. 
* If implementing a large number of stand alone base/shared modules then it may make more sense to implement seperate repositories by module for long term support. 
* Individual modules can be shared and hosted in a self hosted registry from a single repository with some clever automation but easier to implement automation for publishing to terraform registries from individual repositories.
* Modules hosted in a git repository as sub folder can be referenced using format found here: https://developer.hashicorp.com/terraform/language/modules/sources#modules-in-package-sub-directories
## naming and file structure considerations:
* Some common file and folder names used to break up components of terraform configurations include:
    * main.tf: stores the main logic and resources or modules being called in the terraform
    * provider.tf: stores the provider definitions
    * terraform.tf: stores required provider version configurations
    * locals.tf: stores locals definition configurations
    * variables.tf: stores variable definition configurations
    * data.tf: Stores data source configurations
    * templates: A folder used to store template files within a module or terraform configuration often accessed by module path or relative path in configurations
* Some common file names use to break up components of terraform input values include:
    * secrets.auto.tfvars: name format can be injected into .gitignores to automatically exclude during testing and validation
    * {env}.auto.tfvars: {env} reflects the environment the configuration is used for
    * config.tf: stores backend configuration data for state and other settings
* Some common use cases for environment variables when running terraform:
    * sensitive values such as provider credentials, keys, or passwords to be set by resources
    * Non sensitive provider configuration values such as region or other values that maybe derived by pipeline at runtime
