#!/bin/bash

for NODENAME in $( az vm list -o table | tail -n +3 | cut -f 1 -d ' ' )
do
	echo "Deallocating $NODENAME"
	az vm deallocate --name $NODENAME --no-wait
done