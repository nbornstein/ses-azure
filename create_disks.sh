#!/bin/bash

NUM_OSD=$1
NUM_DISK=$2
PREFIX=$3

# SET UP VARIABLES
. ./variables.sh

for NODE in $( seq 0 $(($NUM_OSD - 1)) ) 
do
	NODENAME=$PREFIX-osd-$NODE

	for DISK in $( seq 0 $(($NUM_DISK - 1)) )
	do
		DISKNAME=$NODENAME-disk-$DISK
		echo "Creating disk $DISKNAME"
		az vm disk attach --vm-name $NODENAME \
		--resource-group $RESOURCE_GROUP \
		--name $DISKNAME --new --size-gb 4096 --sku Standard_LRS
	done
done

