provider "azurerm" {
  features {}
}

module "network" {
  source               = "../../"
  vnet_cidr_block      = "10.240.0.0/16"
  location             = "West US"
  resource_name_prefix = "example-module-"

  subnets = {
    subnet1_public = {
      name           = "subnet1_public",
      address_prefix = "10.240.0.0/24",
    },
    subnet2_private = {
      name           = "subnet2_private"
      address_prefix = "10.240.1.0/24"
    }
  }

  security_groups = {
    public = {
      name           = "public",
      inbound_rules  = [
        {
          priority = 100
          direction = "Inbound"
          access = "Allow"
          protocol = "*"
          source_port_ranges = ["0-65535"]
          destination_port_ranges = ["0-65535"]
          source_address_prefixes = ["VirtualNetwork"]
          destination_address_prefixes = ["VirtualNetwork"]
          description = "This rule allows inbound traffic between vnet resources"
        },
        {
          priority = 1000
          direction = "Inbound"
          access = "Allow"
          protocol = "tcp"
          source_port_ranges = ["0-65535"]
          destination_port_ranges = ["80", "443"]
          source_address_prefixes = ["0.0.0.0/0"]
          destination_address_prefixes = ["VirtualNetwork"]
          description = "The rule allows tcp port 80 and 443 access from public"
        },
        {
          priority = 1100
          direction = "Inbound"
          access = "Deny"
          protocol = "*"
          source_port_ranges = ["0-65535"]
          destination_port_ranges = ["0-65535"]
          source_address_prefixes = ["0.0.0.0/0"]
          destination_address_prefixes = ["0.0.0.0/0"]
          description = "Deny inbound access to everything else"
        }
      ]
      subnet_associations        = ["subnet1_public"]
    },
    private = {
      name           = "private",
      inbound_rules  = [
        {
          priority = 100
          direction = "Inbound"
          access = "Allow"
          protocol = "*"
          source_port_ranges = ["0-65535"]
          destination_port_ranges = ["0-65535"]
          source_address_prefixes = ["VirtualNetwork"]
          destination_address_prefixes = ["VirtualNetwork"]
          description = "This rule allows inbound traffic between vnet resources"
        },
        {
          priority = 1100
          direction = "Inbound"
          access = "Deny"
          protocol = "*"
          source_port_ranges = ["0-65535"]
          destination_port_ranges = ["0-65535"]
          source_address_prefixes = ["0.0.0.0/0"]
          destination_address_prefixes = ["0.0.0.0/0"]
          description = "Deny inbound access to everything else"
        }
      ]
      subnet_associations        = ["subnet2_private"]
    }
  }
}