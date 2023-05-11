variable "priority" {
  default = [100, 101, 102, 103]
}
variable "inbound_port_ranges" {
  default = [3389, 22, 5985, 5986]
}
variable "private_key" {
  default = "configServer_key.pem"
}

variable "uniq" {
  default = "!x[$0]++"
}
variable "ansible_connection" {
  type        = string
  description = "ansible server login"
  default     = "azureuser"
}
variable "ansible_host" {
  type        = string
  description = "ansible server login"
  default     = "52.142.208.86"
}

variable "vm_instances" {
  type = map(object({
    vm_size         = string
    os_disk_size_gb = number
    os_disk_type    = string
    os_disk_caching = string
    public_ip       = bool
    vnet_name       = string
    subnet_name     = string
    resource_group  = string
    image_publisher = string
    image_offer     = string
    image_sku       = string
    image_version   = string
  }))
}

variable "data_disks" {
  type = map(object({
    data_disk_storage_account_type = string
    data_disk_create_option        = string
    data_disk_size                 = number
    data_disk_encryption           = bool
    attach_to_vm                   = bool
    vm_name                        = string
    count                          = number
    data_disk_caching              = string
  }))
}

variable "admin_username" {
  type = map(string)
  sensitive = true
  
}

variable "admin_password" {
  type = map(string)
  sensitive = true
}