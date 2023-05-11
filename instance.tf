# create virtual machine

resource "azurerm_windows_virtual_machine" "vm" {
  for_each              = var.vm_instances
  name                  = each.key
  location              = data.azurerm_resource_group.rg.location
  resource_group_name   = data.azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic[each.key].id]

  computer_name  = each.key
  admin_username = lookup(var.admin_username, each.key, null)
  admin_password = lookup(var.admin_password, each.key, null)

  size = each.value.vm_size

  source_image_reference {
    publisher = each.value.image_publisher
    offer     = each.value.image_offer
    sku       = each.value.image_sku
    version   = each.value.image_version
  }

  os_disk {
    storage_account_type = each.value.os_disk_type
    disk_size_gb         = each.value.os_disk_size_gb
    caching              = each.value.os_disk_caching
  }
  
}
