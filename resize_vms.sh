#!/bin/bash

# SET UP VARIABLES
. ./variables.sh

NUM_OSD=$1

for NODE in {1..$NUM_OSD}
do
	NODENAME=ses-poc-osd$NODE
	echo "Resizing $NODENAME"
	az vm resize --name $NODENAME --resource-group $RESOURCE_GROUP --size Standard_DS5_v2
done

