#!/bin/bash

for NODE in {1..5}
do
	NODENAME=ses-poc-osd$NODE
	for DISK in {7..12} 
	do
		DISKNAME=$NODENAME-disk$DISK
		az vm disk detach --vm-name $NODENAME --name $DISKNAME 
	done
done

