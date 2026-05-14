#!/usr/bin/env bash
set -euo pipefail

if [[ "$(uname -r)" != "4.15.0" ]]; then
  echo "ERROR: not booted into Mage kernel. Current kernel: $(uname -r)"
  exit 1
fi

if ! dmesg | grep -qi shoop; then
  echo "ERROR: dmesg does not contain shoop; not installing OFED"
  exit 1
fi

wget -O MLNX_OFED_LINUX-5.8-5.1.1.2-ubuntu18.04-x86_64.tgz \
  https://content.mellanox.com/ofed/MLNX_OFED-5.8-5.1.1.2/MLNX_OFED_LINUX-5.8-5.1.1.2-ubuntu18.04-x86_64.tgz

tar -xzf MLNX_OFED_LINUX-5.8-5.1.1.2-ubuntu18.04-x86_64.tgz
cd MLNX_OFED_LINUX-5.8-5.1.1.2-ubuntu18.04-x86_64

sudo ./mlnxofedinstall \
  --force-dkms \
  --with-neohost-backend \
  --without-fw-update \
  --force

sudo reboot