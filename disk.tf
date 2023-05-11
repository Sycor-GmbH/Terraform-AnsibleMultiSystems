resource "azurerm_managed_disk" "data_disk" {
  for_each = var.data_disks

  name                = "${each.key}_data_disk${each.value.count}"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location

  storage_account_type = each.value.data_disk_storage_account_type
  create_option        = each.value.data_disk_create_option
  disk_size_gb         = each.value.data_disk_size

}


resource "azurerm_virtual_machine_data_disk_attachment" "data_disk_attachment" {
  # Checks if the value of attach_to_vm is true and only then creates the attachment
  for_each = { for key, value in var.data_disks : key => value if value.attach_to_vm }

  managed_disk_id    = azurerm_managed_disk.data_disk[each.key].id
  virtual_machine_id = azurerm_windows_virtual_machine.vm[each.value.vm_name].id
  lun                = each.value.count
  caching            = each.value.data_disk_caching

  depends_on = [
    azurerm_windows_virtual_machine.vm,
    azurerm_managed_disk.data_disk

  ]
}

