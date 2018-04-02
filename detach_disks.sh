#!/bin/bash

# SET UP VARIABLES
. ./variable.sh

for NODE in {1..5}
do
	NODENAME=ses-poc-osd$NODE
	for DISK in {1..10} 
	do
		DISKNAME=$NODENAME-disk$DISK
		az vm disk detach -g $RESOURCE_GROUP --vm-name $NODENAME --name $DISKNAME 
	done
done

