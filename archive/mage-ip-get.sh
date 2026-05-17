#!/usr/bin/env bash
set -euo pipefail

VM_NAME="${1:-mage-compute}"

virsh domifaddr "$VM_NAME" \
  | awk '/ipv4/ { sub("/.*", "", $4); print $4; exit }'