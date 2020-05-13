// Resource group

resource "azurerm_resource_group" "main" {
  name     = "${var.resource_name_prefix}rg"
  location = var.location
}

// VNET

resource "azurerm_virtual_network" "main" {
  name                = "${var.resource_name_prefix}vnet"
  address_space       = [var.vnet_cidr_block]
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
}

// ROUTE TABLE

resource "azurerm_route_table" "main" {
  name                          = "${var.resource_name_prefix}default-route-table"
  location                      = var.location
  resource_group_name           = azurerm_resource_group.main.name
  disable_bgp_route_propagation = false
}

// Subnets

resource azurerm_subnet main {
  for_each             = var.subnets
  name                 = format("%s%s-subnet", var.resource_name_prefix, each.value.name)
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefix       = each.value.address_prefix
}

resource azurerm_subnet_route_table_association main {
  for_each       = var.subnets
  route_table_id = azurerm_route_table.main.id
  subnet_id      = azurerm_subnet.main[each.key].id
}

// Security groups

resource "azurerm_network_security_group" "main" {
  for_each            = var.security_groups
  name                = format("%s%s-security-group", var.resource_name_prefix, each.value.name)
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet_network_security_group_association" "main" {
  for_each                  = local.subnet_security_group_associations
  network_security_group_id = azurerm_network_security_group.main[each.value.security_group].id
  subnet_id                 = azurerm_subnet.main[each.value.subnet].id
  depends_on                = [azurerm_network_security_group.main, azurerm_subnet.main]
}

resource "azurerm_network_security_rule" "main" {
  for_each                     = local.network_security_group_rules
  name                         = format("%s%s-security-rule", var.resource_name_prefix, each.key)
  priority                     = each.value.priority
  direction                    = each.value.direction
  access                       = each.value.access
  protocol                     = each.value.protocol
  source_port_ranges           = each.value.source_port_ranges
  destination_port_ranges      = each.value.destination_port_ranges
  source_address_prefixes      = each.value.source_address_prefixes
  destination_address_prefixes = each.value.destination_address_prefixes
  resource_group_name          = azurerm_resource_group.main.name
  network_security_group_name  = azurerm_network_security_group.main[each.value.security_group].name
  description                  = each.value.description
}