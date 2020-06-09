#!/bin/bash

# SET UP VARIABLES
. ./variables.sh

NUM_OSD=$1
NUM_DISK=$2
PREFIX=$3

for NODE in $(seq 1 $NUM_OSD) 
do
	NODENAME=kennametal-osd$NODE

	for DISK in $(seq 1 $NUM_DISK)
	do
		DISKNAME=$NODENAME-disk$DISK
		echo "Creating disk $DISKNAME"
		az vm disk attach --vm-name $NODENAME \
		--resource-group $RESOURCE_GROUP \
		--name $DISKNAME --new --size-gb 4096 --sku Standard_LRS
	done
done

