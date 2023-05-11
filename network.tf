# Create pip and nic

resource "azurerm_public_ip" "pip" {
  for_each = { for instance_name, instance in var.vm_instances : instance_name => instance if instance.public_ip }

  name                = "${each.key}-publicip"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "nic" {
  for_each = var.vm_instances
  name                = "${each.key}-nic"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "${each.key}-ipconfig"
    subnet_id                     = data.azurerm_subnet.subnet[each.key].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = each.value.public_ip ? azurerm_public_ip.pip[each.key].id : null
  }
}
