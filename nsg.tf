resource "azurerm_network_security_group" "sycor" {
  name = "sycor"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  tags = {
    environment = "Production"
  }
}

resource "azurerm_network_security_rule" "sycor" {
  count                       = length(var.inbound_port_ranges)
  name                        = "sg-rule-${count.index}"
  direction                   = "Inbound"
  access                      = "Allow"
  priority                    = 100 * (count.index + 1)
  source_address_prefix       = "*"
  source_port_range           = "*"
  destination_address_prefix  = "*"
  destination_port_range      = element(var.inbound_port_ranges, count.index)
  protocol                    = "Tcp"
  network_security_group_name = azurerm_network_security_group.sycor.name
  resource_group_name         = data.azurerm_resource_group.rg.name
}
resource "azurerm_network_interface_security_group_association" "sycor" {
  for_each              = var.vm_instances
  
  network_interface_id      = azurerm_network_interface.nic[each.key].id
  network_security_group_id = azurerm_network_security_group.sycor.id

}