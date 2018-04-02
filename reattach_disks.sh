#!/bin/bash

for NODE in {1..5}
do
	NODENAME=ses-poc-osd$NODE

	for DISK in {7..8}
	do
		DISKNAME=$NODENAME-disk$DISK
		echo "Creating disk $DISKNAME"
		az vm disk attach --vm-name $NODENAME \
		--disk $DISKNAME 

	done
done

