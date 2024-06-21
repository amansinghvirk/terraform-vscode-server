#!/bin/bash

# This script is used to automate the process of creating new compute instance
# with new disk created from snapsot

while getopts d:i flag
do
    case "${flag}" in
        d) newdisk=${OPTARG};;
        i) ip=${OPTARG};;
    esac
done
echo "New-disk: $newdisk";
echo "IP: $ip";

proj_path="$(pwd)"
allow_ips="allow_ips=[\"${ip}\"\]"

if ($newdisk == "true")
then
    echo "Creating new disk from scratch"
    cd "${proj_path}/src/disk"
    terraform init
    terraform plan --out main.tfplan
    terraform apply --auto-approve main.tfplan
else
    echo "Creating new disk from snapshot"
    ## Create new disk from snapshot
    cd "${proj_path}/src/disk-from-snapshot"
    terraform init
    terraform plan --out main.tfplan
    terraform apply --auto-approve main.tfplan
fi

## Create compute instance
cd "${proj_path}/src/compute"
terraform init
terraform plan --out main.tfplan -var=$allow_ips
terraform apply --auto-approve main.tfplan

cd "${proj_path}"
