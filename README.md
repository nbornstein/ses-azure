# ses-azure
Scripts to build and manage a SUSE Enterprise Storage cluster on Azure

## How to Use the Scripts
These are bash scripts, so obviously they need Linux or a bash shell on whatever platform you're using. The script names should be self-explanatory. They also require the Azure CLI to be installed, and a file named `variables.sh` in the same directory. 

## Specific Scripts
Name | Notes
---- | -----
`build_node.sh` | This is just a copy of https://github.com/dmbyte/SES-scripts/blob/master/clusterbuilder/buildit.sh.
`create_cluster.sh` | Create the cluster by running `create_nics.sh`, `create_vms.sh`, and `create_disks.sh`.
`create_disks.sh` | Create and attach disks ot all the OSD nodes. You need to specify how many OSD nodes and how many disks per node.
`create_nics.sh` | Create vNICs with accelerated networking for admin, test, and OSD VMs. You need to specify how many of each VM type.
`create_test_vms.sh` | Create VMs to be used as test clients for the cluster. You need to specify how many VMs to create.
`create_vms.sh` | Create admin, test, and OSD VMs. You need to specify how many of each VM type to create.
`detach_disks.sh` | Detach disks from all the OSD nodes. You need to specify how many OSD nodes and how disks per node.
`reattach_disks.sh` | Attach existing disks to all the OSD nodes. You need to specify how many OSD nodes and how disks per node.
`resize_vms.sh` | Resize the OSD VMs. You need to specify how many OSD nodes.
`setup node` | Not an actual script, but contains snippets that can be used to register and deploy code on the nodes once created.
`shutdown_vms.sh` | Shutdown all VMs in the specified resource group.
`startup_vms.sh` | Start up all VMs in the specified resource group.
`variables.sh` | See below for required contents.

### `Variables.sh` Content
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