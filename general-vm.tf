resource "azurerm_resource_group" "compute_rg" {
  name     = var.compute_rg_name
  location = var.location
}