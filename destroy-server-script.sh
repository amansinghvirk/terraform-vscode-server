#!/bin/bash

# This script is used to automate the process of destroying the compute instance and 
# disk, before destroying it will take the snapshot of the disk

## destroy if any previous snapshot is there
cd snapshot-from-disk
terraform init
terraform destroy --auto-approve
cd ..

## create snapshot from disk
cd snapshot-from-disk
terraform init
terraform plan --out main.tfplan
terraform apply --auto-approve main.tfplan
cd ..

## Destroy compute
cd compute
terraform init
terraform destroy --auto-approve
cd ..

## Destroy disk if disk was new created
cd disk
terraform init
terraform destroy --auto-approve
cd ..

## Destroy disk if it was created from snapshot
cd disk-from-snapshot
terraform init
terraform destroy --auto-approve
cd ..
