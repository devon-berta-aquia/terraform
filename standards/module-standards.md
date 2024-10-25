# module standards - In Progress
Terraform modules can be leveraged to enable completion of various common infrastructure tasks to enable quick delivery. There should be some general guidelines followed to enable efficient consumption and reuse of modules. This document aims to share some standards to adopt in writing and using modules by presenting various concepts to consider when writing modules.

## Simplicity and purpose:
When writing terraform modules having a clear concise documented objective and requirements will enable you to develop quickly and ensure reusability. To enable this ensure you have the following information:
* what is the goal of the module?
* what resources are being deployed as part of the module?
* How do you intend the module to be used?
* what considerations do the providers require in order to successfully call the module?
* do you have an example situation the module can be used in and expected outcome?
* is the module creating too much or too little?
* am I exposing options that help the user consume the module or am I exposing too many options?
* is my module implementing best practices and security standards to make a secure by default resource?
* does the change of an input value cause a deletion of a resource and do I need to create a new one before I delete the current one?
When developing modules we often have an opinion formed that guides the features and options we implement. Public modules from cloud providers tend to implement all features through various flags and options but this can be both daunting and difficult to leverage at times. When writing your own modules consider the requirements and security best practices. Your aim should be to expose the minimal number of configuration options that allow for a secure and scalable components of infrastructure to be deployed.

## module types:
There are various intentions that modules can be created with below are some of the common intentions:
* base component:
    * Description: 
        * Deploy a group of resources in a specific configuration with the intention of being generic. Should be written to used standalone or in another module.
    * Things to avoid:
        * creating a wrapper around resources resource and exporting every large amounts of configuration values as variables
        * single resource modules, often additional dependent resources make sense to be grouped within the same modules
    * Things to do:
        * 
* utility:
    * Description: 
        * Implements a particular logic to manipulate data inputted into a specific format or structure for use in other modules or resources.
* resolver:
    * Description: 
        * Leverages one or more data source and locals to compute a return result that can be leverage by other modules or resources.
* abstractions:
    * Description: 
        * Brings one or more modules performing the same function in different contexts together with a standard in put configuration and translates the standard input to the modules input format.
* Deployment:
    * Description: 
        * Brings abstraction, resolver, utility, and/or base component modules together in a reusable module.
        * Purpose is to create a simplified input configuration that fits the model implemented in the module.
        * Used in CI/CD use cases with an input configuration file per environment being deployed.