#!/bin/bash

# This script is used to automate the process of creating new compute instance
# with new disk created from snapsot

while getopts d:i: flag
do
    case "${flag}" in
        d) newdisk=${OPTARG};;
        i) ip=${OPTARG};;
    esac
done
echo "New-disk: $newdisk";
echo "IP: $ip";

if ($newdisk == "true")
then
    echo "Creating new disk from scratch"
    cd disk
    terraform init
    terraform plan --out main.tfplan
    terraform apply --auto-approve main.tfplan
    cd ..
else
    echo "Creating new disk from snapshot"
    ## Create new disk from snapshot
    cd disk-from-snapshot
    terraform init
    terraform plan --out main.tfplan
    terraform apply --auto-approve main.tfplan
    cd ..
fi

## Create compute instance
cd compute
terraform init
terraform plan --out main.tfplan -var=$ALLOW_IPS
terraform apply --auto-approve main.tfplan
cd ..
