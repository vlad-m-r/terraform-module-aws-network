variable "vnet_cidr_block" {
  type = string
  description = "CIDR block for vnet."
}

variable "location" {
  type = string
  description = "The Azure location to operate in."
}

variable "resource_name_prefix" {
  type = string
  description = "A prefix to append to allow creates resources to."
}

variable "subnets" {
  type = map(any)
  description = "A map to create subnets. Refer to examples/main.tf for map structure."
}


variable "security_groups" {
  type = map(any)
  description = "A map to create security groups. Refer to examples/main.tf for map structure."
}