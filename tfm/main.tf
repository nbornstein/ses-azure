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
  domain_name_label   = "${var.prefix}-admin"
}
resource "azurerm_public_ip" "publicip-osd" {
  count               = var.num_osd
  name                = "${var.prefix}-osd-${count.index}-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  domain_name_label   = "${var.prefix}-osd-${count.index}"
}
resource "azurerm_public_ip" "publicip-test" {
  count               = var.num_test
  name                = "${var.prefix}-test-${count.index}-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  domain_name_label   = "${var.prefix}-test-${count.index}"
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
resource "azurerm_network_interface" "nic-osd" {
  count                     = var.num_osd
  name                      = "${var.prefix}-osd-${count.index}-nic"
  location                  = var.location
  resource_group_name       = azurerm_resource_group.rg.name
  network_security_group_id = azurerm_network_security_group.nsg.id

  ip_configuration {
    name                          = "${var.prefix}-osd-${count.index}-ip"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip-osd[count.index].id
  }
}
resource "azurerm_network_interface" "nic-test" {
  count                     = var.num_test
  name                      = "${var.prefix}-test-${count.index}-nic"
  location                  = var.location
  resource_group_name       = azurerm_resource_group.rg.name
  network_security_group_id = azurerm_network_security_group.nsg.id

  ip_configuration {
    name                          = "${var.prefix}-test-${count.index}-ip"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip-test[count.index].id
  }
}

# Create the admin virtual machine
resource "azurerm_virtual_machine" "vm-admin" {
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
    publisher = var.publisher
    offer     = var.offer
    sku       = var.sku
    version   = var.image_version
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
      "sudo echo \"master: ${var.prefix}-admin\" >> /etc/salt/minion",
      "sudo systemctl enable salt-master",
      "sudo reboot"
    ]
  }
}

# Create the test virtual machines
resource "azurerm_virtual_machine" "vm-test" {
  count                 = var.num_test
  name                  = "${var.prefix}-test-${count.index}"
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic-test[count.index].id]
  vm_size               = var.test_vm_size

  storage_os_disk {
    name              = "${var.prefix}-test-${count.index}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = var.publisher
    offer     = var.offer
    sku       = var.sku
    version   = var.image_version
  }

  os_profile {
    computer_name  = "${var.prefix}-test-${count.index}"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      host     = azurerm_public_ip.publicip-test[count.index].ip_address
      user     = var.admin_username
      password = var.admin_password
    }

    inline = [
      "sudo SUSEConnect -r ${var.sles_reg_code}",
      "sudo zypper ref && sudo zypper up -y && sudo zypper in -y ceph-common",
      "sudo reboot"
    ]
  }
}

# Create the OSD storage disks
resource "azurerm_managed_disk" "disk-osd" {
  count                = var.num_osd * var.num_disk
  name                 = "${var.prefix}-osd-${floor(count.index / var.num_disk)}-disk-${floor(count.index % var.num_disk)}"
  location             = var.location
  resource_group_name  = azurerm_resource_group.rg.name
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = var.disk_size_gb
}

# Create the OSD storage node virtual machines
resource "azurerm_virtual_machine" "vm-osd" {
  count                 = var.num_osd
  name                  = "${var.prefix}-osd-${count.index}"
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic-osd[count.index].id]
  vm_size               = var.osd_vm_size

  storage_os_disk {
    name              = "${var.prefix}-osd-${count.index}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = var.publisher
    offer     = var.offer
    sku       = var.sku
    version   = var.image_version
  }

  os_profile {
    computer_name  = "${var.prefix}-osd-${count.index}"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      host     = azurerm_public_ip.publicip-osd[count.index].ip_address
      user     = var.admin_username
      password = var.admin_password
    }

    inline = [
      "sudo SUSEConnect -r ${var.sles_reg_code}",
      "sudo zypper ref && sudo zypper up -y && sudo zypper in -y salt-minion",
      "sudo echo \"master: ${var.prefix}-admin\" >> /etc/salt/minion",
      "sudo systemctl enable salt-minion",
      "sudo reboot"
    ]
  }
}

# Attach the OSD disk to the OSD VM
resource "azurerm_virtual_machine_data_disk_attachment" "datadisk" {
  count              = var.num_osd * var.num_disk
  managed_disk_id    = azurerm_managed_disk.disk-osd[floor(count.index % var.num_disk)].id
  virtual_machine_id = azurerm_virtual_machine.vm-osd[floor(count.index / var.num_disk)].id
  lun                = floor(count.index % var.num_disk)
  caching            = "ReadWrite"
}