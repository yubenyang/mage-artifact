#!/usr/bin/env bash
set -euo pipefail

NAME="${1:?usage: $0 NAME [SIZE]}"
SIZE="${2:-100G}"

IMAGE_PATH="/home/yuyang/mage-artifact/${NAME}.qcow2"
VM_NAME="${NAME}-install"

qemu-img create -f qcow2 "$IMAGE_PATH" "$SIZE"
virt-install \
  --name "$VM_NAME" \
  --memory 4096 \
  --vcpus 2 \
  --cpu host-passthrough \
  --machine q35 \
  --disk path="$IMAGE_PATH",format=qcow2 \
  --network network=default,model=virtio \
  --os-variant ubuntu18.04 \
  --location 'http://archive.ubuntu.com/ubuntu/dists/bionic-updates/main/installer-amd64/' \
  --graphics none \
  --extra-args 'console=ttyS0,115200n8 serial'