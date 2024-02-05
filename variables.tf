variable "location" {
  description = "Location for all resources"
  default     = "swedencentral"
}

variable "rg-hub-name" {
  description = "Name of the Hub RG"
  default     = "rg-net-hub-001"
}

variable "vnet-hub-name" {
  description = "Name of the Hub VNet"
  default     = "vnet-hub-001"
}

variable "vnet-hub-address_space" {
  description = "Address Space of the Hub VNet"
  default     = ["10.0.0.0/16"]
}

variable "hub-subnet_names" {
  description = "Subnet Names of the Hub VNet"
  default     = ["AzureFirewall", "NetworkGateway", "ApplicationGateway"]
}

variable "hub-subnet_prefixes" {
  description = "Subnet Prefixes of the Hub VNet"
  default     = ["10.0.0.32/27", "10.0.0.64/27", "10.0.0.96/27"]
}

variable "tags" {
  description = "The tags to associate with your network and subnets."
  type        = map(string)

  default = {
    applicationname   = "SpokeVendingMachine"
    env               = "Dev"
    supportgroup      = "Markus Kraus"
  }
}

