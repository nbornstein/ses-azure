#!/bin/bash

# SET UP VARIABLES
. ./variables.sh

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
	--size Standard_D16s_v3 \
	--image SUSE:SLES-BYOS:12-SP3:2018.01.04 \
	--nics $NODENAME-nic \
	-l $LOCATION
done
