
resource "azurerm_virtual_machine_extension" "sy" {
  for_each              = var.vm_instances
  name                  = each.key
  virtual_machine_id   = azurerm_windows_virtual_machine.vm[each.key].id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"

  # CustomVMExtension Documetnation: https://docs.microsoft.com/en-us/azure/virtual-machines/extensions/custom-script-windows

  settings           = <<SETTINGS
    {
        "fileUris": ["https://ta4naya.blob.core.windows.net/scripts/noDC.ps1"]
    }
   SETTINGS
 protected_settings = <<PROTECTED_SETTINGS
    {
      "commandToExecute": "powershell -ExecutionPolicy Unrestricted -File noDC.ps1",
      "storageAccountName": "ta4naya",
      "storageAccountKey": "u7IXu8Ar/8mplB3RJnmPFCGDX+rOF7zlnA4IlHlRzsenkBDffkvAm2aaXpZEBo+qk5dr0UeVitRi+AStWuBDCw=="
    }
  PROTECTED_SETTINGS
 depends_on         = [azurerm_windows_virtual_machine.vm]
}

