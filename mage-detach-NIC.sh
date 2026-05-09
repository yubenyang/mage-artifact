#!/usr/bin/env bash
set -euo pipefail

RDMA_BDF=0000:3b:00.0
RDMA_NODEDEV=pci_0000_3b_00_0

modprobe vfio-pci

virsh nodedev-detach "$RDMA_NODEDEV" # re-attach by "nodedev-reattach"
lspci -Dnnk -s "$RDMA_BDF"