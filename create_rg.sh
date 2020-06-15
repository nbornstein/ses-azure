#!/bin/bash

PREFIX=$1

# SET UP VARIABLES
. ./variables.sh

# CREATE RESOURCE GROUP

echo "Creating resource group for $PREFIX"
az group create \
--location $LOCATION \
--name $RESOURCE_GROUP

