variable "admin_username" {
    type = string
    description = "Administrator user name for virtual machine"
}

variable "admin_password" {
    type = string
    description = "Password must meet Azure complexity requirements"
}

variable "prefix" {
    type = string
    default = "ses"
}

variable "location" {
    type = string
    default = "eastus"
}

variable "admin_vm_size" {
    type = string
    default = "Standard_DS3_v2"
}

variable "osd_vm_size" {
    type = string
    default = "Standard_DS5_v2"
}

variable "test_vm_size" {
    type = string
    default = "Standard_D3_v2"
}

variable "sles_reg_code" {
    type = string
}

variable "ses_reg_code" {
    type = string
}

variable "publisher" {
    type = string
    default = "SUSE"
}

variable "offer" {
    type = string
    default = "sles-15-sp1-byos"
}

variable "sku" {
    type = string
    default = "gen1"
}

variable "image_version" {
    type = string
    default = "latest"
}

variable "num_test" {
    type = number
    default = 1
}

variable "num_osd" {
    type = number
    default = 4
}

variable "num_disk" {
    type = number
    default = 4
}