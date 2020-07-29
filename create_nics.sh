#!/bin/bash

NUM_OSD=$1
NUM_TEST=$2
PREFIX=$3

# SET UP VARIABLES
. ./variables.sh

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

# CREATE NETWORK SECURITY GROUP

echo "Creating Network Security Group for $PREFIX"
az network nsg create \
--resource-group $RESOURCE_GROUP \
--name $PREFIX-nsg  

az network nsg rule create \
--nsg-name $PREFIX-nsg \
--name $PREFIX-nsg-rule-ssh \
--priority 100 \
--access Allow \
--description "SSH" \
--destination-port-ranges 22 \
--resource-group $RESOURCE_GROUP

az network nsg rule create \
--nsg-name $PREFIX-nsg \
--name $PREFIX-nsg-rule-openattic \
--priority 110 \
--access Allow \
--description "OpenAttic" \
--destination-port-ranges 8443 \
--resource-group $RESOURCE_GROUP

az network nsg rule create \
--nsg-name $PREFIX-nsg \
--name $PREFIX-nsg-rul-grafana \
--priority 120 \
--access Allow \
--description "Grafana" \
--destination-port-ranges 3000 \
--resource-group $RESOURCE_GROUP

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
-l $LOCATION \
--network-security-group $PREFIX-nsg

# CREATE TEST NODES

for NODE in $( seq 0 $(($NUM_TEST - 1)) ) 
do
	NODENAME=$PREFIX-test-$NODE

    az network nic create \
    --resource-group $RESOURCE_GROUP \
    --vnet-name $VNET \
    --subnet $SUBNET \
    -n $NODENAME-nic \
    --accelerated-networking true \
    -l $LOCATION

done

# CREATE OSD NODES

for NODE in $( seq 0 $(($NUM_OSD - 1)) ) 
do
	NODENAME=$PREFIX-osd-$NODE

    az network nic create \
    --resource-group $RESOURCE_GROUP \
    --vnet-name $VNET \
    --subnet $SUBNET \
    -n $NODENAME-nic \
    --accelerated-networking true \
    -l $LOCATION \
    --network-security-group $PREFIX-nsg

done

