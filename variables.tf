# specify customer and environment
variable "customer" {
    default = "mco"
}

variable "environment" {
    default = "plgtest"
}

# specify stack user
variable "user_name" {
    default = "paul.gomersbach"
}

# set password as 'export TF_VAR_password=<password>'
variable "password" {}

# generate your own key
variable "ssh_key_file" {
    default = "~/.ssh/id_rsa.terraform"
}

############### leave unchanged for naturalis openstack ###################
variable "tenant_name" {
    default = "zooi"
}

variable "auth_url" {
    default = "https://stack.naturalis.nl:5000/v2.0"
}

variable "region" {
    default = "RegionOne"
}

variable "external_gateway" {
    default = "8e314b96-ae2b-41ac-bed0-5944816f56d8"
}

variable "pool" {
    default = "external"
}

variable "image_deb" {
    default = "debian-7-amd64"
}

variable "image_ub" {
    default = "Ubuntu 14.04 LTS"
}

variable "flavor_mco" {
    default = "ha_localdisk.1c.1r.10h"
}

