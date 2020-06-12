#!/bin/bash

# SET UP VARIABLES
. ./variables.sh

# NOTE: Deallocates all VMs in the resource group!
IDS=$(az vm list --resource-group $RESOURCE_GROUP --query "[].id" -o tsv)

echo "Shutting down all VMs in $RESOURCE_GROUP"
echo $IDS
while true; do
    read -p "Do you wish to proceed? " yn
    case $yn in
        [Yy]* ) az vm deallocate --ids $IDS --no-wait; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
