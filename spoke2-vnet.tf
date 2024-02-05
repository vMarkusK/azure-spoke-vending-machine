module "spoke2network" {
    source              = "./modules/spokebuild"
    vnet_name           = var.spoke2_vnet_name
    resource_group_name = var.spoke2_rg_name
    location            = var.location
    address_space       = var.spoke2_address_space
    subnet_prefixes     = var.spoke2_subnet_prefixes
    subnet_names        = var.spoke2_subnet_names
    hub-resource_group_name = azurerm_resource_group.rg-hub.name
    hub-vnet_name           = azurerm_virtual_network.vnet-hub.name
    hub-vnet_id             = azurerm_virtual_network.vnet-hub.id
    tags                    = var.tags
}