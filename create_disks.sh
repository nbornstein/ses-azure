#!/bin/bash

for NODE in {6..8}
do
	NODENAME=ses-poc-osd$NODE

	for DISK in {7..10}
	do
		DISKNAME=$NODENAME-disk$DISK
		echo "Creating disk $DISKNAME"
		az vm disk attach --vm-name $NODENAME \
		--resource-group $RESOURCE_GROUP \
		--disk $DISKNAME --new --size-gb 1023 --sku Standard_LRS
	done
done

