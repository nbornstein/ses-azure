#!/bin/bash

# SET UP VARIABLES
. ./variables.sh

NUM_OSD=$1
NUM_DISK=$2

for NODE in {1..5}
do
	NODENAME=$PREFIX-osd$NODE
	for DISK in {1..10} 
	do
		DISKNAME=$NODENAME-disk$DISK
		az vm disk detach -g $RESOURCE_GROUP --vm-name $NODENAME --name $DISKNAME 
	done
done

