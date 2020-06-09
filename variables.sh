#/bin/sh

# Resource group for the cluster
export RESOURCE_GROUP=$PREFIX-resource-group

# Availability set for the cluster
export AVAILABILITY_SET=$PREFIX-availability-set

# Username to log in to the nodes
export USERNAME=sesadmin

# Password to log in to the nodes
export PASSWORD=SUSEstorage1234!

# TODO: Use SSH key to log in

# Network security group to use for all nodes
export NSG=$PREFIX-nsg

# Location for the nodes
export LOCATION=eastus

# Name of VNet
export VNET=$PREFIX-vnet

# Name of Subnet
export SUBNET=$PREFIX-subnet

# URN of Image
export IMAGE=suse:sles-15-sp1-byos:gen1:2020.05.06