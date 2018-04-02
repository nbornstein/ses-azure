#!/bin/bash

# SET UP VARIABLES
. ./variables.sh

# CREATE ADMIN NODE

NODENAME=ses-poc-admin

echo "Creating NIC for $NODENAME"
az network public-ip create 
--resource-group $RESOURCE_GROUP \
--allocation-method Dynamic \
--dns-name $NODENAME-public-ip

az network nic create 
--resource-group $RESOURCE_GROUP \
--vnet-name $VNET \
--subnet $SUBNET \
-n $NODENAME-nic \
--accelerated-networking true \
--public-ip $NODENAME-public-ip \
-l $LOCATION

# CREATE TEST NODES

for NODE in {1..2}
do
	NODENAME=ses-poc-test$NODE

    az network public-ip create \
    --resource-group $RESOURCE_GROUP \
    --allocation-method Dynamic \
    --dns-name $NODENAME-public-ip

    az network nic create 
    --resource-group $RESOURCE_GROUP \
    --vnet-name $VNET \
    --subnet $SUBNET \
    -n $NODENAME-nic \
    --accelerated-networking true \
    --public-ip $NODENAME-public-ip \
    -l $LOCATION

done

# CREATE OSD NODES

for NODE in {1..5}
do
	NODENAME=ses-poc-osd$NODE

    az network public-ip create \
    --resource-group $RESOURCE_GROUP \
    --allocation-method Dynamic \
    --dns-name $NODENAME-public-ip
    
    az network nic create \
    --resource-group $RESOURCE_GROUP \
    --vnet-name $VNET \
    --subnet $SUBNET \
    -n $NODENAME-nic \
    --accelerated-networking true \
    --public-ip $NODENAME-public-ip \
    -l $LOCATION

done

