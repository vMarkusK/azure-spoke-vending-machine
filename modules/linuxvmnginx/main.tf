data "template_file" "cloudconfig_nginx" {
  template = "${file("${path.module}/${var.cloudconfig_file_nginx}")}"
}

data "template_cloudinit_config" "config_nginx" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = "${data.template_file.cloudconfig_nginx.rendered}"
  }
}

# Create network interface
resource "azurerm_network_interface" "spokevmnic" {
    name                      = "nic-${var.vmname}-${random_id.randomIdVM.hex}"
    location                  = var.location
    resource_group_name       = var.rgname

    ip_configuration {
        name                          = "${var.vmname}-ipconfig1"
        subnet_id                     = var.subnetid
        private_ip_address_allocation = "Dynamic"
    }

    tags                      = var.tags
}

# Generate random text for a unique storage account name and DNS label
resource "random_id" "randomId" {
    keepers = {
        # Generate a new ID only when a new resource group is defined
        resource_group = var.rgname
    }
    byte_length = 8
}
resource "random_id" "randomIdVM" {
    
        byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "spokestorageaccount" {
    name                        = "diag${random_id.randomId.hex}"
    resource_group_name         = var.rgname
    location                    = var.location
    account_tier                = "Standard"
    account_replication_type    = "LRS"
    min_tls_version             = "TLS1_2"
    tags                        = var.tags
}

# Create virtual machine
resource "azurerm_virtual_machine" "spokevm" {
    name                                = var.vmname
    location                            = var.location
    resource_group_name                 = var.rgname
    network_interface_ids               = [azurerm_network_interface.spokevmnic.id]
    vm_size                             = var.vmsize
    delete_os_disk_on_termination       = true
    delete_data_disks_on_termination    = true
    proximity_placement_group_id        = var.proximity_placement_group_id

    storage_os_disk {
        name              = "${var.vmname}-myOsDisk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }

    storage_image_reference {
        publisher = "canonical"
        offer     = "0001-com-ubuntu-server-jammy"
        sku       = "22_04-lts-gen2"
        version   = "latest"
    }

    os_profile {
        computer_name  = var.vmname
        admin_username = var.adminusername
        admin_password = var.vmpassword
        custom_data    = "${data.template_cloudinit_config.config_nginx.rendered}"
    }

    os_profile_linux_config {
        disable_password_authentication = false
    }

    boot_diagnostics {
        enabled = "true"
        storage_uri = azurerm_storage_account.spokestorageaccount.primary_blob_endpoint
    }

    tags = var.tags
}
