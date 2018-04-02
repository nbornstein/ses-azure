#!/bin/bash

# SET UP VARIABLES
. ./variables.sh

# NOTE: Starts all VMs in the resource group!

for NODENAME in $( az vm list -o table | tail -n +3 | cut -f 1 -d ' ' )
do
	echo "Starting $NODENAME"
	az vm start --name $NODENAME --resource-group $RESOURCE_GROUP --no-wait
done