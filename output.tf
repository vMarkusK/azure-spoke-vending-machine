output "vm_username" {
  value = var.vm_admin_user
}

output "spoke1_vm_private_ip" {
  value = module.linuxvmspoke1.vmnicip
}

output "spoke2_vm_private_ip" {
  value = module.linuxvmspoke2.vmnicip
}

output "firewall_public_dns_fqdn" {
  value = azurerm_public_ip.afw_pip.fqdn
}