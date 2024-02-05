resource "azurerm_resource_group" "rg-spoke" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

// VNet
resource "azurerm_virtual_network" "vnet-spoke" {
  name                = var.vnet_name
  location            = var.location
  address_space       = ["${var.address_space}"]
  resource_group_name = azurerm_resource_group.rg-spoke.name
  dns_servers         = var.dns_servers
  tags                = var.tags
}

// SubNets
resource "azurerm_subnet" "subnet-spoke" {
  name                 = var.subnet_names[count.index]
  virtual_network_name = azurerm_virtual_network.vnet-spoke.name
  resource_group_name  = azurerm_resource_group.rg-spoke.name
  address_prefixes     = ["${var.subnet_prefixes[count.index]}"]
  count                = length(var.subnet_names)
}

// Peering
resource "azurerm_virtual_network_peering" "hubspoke" {
  name                      = "hub-${var.vnet_name}"
  resource_group_name       = var.hub-resource_group_name
  virtual_network_name      = var.hub-vnet_name
  remote_virtual_network_id = azurerm_virtual_network.vnet-spoke.id
}

resource "azurerm_virtual_network_peering" "spokehub" {
  name                      = "${var.vnet_name}-hub"
  resource_group_name       = azurerm_resource_group.rg-spoke.name
  virtual_network_name      = azurerm_virtual_network.vnet-spoke.name
  remote_virtual_network_id = var.hub-vnet_id
  allow_forwarded_traffic   = true
}

