# WIP...

## Azure Network Terraformo module

Terraform module which sets up VNet resources on Azure.

Intended to be used to roll out network resources from scratch. 

The following module will create:

* resource group
* vnet
* route table
* dynamically create subnets and associate to the route table
* dynamically creates security groups and associates with corresponding subnets
* dynamically creates network security group rules and assigns to proper security groups

## Usage

Refer to  [examples/main.tf](../master/examples/main.tf) for examples