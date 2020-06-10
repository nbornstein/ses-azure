#!/bin/bash

# SET UP VARIABLES
. ./variables.sh

NUM_OSD=$1

for NODE in $(seq 1 $NUM_OSD)
do
	NODENAME=$PREFIX-osd$NODE
	echo "Resizing $NODENAME"
	az vm resize --name $NODENAME --resource-group $RESOURCE_GROUP --size Standard_DS5_v2
done

