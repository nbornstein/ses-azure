#!/bin/bash

for NODENAME in $( az vm list -o table | tail -n +3 | cut -f 1 -d ' ' )
do
	echo "Starting $NODENAME"
	az vm start --name $NODENAME --no-wait
done