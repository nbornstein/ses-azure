#!/bin/bash

# SET UP VARIABLES
. ./variable.sh

NUM_OSD=$1
NUM_DISK=$2

for NODE in {1..$NUM_OSD}
do
	NODENAME=ses-poc-osd$NODE
	for DISK in {1..$NUM_DISK} 
	do
		DISKNAME=$NODENAME-disk$DISK
		az vm disk detach -g $RESOURCE_GROUP --vm-name $NODENAME --name $DISKNAME 
	done
done

