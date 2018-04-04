#!/bin/bash

# SET UP VARIABLES
. ./variables.sh

# NOTE: Deallocates all VMs in the resource group!

for NODENAME in $( az vm list -o table | tail -n +3 | cut -f 1 -d ' ' )
do
	echo "Deleting $NODENAME"
	az vm delete --name $NODENAME --resource-group $RESOURCE_GROUP --no-wait --yes
done