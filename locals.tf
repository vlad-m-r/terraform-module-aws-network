locals {
  subnet_security_group_associations = {

    # This monstrosity creates subnet to security associations map to dynamically create azurerm_subnet_network_security_group_association

    for association in flatten([
      for sg, sg_value in var.security_groups : [
        for subnet in sg_value.subnet_associations : {
          security_group = sg
          subnet         = subnet
        }
      ]
    ]) : "${association.security_group}_to_${association.subnet}" => association
  }

  network_security_group_rules = {
    for rule_object in flatten([
      for sg, sg_value in var.security_groups : [
        for rule in sg_value.inbound_rules : {
          security_group          = sg
          priority                = rule.priority
          direction               = rule.direction
          access                  = rule.access
          protocol                = rule.protocol
          source_port_ranges      = rule.source_port_ranges
          destination_port_ranges = rule.destination_port_ranges
          source_address_prefixes      = [for dest in rule.source_address_prefixes : dest == "VirtualNetwork" ? azurerm_virtual_network.main.address_space[0] : dest]
          destination_address_prefixes = [for dest in rule.destination_address_prefixes : dest == "VirtualNetwork" ? azurerm_virtual_network.main.address_space[0] : dest]
          description = rule.description
        }
      ]
    ]) : "${rule_object.security_group}_${rule_object.priority}" => rule_object
  }

}
