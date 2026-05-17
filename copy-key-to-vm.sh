#!/usr/bin/env bash
set -euo pipefail

VM_IP=$1
ssh mage@"$VM_IP" 'mkdir -p /home/mage/.ssh && chmod 700 /home/mage/.ssh'
scp /root/.ssh/id_rsa mage@"$VM_IP":/home/mage/.ssh/id_rsa
scp /root/.ssh/authorized_keys mage@"$VM_IP":/home/mage/.ssh/authorized_keys
ssh mage@"$VM_IP" 'chmod 600 /home/mage/.ssh/id_rsa /home/mage/.ssh/authorized_keys'