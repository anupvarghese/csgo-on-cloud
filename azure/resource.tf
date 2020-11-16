provider "azurerm" {
  subscription_id = var.subscription_id
  client_id       = var.client_id
  tenant_id       = var.tenant_id
  version = "=2.0.0"
  features {}
}

data "template_file" "cloud_config" {
  template = file("../terraform/user_data.yml")
  vars = {
    gslt = var.gslt
    rcon_password = var.rcon_password
    sv_password = var.sv_password
  }
}


resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.region
}

resource "azurerm_virtual_network" "network" {
  name                = "staging-network"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = [var.vpc]
}

resource "azurerm_subnet" "subnet_two" {
  name                 = "subnet_two"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.network.name
  address_prefix       = var.subnet
}

resource "azurerm_public_ip" "cspip" {
  name                    = "cspip"
  location                = azurerm_resource_group.rg.location
  resource_group_name     = azurerm_resource_group.rg.name
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30

  tags = {
    environment = var.environment_tag
  }
}

resource "azurerm_network_interface" "csgonic" {
  name                = "csgo-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  enable_accelerated_networking = true # works only with certain

  ip_configuration {
    name                          = "NICConfiguration"
    subnet_id                     =  azurerm_subnet.subnet_two.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          =  azurerm_public_ip.cspip.id
  }
}

resource "azurerm_virtual_machine" "csserver" {
  name                  = "csgo-vm"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.csgonic.id]
  vm_size               = var.vm_size

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = var.storage_disk_type
  }
  os_profile {
    computer_name  = "terraformserver"
    admin_username = "csgoserver"
    admin_password = "PUTASECUREPASSWORDHEREPLEASEFORTHELOVEOFGOD123\\aa"
    custom_data    = base64encode(data.template_file.cloud_config.rendered)
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path = "/home/csgoserver/.ssh/authorized_keys"
      key_data = file(var.public_key_path)
    }
  }

  tags = {
    environment = var.environment_tag
  }
}

