#!/bin/bash

# SET UP VARIABLES
. ./variables.sh

# CREATE ADMIN NODE

NODENAME=ses-poc-admin

echo "Creating VM $NODENAME"
az vm create \
--name $NODENAME \
--resource-group $RESOURCE_GROUP \
--admin-username $USERNAME \
--admin-password $PASSWORD \
--authentication-type password \
--size Standard_DS3_v2 \
--image SUSE:SLES-BYOS:12-SP3:2018.01.04 \
--nics $NODENAME-nic \
-l $LOCATION

# CREATE TEST NODES

for NODE in {1..2}
do
	NODENAME=ses-poc-test$NODE

	echo "Creating VM $NODENAME"
	az vm create --name $NODENAME \
	--resource-group $RESOURCE_GROUP \
	--admin-username $USERNAME \
	--admin-password $PASSWORD \
	--authentication-type password \
	--size Standard_D3_v2 \
	--image SUSE:SLES-BYOS:12-SP3:2018.01.04 \
	--nics $NODENAME-nic \
	-l $LOCATION
done

# CREATE OSD NODES

for NODE in {1..5}
do
	NODENAME=ses-poc-osd$NODE

	echo "Creating VM $NODENAME"
	az vm create --name $NODENAME \
	--resource-group $RESOURCE_GROUP \
	--admin-username $USERNAME \
	--admin-password $PASSWORD \
	--authentication-type password \
	--size Standard_D8s_v3 \
	--image SUSE:SLES-BYOS:12-SP3:2018.01.04 \
	--nics $NODENAME-nic \
	-l $LOCATION
done
