#!/bin/bash

# SET UP VARIABLES
. ./variables.sh

NUM_OSD=$1
NUM_DISK=$2

for NODE in {1..5}
do
	NODENAME=ses-poc-osd$NODE
	for DISK in {1..10} 
	do
		DISKNAME=$NODENAME-disk$DISK
		az disk delete --resource-group $RESOURCE_GROUP --name $DISKNAME --no-wait --yes
	done
done

