#!/bin/bash

# SET UP VARIABLES
. ./variables.sh

for NODE in {1..5}
do
	NODENAME=ses-poc-osd$NODE
	echo "Resizing $NODENAME"
	az vm resize --name $NODENAME --resource-group $RESOURCE_GROUP --size Standard_DS4_v2
done

