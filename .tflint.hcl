plugin "terraform" {
  enabled = false
}

plugin "azurerm" {
  enabled = true
}

rule "azurerm_resource_missing_tags" {
  enabled = true
  tags = ["applicationname", "environment", "supportgroup"]
}