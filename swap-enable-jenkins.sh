#!/bin/bash
VMNAME=$(echo rails@${dev_vm}.indopus.in)
echo $VMNAME
ssh -o StrictHostKeyChecking=no $VMNAME "sudo fallocate -l 16G /swapfile"
ssh -o StrictHostKeyChecking=no $VMNAME "sudo chmod 600 /swapfile"
ssh -o StrictHostKeyChecking=no $VMNAME "sudo mkswap /swapfile"
ssh -o StrictHostKeyChecking=no $VMNAME "sudo swapon /swapfile"
ssh -o StrictHostKeyChecking=no $VMNAME "sudo free -h"
ssh -o StrictHostKeyChecking=no $VMNAME "echo "SWAP Memory Has been deployed with size 16GB !!""
