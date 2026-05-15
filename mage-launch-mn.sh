#!/usr/bin/env bash
set -euo pipefail

VM_MEMORY="${1:-65536}"
IMAGE_PATH=/tmp/mage-memory.qcow2
SOURCE_IMAGE=/home/yuyang/mage-artifact/mage-memory.qcow2
VM_NAME=mage-memory
RDMA_NODEDEV=pci_0000_3b_00_0
VM_MAC="${VM_MAC:-52:54:00:3b:00:51}"
VM_IP="${VM_IP:-192.168.122.51}"
NODE0_CPUSET="$(seq -s, 0 2 30)"

if [[ ! -f "$IMAGE_PATH" ]]; then
  cp "$SOURCE_IMAGE" "$IMAGE_PATH"
fi

if ! virsh net-dumpxml default | grep -q "$VM_MAC"; then
  virsh net-update default add ip-dhcp-host \
    "<host mac='$VM_MAC' name='$VM_NAME' ip='$VM_IP'/>" \
    --live --config
fi

virt-install \
  --connect qemu:///system \
  --virt-type kvm \
  --name "$VM_NAME" \
  --import \
  --memory "$VM_MEMORY",hugepages=yes \
  --numatune 0,mode=strict \
  --vcpus 16,sockets=1,cores=16,threads=1,cpuset="$NODE0_CPUSET" \
  --cpu host-passthrough \
  --machine q35 \
  --disk path="$IMAGE_PATH",format=qcow2,bus=virtio,cache=none,io=native \
  --network network=default,model=virtio,mac="$VM_MAC" \
  --hostdev "$RDMA_NODEDEV" \
  --os-variant ubuntu18.04 \
  --graphics none \
  --console pty,target_type=serial \
  --noautoconsole