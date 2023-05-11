# PowerShell
 $env:ARM_CLIENT_ID="b7e9854c-e883-4e09-9949-ca85fdf0cde0"
 $env:ARM_CLIENT_SECRET="isk8Q~TTdoTH0kPKoZ2os1GHAm-OJ1zOIZr~ja.W"
 $env:ARM_TENANT_ID="9b0e1a6b-c7e0-4bac-9cc2-550bde0c6568"
 $env:ARM_TENANT_ID="7acf4ccf-ed38-44ba-a75f-3c4b7b5b91e1"
 $env:TF_VAR_CLIENT_ID = "83159cb7-53c5-454b-8fb8-3dc0c66081ad"
 $env:TF_VAR_CLIENT_SECRET = ".hZ8Q~zIo4RaRmU2EEjP_KVAQdShpVOK-Q0qTb1G"
 $env:TF_VAR_TENANT_ID = "9b0e1a6b-c7e0-4bac-9cc2-550bde0c6568"
 $env:TF_VAR_SUBSCRIPTION_ID = "7acf4ccf-ed38-44ba-a75f-3c4b7b5b91e1"
  - name: Copy default index file to site
    win_copy:
      src: "{{ default_index_file }}"
      dest: "{{ globomantics_site_path}}\\index.html"


 provisioner "remote-exec" {
    connection {
      type = "winrm"
      user     = "${local.admin_username}"
      password = "${local.admin_password}"
      port     = 5986
      https    = true
      timeout  = "10m"
      host = azurerm_public_ip.example.ip_address        
      insecure = true
    }

    inline = [
      "powershell.exe New-Item -Path c:\\ -Name testfile1.txt -ItemType file -Value This is a text string."
    ]
  }

   connection {
    type     = "winrm"
    user     = " ta4naya.local\\anthony"
    password = "SecretPassword!"
    host     = azurerm_public_ip.sycor.id
    timeout  = "20s"
    https    = false
    use_ntlm = true
    insecure = true
  }

  provisioner "file" {
    source      = "start.ps1"
    destination = "d:/tf-scripts"
  }

  0


If you want to use WinRM to access Azure WM, we need to configure some things. For more details, please refer to here.

For example

Create a Key Vault
New-AzKeyVault -VaultName "<vault-name>" -ResourceGroupName "<rg-name>" -Location "<vault-location>" -EnabledForDeployment -EnabledForTemplateDeployment

Create a certificate
$certificateName = "somename"

$thumbprint = (New-SelfSignedCertificate -DnsName $certificateName -CertStoreLocation Cert:\CurrentUser\My -KeySpec KeyExchange).Thumbprint

$cert = (Get-ChildItem -Path cert:\CurrentUser\My\$thumbprint)

$password = Read-Host -Prompt "Please enter the certificate password." -AsSecureString

Export-PfxCertificate -Cert $cert -FilePath ".\$certificateName.pfx" -Password $password
upload certificate to Azure key vault
$fileName = "<Path to the .pfx file>"
$fileContentBytes = Get-Content $fileName -Encoding Byte
$fileContentEncoded = [System.Convert]::ToBase64String($fileContentBytes)

[System.Collections.HashTable]$TableForJSON = @{
    "data"     = $filecontentencoded;
    "dataType" = "pfx";
    "password" = "<password>";
}
[System.String]$JSONObject = $TableForJSON | ConvertTo-Json

$secret = ConvertTo-SecureString -String $jsonEncoded -AsPlainText –Force
Set-AzKeyVaultSecret -VaultName "<vault name>" -Name "<secret name>" -SecretValue $secret
Reference your self-signed certificates URL
"osProfile": {
      ...
      "secrets": [
        {
          "sourceVault": {
            "id": "<resource id of the Key Vault containing the secret>"
          },
          "vaultCertificates": [
            {
              "certificateUrl": "<URL for the certificate you got in Step 4>",
              "certificateStore": "<Name of the certificate store on the VM>"
            }
          ]
        }
      ],
      "windowsConfiguration": {
        ...
        "winRM": {
          "listeners": [
            {
              "protocol": "http"
            },
            {
              "protocol": "https",
              "certificateUrl": "[reference(resourceId(resourceGroup().name, 'Microsoft.KeyVault/vaults/secrets', '<vault-name>', '<secret-name>'), '2015-06-01').secretUriWithVersion]"
            }
          ]
        },
        ...
      }
    },
Connect to Azure VM to enable winRm service
Enable-PSRemoting -Force

 provisioner "remote-exec" {
    connection {
      type = "winrm"
      user     = " ta4naya.local\\anthony"
      password = "SecretPassword!"
      https    = false
      timeout  = "10m"
      host = azurerm_public_ip.sycor.ip_address       
      insecure = true
    }
    inline = [
      "powershell -File d:/tf-scripts/info.ps1"
    ]
    provisioner "local-exec" {
    command = <<EOT
       Install-WindowsFeature -Name Web-Server
   EOT
   interpreter = ["pwsh", "-Command"]
  }


resource "azurerm_virtual_machine_extension" "sy" {
  name                 = "sycor"
  virtual_machine_id   = azurerm_windows_virtual_machine.sycor.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"

  # CustomVMExtension Documetnation: https://docs.microsoft.com/en-us/azure/virtual-machines/extensions/custom-script-windows

  settings = <<SETTINGS
    {
        "fileUris": ["https://scripta4.blob.core.windows.net/script/winrm1.ps1"]
    }
   SETTINGS
  protected_settings = <<PROTECTED_SETTINGS
    {
      "commandToExecute": "powershell -ExecutionPolicy Unrestricted -File winrm1.ps1",
      "storageAccountName": "scripta4",
      "storageAccountKey": "1BdcfoBwuVrm1MZnrjzsGDEwI0kry8Ihq6QfnJ6uSZJiD7Nql7k+QMVtpNiVwbI4iyUt5lJeNJGK+AStcFwOqw=="
    }
  PROTECTED_SETTINGS
  depends_on = [azurerm_windows_virtual_machine.sycor]
}

 provisioner "remote-exec" {
    connection {
      type     = "winrm"
      user     = "anthony@ta4naya.local"
      password = "SecretPassword!"
      host = "${azurerm_public_ip.sycor.ip_address }"
      timeout  = "3m"
      https    = true
      port     = 5986
      use_ntlm = true
      insecure = true
    }

  inline = [
         "powershell -ExecutionPolicy Unrestricted -File C:\\ProgramData\\Amazon\\EC2-Windows\\Launch\\Scripts\\InitializeInstance.ps1 -Schedule"
        ]
      }
      connection {
      type = "winrm"
      user     = "adminuser"
      password = "Star123#"
      port     = 5986
      https    = true
      timeout  = "10m"
      host = azurerm_public_ip.sycor.ip_address        
      insecure = true
    }

 resource "null_resource" "image" {
  provisioner "local-exec" {
    command = <<EOT
    
         sleep 30;
	    >web.ini;
	    echo "[web]" | tee -a web.ini;
	    echo "${data.azurerm_public_ip.sycor.ip_address}"| tee -a web.ini;
        echo "[web:vars]" | tee -a web.ini;
        echo "ansible_user=adminuser" | tee -a web.ini;
        echo "ansible_password=Star123#" | tee -a web.ini;
        echo ansible_connection="winrm"|tee -a web.ini;
        echo "ansible_winrm_transport=basic"| tee -a web.ini;
        echo "ansible_winrm_server_cert_validation=ignore" | tee -a web.ini;
         export ANSIBLE_HOST_KEY_CHECKING=False;
	    ansible-playbook -i web.ini iis.yaml
        EOT
  }
     depends_on         = [azurerm_virtual_machine_extension.sy]
     
}


resource "azurerm_virtual_machine_extension" "sycorjoin" {
  name                 = "sycorjoin"
  virtual_machine_id   = azurerm_windows_virtual_machine.sycor.id
  publisher            = "Microsoft.Compute"
  type                 = "JsonADDomainExtension"
  type_handler_version = "1.3"

  # What the settings mean: https://docs.microsoft.com/en-us/windows/desktop/api/lmjoin/nf-lmjoin-netjoindomain

  settings           = <<SETTINGS
    {
        "Name": "ta4naya.local",
        "OUPath": "OU=Users,OU=IT,DC=ta4naya,DC=local",
        "User": "ta4naya.local\\anthony",
        "Restart": "true",
        "Options": "3"
    }
SETTINGS
  protected_settings = <<PROTECTED_SETTINGS
    {
      "Password": "SecretPassword!"
    }
  PROTECTED_SETTINGS
  depends_on         = [azurerm_windows_virtual_machine.sycor]
}
