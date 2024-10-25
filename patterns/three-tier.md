# three tier - In Progress
## Introduction
The three tier approach has a specific use case in mind that may not apply in most cases. This is primarily as you have more nested modules that means more resources are being provisioned which means greater blast radius of changes and dependencies to manage. The primary use case for three tier modules is specific deployments across multiple cloud providers or regions where abstraction modules have been implmented to provide consistent configuration. This might include setting up base networking in one more more regions consistently and peering them to enable traffic or deploying administrtive resources consistently across multiple regions. Another example maybe to cordinate updating of kubernetes deployments across multiple managed kubernetes instances on multiple cloud providers or regions.
## Examples
### 1. multi cloud networking
* Objectives:
    * 
* Inputs:
    * 
* Modules:
    * 
* Providers Required:
    * 
### 2. multi region kuberntes deployment
* Objectives:
    * 
* Inputs:
    * 
* Modules:
    * 
* Providers Required:
    * 
### 1. multi region administrtive control plane resources
* Objectives:
    * 
* Inputs:
    * 
* Modules:
    * 
* Providers Required:
    * 