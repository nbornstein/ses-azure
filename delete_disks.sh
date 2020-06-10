#!/bin/bash

# SET UP VARIABLES
. ./variables.sh

NUM_OSD=$1
NUM_DISK=$2

for NODE in $(seq 1 $NUM_OSD)
do
	NODENAME=$PREFIX-osd$NODE
	for DISK in $(seq 1 $NUM_DISK) 
	do
		DISKNAME=$NODENAME-disk$DISK
		az disk delete --resource-group $RESOURCE_GROUP --name $DISKNAME --no-wait --yes
	done
done

