# ses-azure
Scripts to build a SUSE Enterprise Storage cluster on Azure

Requires a file named variables.sh with the following content:
```
#/bin/sh

# Resource group for the cluster
export RESOURCE_GROUP= 

# Availability set for the cluster
export AVAILABILITY_SET=

# Username to log in to the nodes
export USERNAME=

# Password to log in to the nodes
export PASSWORD=

# TODO: Use SSH key to log in

# Network security group to use for all nodes
export NSG=

# Location for the nodes
export LOCATION=

# Name of VNet
export VNET=

# Name of Subnet
export SUBNET=
```