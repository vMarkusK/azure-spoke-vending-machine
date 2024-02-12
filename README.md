# Azure Hub & Spoke - Spoke Vending Machine in Terraform

This Terraform specification is designed for a fast and resilient deployment of additional spokes to a Hub&Spoke architecture. The base Hub&Spoke architecture comes with an Azure Firewall, two spokes each both then including a Linux VM.

** This is an example and is not ready for production use **

## Design Decisions

- Azure Firewall and VMs are pinned to Availability Zone 1 (to test Latency)
- The default Route of the Spoke Subnets is set to Azure Firewall
- VNet Peering Route of the Spokes is set to Azure Firewall
- Single Subscription use (it is an Example)
- No High Availability (Storage, Compute, and Firewall in a single AZ)
- Boot Diagnostic to VMs is enabled
- VMs depend on Azure Firewall to ensure initial Update and package installation succeeds
- VMs use Cloud-Init to run `apt upgrade` and `apt install nginx` 

## How to add Spokes

The creation of Spokes is specified in a Module called "spokebuild". This Module includes:

- New VNet
- Subnets for the VNet
- Peering to Hub
- UDR including assignment

This is an example, of how to Call the Module:

```
module "spoke1network" {
    source              = "./modules/spokebuild"
    vnet_name           = var.spoke1_vnet_name
    resource_group_name = var.spoke1_rg_name
    location            = var.location
    address_space       = var.spoke1_address_space
    subnet_prefixes     = var.spoke1_subnet_prefixes
    subnet_names        = var.spoke1_subnet_names
    hub-resource_group_name = azurerm_resource_group.rg-hub.name
    hub-vnet_name           = azurerm_virtual_network.vnet-hub.name
    hub-vnet_id             = azurerm_virtual_network.vnet-hub.id
    afw-private-ip          = azurerm_firewall.afw.ip_configuration[0].private_ip_address
    hub-vnet_address_space  = tostring(var.vnet-hub-address_space[0])
    tags                    = var.tags
}

// Options Rule Collection Group for Spoke
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
      source_addresses      = [ var.full-address_space ]
      destination_addresses = [ module.linuxvmspoke1.vmnicip ]
      destination_ports     = ["80"]
    }
  }
}
```

Unique variables required for the Spoke:

```
// Spoke1
variable "spoke1_rg_name" {
  description = "spoke1 RG name"
  type        = string
  default     = "rg-spoke1-001"
}

variable "spoke1_vnet_name" {
  description = "spoke1 vnet name"
  type        = string
  default     = "vnet-spoke1-001"
}

variable "spoke1_address_space" {
  description = "spoke1 Address Space"
  type        = string
  default     = "10.100.0.0/16"
}

variable "spoke1_subnet_names" {
  description = "spoke1 Subnet Names"
  type        = list(string)
  default     = ["WebTier", "LogicTier", "DatabaseTier"]
}

variable "spoke1_subnet_prefixes" {
  description = "spoke1 Subnet prefixes"
  type        = list(string)
  default     = ["10.100.1.0/24", "10.100.2.0/24", "10.100.3.0/24"]
}
```

1. Copy "spoke1-vnet.tf" to "spoke[YourName]-vnet.tf"
2. Find and Replace "spoke1" in the Variable Names with "spoke[YourName]"
3. Add Unique variables required for the Spoke to the "variables.tf" and also Find and Replace "spoke1" in the Variable Names with "spoke[YourName]"
