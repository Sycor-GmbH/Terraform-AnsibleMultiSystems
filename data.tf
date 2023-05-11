# get resource group

data "azurerm_resource_group" "rg" {
 name = "PR-DEV-An"
}

# get virtual network

data "azurerm_virtual_network" "vnet" {
  for_each = var.vm_instances

  name                = each.value.vnet_name
  resource_group_name = data.azurerm_resource_group.rg.name
}

# get subnet

data "azurerm_subnet" "subnet" {
  for_each = var.vm_instances

  name                 = each.value.subnet_name
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = data.azurerm_virtual_network.vnet[each.key].name

}
data "azurerm_public_ip" "pip" {
  for_each = var.vm_instances
  name = azurerm_public_ip.pip[each.key].name
  resource_group_name = data.azurerm_resource_group.rg.name
  depends_on =[azurerm_windows_virtual_machine.vm]
}