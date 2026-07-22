#!/usr/bin/env bash
set -euo pipefail

for target in mage-cn mage-mn; do
  ssh "$target" 'mkdir -p /home/mage/.ssh && chmod 700 /home/mage/.ssh'
  scp /root/.ssh/id_rsa "$target":/home/mage/.ssh/id_rsa
  scp /root/.ssh/authorized_keys "$target":/home/mage/.ssh/authorized_keys
  ssh "$target" 'chmod 600 /home/mage/.ssh/id_rsa /home/mage/.ssh/authorized_keys'
done
