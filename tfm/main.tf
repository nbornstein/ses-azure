# Configure the Azure provider
provider "azurerm" {
    version = "~>1.32.0"
}

# Create a new resource group
resource "azurerm_resource_group" "rg" {
    name     = "${var.prefix}-resource-group"
    location = var.location
}

# Create a virtual network
resource "azurerm_virtual_network" "vnet" {
    name                = "${var.prefix}-vnet"
    address_space       = ["10.0.0.0/16"]
    location            = var.location
    resource_group_name = azurerm_resource_group.rg.name
}

# Create subnet
resource "azurerm_subnet" "subnet" {
  name                 = "${var.prefix}-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefix       = "10.0.0.0/24"
}

# Create public IPs
resource "azurerm_public_ip" "publicip-admin" {
  name                = "${var.prefix}-admin-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}
resource "azurerm_public_ip" "publicip-osd1" {
  name                = "${var.prefix}-osd1-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}
resource "azurerm_public_ip" "publicip-osd2" {
  name                = "${var.prefix}-osd2-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}
resource "azurerm_public_ip" "publicip-osd3" {
  name                = "${var.prefix}-osd3-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}
resource "azurerm_public_ip" "publicip-osd4" {
  name                = "${var.prefix}-osd4-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}
resource "azurerm_public_ip" "publicip-test1" {
  name                = "${var.prefix}-test1-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "nsg" {
  name                = "${var.prefix}-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "Dashboard"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "Ceph"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "6789"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Create network interfaces
resource "azurerm_network_interface" "nic-admin" {
  name                      = "${var.prefix}-admin-nic"
  location                  = var.location
  resource_group_name       = azurerm_resource_group.rg.name
  network_security_group_id = azurerm_network_security_group.nsg.id

  ip_configuration {
    name                          = "${var.prefix}-admin-ip"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip-admin.id
  }
}
resource "azurerm_network_interface" "nic-osd1" {
  name                      = "${var.prefix}-osd1-nic"
  location                  = var.location
  resource_group_name       = azurerm_resource_group.rg.name
  network_security_group_id = azurerm_network_security_group.nsg.id

  ip_configuration {
    name                          = "${var.prefix}-osd1-ip"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip-osd1.id
  }
}
resource "azurerm_network_interface" "nic-osd2" {
  name                      = "${var.prefix}-osd2-nic"
  location                  = var.location
  resource_group_name       = azurerm_resource_group.rg.name
  network_security_group_id = azurerm_network_security_group.nsg.id

  ip_configuration {
    name                          = "${var.prefix}-osd2-ip"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip-osd2.id
  }
}
resource "azurerm_network_interface" "nic-osd3" {
  name                      = "${var.prefix}-osd3-nic"
  location                  = var.location
  resource_group_name       = azurerm_resource_group.rg.name
  network_security_group_id = azurerm_network_security_group.nsg.id

  ip_configuration {
    name                          = "${var.prefix}-osd3-ip"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip-osd3.id
  }
}
resource "azurerm_network_interface" "nic-osd4" {
  name                      = "${var.prefix}-osd4-nic"
  location                  = var.location
  resource_group_name       = azurerm_resource_group.rg.name
  network_security_group_id = azurerm_network_security_group.nsg.id

  ip_configuration {
    name                          = "${var.prefix}-osd4-ip"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip-osd4.id
  }
}
resource "azurerm_network_interface" "nic-test1" {
  name                      = "${var.prefix}-test1-nic"
  location                  = var.location
  resource_group_name       = azurerm_resource_group.rg.name
  network_security_group_id = azurerm_network_security_group.nsg.id

  ip_configuration {
    name                          = "${var.prefix}-test1-ip"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip-test1.id
  }
}

# Create the admin virtual machine
resource "azurerm_virtual_machine" "vm" {
  name                  = "${var.prefix}-admin"
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic-admin.id]
  vm_size               = var.admin_vm_size

  storage_os_disk {
    name              = "${var.prefix}-admin-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "SUSE"
    offer     = "sles-15-sp1-byos"
    sku       = "gen1"
    version   = "latest"
  }

  os_profile {
    computer_name  = "${var.prefix}-admin"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      host     = azurerm_public_ip.publicip-admin.ip_address
      user     = var.admin_username
      password = var.admin_password
    }

    inline = [
      "sudo SUSEConnect -r ${var.sles_reg_code}",
      "sudo SUSEConnect -p ses/6/x86_64 -r ${var.ses_reg_code}",
      "sudo zypper ref && sudo zypper up -y && sudo zypper in -y salt-master",
      "sudo systemctl enable salt-master",
      "sudo reboot"
    ]
  }
}