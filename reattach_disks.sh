#!/bin/bash

# SET UP VARIABLES
. ./variables.sh

NUM_OSD=$1
NUM_DISK=$2

for NODE in $(seq 1 $NUM_OSD)
do
	NODENAME=ses-poc-osd$NODE

	for DISK in $(seq 1 $NUM_DISK)
	do
		DISKNAME=$NODENAME-disk$DISK
		echo "Creating disk $DISKNAME"
		az vm disk attach --resource-group $RESOURCE_GROUP --vm-name $NODENAME \
		--disk $DISKNAME 

	done
done

