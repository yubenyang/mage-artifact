#!/usr/bin/env bash
set -euo pipefail

sudo apt install -y git vim
git clone https://github.com/yubenyang/mage-artifact.git

echo 'export MIND_ROOT="$HOME/mage-artifact/mage-kernel"' >> ~/.bashrc
echo 'export MIND_ROOT="$HOME/mage-artifact/mage-kernel"' >> ~/.profile
echo 'MIND_ROOT="/home/mage/mage-artifact/mage-kernel"' | sudo tee -a /etc/environment
export MIND_ROOT="$HOME/mage-artifact/mage-kernel"

echo 'mage ALL=(ALL:ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/90-mage-nopasswd
sudo chmod 0440 /etc/sudoers.d/90-mage-nopasswd
sudo visudo -cf /etc/sudoers.d/90-mage-nopasswd

sudo apt -y update && sudo apt -y upgrade
sudo apt install -y \
  magic-wormhole make htop moreutils expect libncurses-dev \
  bison flex libssl-dev libelf-dev fakeroot liblzma-dev \
  libzstd-dev libpci-dev gawk dkms autoconf \
  rdma-core libibverbs-dev librdmacm-dev ibverbs-utils \
  rdmacm-utils moreutils \
  bc

cd "$MIND_ROOT/mind_linux"
make olddefconfig
./scripts/config --set-str SYSTEM_TRUSTED_KEYS ""
./scripts/config --disable MODULE_SIG
./scripts/config --disable MODULE_SIG_ALL
make olddefconfig
sudo ./build_kernel_and_modules.sh

sudo cp /etc/default/grub /etc/default/grub.bak
ENTRY='Advanced options for Ubuntu>Ubuntu, with Linux 4.15.0'
sudo sed -i "s|^GRUB_DEFAULT=.*|GRUB_DEFAULT=\"$ENTRY\"|" /etc/default/grub
sudo update-grub
sudo reboot