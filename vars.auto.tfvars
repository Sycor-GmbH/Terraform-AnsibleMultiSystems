vm_instances = {
  "firstVM" = {
    count           = 1
    os_disk_size_gb = 128
    os_disk_type    = "StandardSSD_LRS"
    os_disk_caching = "ReadWrite"
    nsg_name        = "value"
    public_ip       = true
    resource_group  = "PR-DEV-An"
    subnet_name     = "default"
    vnet_name       = "vnet-anigb"
    vm_size         = "Standard_D2lds_v5"
    image_publisher = "MicrosoftWindowsServer"
    image_offer     = "WindowsServer"
    image_sku       = "2022-datacenter"
    image_version   = "latest"
  },
  "secondVM" = {
    count              = 1
    customer_extension = "value"
    os_disk_size_gb    = 128
    os_disk_type       = "StandardSSD_LRS"
    os_disk_caching    = "ReadWrite"
    nsg_name           = "value"
    public_ip          = true
    resource_group     = "PR-DEV-An"
    subnet_name        = "default"
    vnet_name          = "vnet-anigb"
    vm_size            = "Standard_D2lds_v5"
    image_publisher    = "MicrosoftWindowsServer"
    image_offer        = "WindowsServer"
    image_sku          = "2022-datacenter"
    image_version      = "latest"
  }
}

data_disks = {
  "vm1_datadisk" = {
    attach_to_vm                    = true
    data_disk_create_option         = "Empty"
    data_disk_encryption            = false
    data_disk_size                  = 128
    data_disk_storage_account_type  = "Standard_LRS"
    vm_name                         = "firstVM"
    count                           = 0
    data_disk_caching               = "ReadWrite"
    data_disk_public_network_access = "AllowPrivate"
  },
  "vm1_datadisk2" = {
    attach_to_vm                    = true
    data_disk_create_option         = "Empty"
    data_disk_encryption            = false
    data_disk_size                  = 128
    data_disk_storage_account_type  = "Standard_LRS"
    vm_name                         = "firstVM"
    count                           = 1
    data_disk_caching               = "ReadWrite"
    data_disk_public_network_access = "AllowPrivate"
  },
  "vm2_datadisk" = {
    attach_to_vm                    = false
    data_disk_create_option         = "Empty"
    data_disk_encryption            = false
    data_disk_size                  = 128
    data_disk_storage_account_type  = "Standard_LRS"
    vm_name                         = "secondVM"
    count                           = 0
    data_disk_caching               = "ReadWrite"
    data_disk_public_network_access = "AllowPrivate"
  },

}

admin_password = {
  "firstVM" = "SuperSecretPassword1",
  "secondVM" = "SuperSecretPassword1"
}

admin_username = {
  "firstVM" = "adminUsername",
  "secondVM" = "adminUsername"
}