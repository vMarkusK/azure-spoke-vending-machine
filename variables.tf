variable "location" {
  description = "Location for all resources"
  default     = "swedencentral"
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

variable "full-address_space" {
  description = "Full Adress Space of the Hub&Spoke Topo"
  default = "10.0.0.0/8" 
}

// Hub
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
  default     = ["AzureFirewallSubnet", "NetworkGatewaySubnet", "ApplicationGatewaySubnet"]
}

variable "hub-subnet_prefixes" {
  description = "Subnet Prefixes of the Hub VNet"
  default     = ["10.0.0.0/26", "10.0.0.64/26", "10.0.0.128/26"]
}

// Spoke1
variable "spoke1_rg_name" {
  description = "spoke1 RG name"
  default = "rg-spoke1-001"
}

variable "spoke1_vnet_name" {
  description = "spoke1 vnet name"
  default = "vnet-spoke1-001"
}

variable "spoke1_address_space" {
  description = "spoke1 Address Space"
  default = "10.100.0.0/16"
}

variable "spoke1_subnet_names" {
  description = "spoke1 Subnet Names"
  default = ["WebTier", "LogicTier", "DatabaseTier"]
}

variable "spoke1_subnet_prefixes" {
  description = "spoke1 Subnet prefixes"
  default = ["10.100.1.0/24", "10.100.2.0/24", "10.100.3.0/24"]
}

// Spoke2
variable "spoke2_rg_name" {
  description = "spoke2 RG name"
  default = "rg-spoke2-001"
}

variable "spoke2_vnet_name" {
  description = "spoke2 vnet name"
  default = "vnet-spoke2-001"
}

variable "spoke2_address_space" {
  description = "spoke2 Address Space"
  default = "10.101.0.0/16"
}

variable "spoke2_subnet_names" {
  description = "spoke2 Subnet Names"
  default = ["WebTier", "LogicTier", "DatabaseTier"]
}

variable "spoke2_subnet_prefixes" {
  description = "spoke2 Subnet prefixes"
  default = ["10.101.1.0/24", "10.101.2.0/24", "10.101.3.0/24"]
}

variable "compute_rg_name" {
  description = "Compute RG Name"
  default     = "rg-compute-001"
}

variable "cloudconfig_file_nginx" {
  description = "The location of the cloud init configuration file."
  default = "cloudconfig_nginx.tpl"
}

variable "vm_admin_user" {
  description = "Username for Virtual Machines"
  default     = "azureuser"
}
variable "vm_admin_pwd" {
  description = "Password for Virtual Machines"
}

variable "vm_size" {
  description = "Size of the VMs"
  default     = "Standard_B1s"
}

variable "spoke1_vm_hostname"{
  description = "Hostname of spoke1 VM"
  default     = "vm-spoke1-dev-001"
}


