#!/bin/bash

# SET UP VARIABLES
. ./variables.sh

NUM_OSD=$1
NUM_TEST=$2
PREFIX=$3

# CREATE VNET

echo "Creating vnet for $PREFIX"
az network vnet create \
--address-prefixes 10.0.0.0/24 \
--name $VNET \
--resource-group $RESOURCE_GROUP

# CREATE SUBNET

echo "Creating subnet for $PREFIX"
az network vnet subnet create \
--address-prefixes 10.0.0.0/24 \
--name $SUBNET \
--resource-group $RESOURCE_GROUP \
--vnet-name $VNET

# CREATE ADMIN NODE

NODENAME=$PREFIX-admin

echo "Creating NIC for $NODENAME"
az network public-ip create \
--name $NODENAME-public-ip \
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

# CREATE TEST NODES

for NODE in $(seq 1 $NUM_TEST) 
do
	NODENAME=$PREFIX-test$NODE

    az network public-ip create \
    --name $NODENAME-public-ip \
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

# CREATE OSD NODES

for NODE in $(seq 1 $NUM_OSD) 
do
	NODENAME=$PREFIX-osd$NODE

    az network public-ip create \
    --name $NODENAME-public-ip \
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

