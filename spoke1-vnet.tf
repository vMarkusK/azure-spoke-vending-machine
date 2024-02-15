module "spoke1network" {
  source                  = "./modules/spokebuild"
  vnet_name               = var.spoke1_vnet_name
  resource_group_name     = var.spoke1_rg_name
  location                = var.location
  address_space           = var.spoke1_address_space
  subnet_prefixes         = var.spoke1_subnet_prefixes
  subnet_names            = var.spoke1_subnet_names
  hub-resource_group_name = azurerm_resource_group.rg-hub.name
  hub-vnet_name           = azurerm_virtual_network.vnet-hub.name
  hub-vnet_id             = azurerm_virtual_network.vnet-hub.id
  afw-private-ip          = azurerm_firewall.afw.ip_configuration[0].private_ip_address
  hub-vnet_address_space  = tostring(var.vnet-hub-address_space[0])
  tags                    = var.tags
}

resource "azurerm_firewall_policy_rule_collection_group" "afw-policy-spoke1-rcg" {
  name               = "spoke1-rcg"
  firewall_policy_id = azurerm_firewall_policy.afw-policy.id
  priority           = 201

  network_rule_collection {
    name     = "spoke1-net-rc"
    priority = 100
    action   = "Allow"
    rule {
      name                  = "network_rule_allow_http_to_spoke1vm"
      protocols             = ["TCP"]
      source_addresses      = [var.full-address_space]
      destination_addresses = [module.linuxvmspoke1.vmnicip]
      destination_ports     = ["80"]
    }
  }
}