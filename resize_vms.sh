#!/bin/bash

for NODE in {1..8}
do
	NODENAME=ses-poc-osd$NODE
	echo "Resizing $NODENAME"
	az vm resize --name $NODENAME --size Standard_DS4_v2
done

