resource "null_resource" "prepare_ini" {
  for_each              = var.vm_instances
  
    
 connection {
    private_key = "${file(var.private_key)}"
    user        = var.ansible_connection
    host      = var.ansible_host

  }
     provisioner "remote-exec" {
       inline = [
       "sleep 30s",
	     ">web.ini",
	     "echo [web] | tee -a web.ini",
       "echo ${data.azurerm_public_ip.pip[each.key].ip_address} | tee -a web.ini",
       "echo [web:vars] | tee -a web.ini",
       "echo ansible_user=${lookup(var.admin_username, each.key, null)} | tee -a web.ini",
       "echo ansible_password=${lookup(var.admin_password, each.key, null)} | tee -a web.ini"
	     
       ]
  }
     depends_on         = [azurerm_virtual_machine_extension.sy]
     
}

resource "null_resource" "install" {
                
    
 connection {
    private_key = "${file(var.private_key)}"
    user        = var.ansible_connection
    host      = var.ansible_host
  }
     provisioner "remote-exec" {
       inline = [
       "sleep 30s",
       "echo ansible_connection=winrm|tee -a web.ini",
       "echo ansible_winrm_transport=basic| tee -a web.ini",
       "echo ansible_winrm_server_cert_validation=ignore | tee -a web.ini",
       "export ANSIBLE_HOST_KEY_CHECKING=False",
       "awk '${var.uniq}' web.ini >hosts.ini",
	     "ansible-playbook -i hosts.ini mycheckwin.yaml"
       ]
  }
     depends_on         = [null_resource.prepare_ini]
     
}