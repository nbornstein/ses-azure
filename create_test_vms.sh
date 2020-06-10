#!/bin/bash

# SET UP VARIABLES
. ./variables.sh

NUM_TEST=$1

# CREATE TEST NODES

for NODE in $(seq 1 $NUM_TEST)
do
	NODENAME=$PREFIX-test$NODE

	echo "Creating VM $NODENAME"
	az vm create --name $NODENAME \
	--resource-group $RESOURCE_GROUP \
	--admin-username $USERNAME \
	--admin-password $PASSWORD \
	--authentication-type password \
	--size Standard_D16s_v3 \
	--image $IMAGE \
	--nics $NODENAME-nic \
	-l $LOCATION
done
