#!/usr/bin/env bash
set -euo pipefail

VM_MEMORY="${1:-65536}"
IMAGE_PATH=/tmp/mage-compute.qcow2
cp /home/yuyang/mage-artifact/mage-compute.qcow2 "$IMAGE_PATH"
VM_NAME=mage-compute
RDMA_NODEDEV=pci_0000_3b_00_0

NODE0_CPUSET="$(seq -s, 0 2 30)"

virt-install \
  --connect qemu:///system \
  --virt-type kvm \
  --name "$VM_NAME" \
  --import \
  --transient \
  --memory "$VM_MEMORY",hugepages=yes \
  --numatune 0,mode=strict \
  --vcpus 16,sockets=1,cores=16,threads=1,cpuset="$NODE0_CPUSET" \
  --cpu host-passthrough \
  --machine q35 \
  --disk path="$IMAGE_PATH",format=qcow2,bus=virtio,cache=none,io=native \
  --network network=default,model=virtio \
  --hostdev "$RDMA_NODEDEV" \
  --os-variant ubuntu18.04 \
  --graphics none \
  --console pty,target_type=serial \
  --noautoconsole