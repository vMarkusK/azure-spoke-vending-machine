module "linuxvmspoke2" {
    source        = "./modules/linuxvmnginx"
    rgname        = azurerm_resource_group.compute_rg.name
    location      = var.location
    subnetid      = module.spoke2network.vnet_subnets[0]
    vmname        = var.spoke2_vm_hostname
    vmpassword    = var.vm_admin_pwd
    adminusername = var.vm_admin_user
    vmsize        = var.vm_size
    cloudconfig_file_nginx = var.cloudconfig_file_nginx
    tags = var.tags
    
    depends_on = [ azurerm_firewall.afw, azurerm_firewall_policy.afw-policy, azurerm_firewall_policy_rule_collection_group.afw-policy-default-rcg ]
}