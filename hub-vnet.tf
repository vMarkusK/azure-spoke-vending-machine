resource "azurerm_resource_group" "rg-hub" {
  name     = var.rg-hub-name
  location = var.location

  tags = var.tags
}

resource "azurerm_virtual_network" "vnet-hub" {
  name                = var.vnet-hub-name
  location            = azurerm_resource_group.rg-hub.location
  resource_group_name = azurerm_resource_group.rg-hub.name
  address_space       = var.vnet-hub-address_space

  tags = var.tags
}

resource "azurerm_subnet" "subnet-hub" {
  name                 = var.hub-subnet_names[count.index]
  virtual_network_name = azurerm_virtual_network.vnet-hub.name
  resource_group_name  = azurerm_resource_group.rg-hub.name
  address_prefixes     = [var.hub-subnet_prefixes[count.index]]
  count                = length(var.hub-subnet_names)
}