resource "azurerm_public_ip" "afw-pip" {
  name                = "afw-pip"
  resource_group_name = azurerm_resource_group.rg-hub.name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "afw" {
  name                  = "afw"
  resource_group_name   = azurerm_resource_group.rg-hub.name
  location              = var.location
  sku_name              = "AZFW_VNet"
  sku_tier              = "Standard"
  dns_proxy_enabled     = true
  firewall_policy_id    = azurerm_firewall_policy.afw-policy.id
  threat_intel_mode     = "Alert"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.subnet-hub.id
    public_ip_address_id = azurerm_public_ip.afw-pip.id
  }
}

resource "azurerm_firewall_policy" "afw-policy" {
  name                = "afw-policy"
  resource_group_name = azurerm_resource_group.rg-hub.name
  location            = var.location
}

resource "azurerm_firewall_policy_rule_collection_group" "afw-policy-rcg" {
  name               = "default-rcg"
  firewall_policy_id = azurerm_firewall_policy.afw-policy.name
  priority           = 200
  application_rule_collection {
    name     = "default-app-rc"
    priority = 200
    action   = "Allow"
    rule {
      name = "app_rule_allow_ubuntu_http"
      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses  = [var.full-address_space]
      destination_fqdns = ["*.ubuntu.com"]
    }
  }

  network_rule_collection {
    name     = "default-net-rc"
    priority = 100
    action   = "Allow"
    rule {
      name                  = "network_rule_allow_icmp"
      protocols             = ["ICMP"]
      source_addresses      = [var.full-address_space]
      destination_addresses = [var.full-address_space]
      destination_ports     = ["*"]
    }
  }
}