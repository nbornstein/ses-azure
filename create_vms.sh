#!/bin/bash

NUM_OSD=$1
NUM_TEST=$2
PREFIX=$3

# SET UP VARIABLES
. ./variables.sh

# CREATE ADMIN NODE

NODENAME=$PREFIX-admin

echo "Creating VM $NODENAME"
az vm create \
--name $NODENAME \
--resource-group $RESOURCE_GROUP \
--admin-username $USERNAME \
--admin-password $PASSWORD \
--authentication-type password \
--size Standard_DS3_v2 \
--image $IMAGE \
--nics $NODENAME-nic \
-l $LOCATION

# CREATE TEST NODES

for NODE in $( seq 0 $(($NUM_TEST - 1)) ) 
do
	NODENAME=$PREFIX-test-$NODE

	echo "Creating VM $NODENAME"
	az vm create --name $NODENAME \
	--resource-group $RESOURCE_GROUP \
	--admin-username $USERNAME \
	--admin-password $PASSWORD \
	--authentication-type password \
	--size Standard_D3_v2 \
	--image $IMAGE \
	--nics $NODENAME-nic \
	-l $LOCATION
done

# CREATE OSD NODES

for NODE in $( seq 0 $(($NUM_OSD - 1)) ) 
do
	NODENAME=$PREFIX-osd-$NODE

	echo "Creating VM $NODENAME"
	az vm create --name $NODENAME \
	--resource-group $RESOURCE_GROUP \
	--admin-username $USERNAME \
	--admin-password $PASSWORD \
	--authentication-type password \
	--size Standard_DS5_v2 \
	--image $IMAGE \
	--nics $NODENAME-nic \
	-l $LOCATION
done
