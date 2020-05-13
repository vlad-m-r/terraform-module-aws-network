// OUTPUTS
output "azurerm_resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "subnets" {
  value = {
    for subnet in azurerm_subnet.main:
    subnet.name => subnet.id
  }
}

output "azurerm_route_table_default_name" {
  value = azurerm_route_table.main.name
}


output "azurerm_virtual_network_name" {
  value = azurerm_virtual_network.main.name
}
