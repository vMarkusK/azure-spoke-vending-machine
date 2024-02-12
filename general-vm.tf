resource "azurerm_resource_group" "compute_rg" {
  name     = var.compute_rg_name
  location = var.location
}

resource "azurerm_proximity_placement_group" "placement_group_az1" {
  name                = "ProximityPlacementGroupAz1"
  location            = var.location
  resource_group_name = azurerm_resource_group.compute_rg.name
  zone                = 1
  allowed_vm_sizes    = [ var.vm_size ]
  tags                = var.tags
}