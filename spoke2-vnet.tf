module "spoke2network" {
  source                  = "./modules/spokebuild"
  vnet_name               = var.spoke2_vnet_name
  resource_group_name     = var.spoke2_rg_name
  location                = var.location
  address_space           = var.spoke2_address_space
  subnet_prefixes         = var.spoke2_subnet_prefixes
  subnet_names            = var.spoke2_subnet_names
  hub-resource_group_name = azurerm_resource_group.rg_hub.name
  hub-vnet_name           = azurerm_virtual_network.vnet_hub.name
  hub-vnet_id             = azurerm_virtual_network.vnet_hub.id
  afw-private-ip          = azurerm_firewall.afw.ip_configuration[0].private_ip_address
  hub-vnet_address_space  = tostring(var.vnet_hub-address_space[0])
  tags                    = var.tags
}