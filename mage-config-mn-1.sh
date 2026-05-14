#!/usr/bin/env bash
set -euo pipefail

sudo apt -y update
sudo apt install -y git vim moreutils make gcc g++ dkms wget ca-certificates \
  perl lsb-release pciutils ethtool

# Set VM hostname
sudo hostnamectl set-hostname mage-memory
sudo sed -i 's/^127\.0\.1\.1.*/127.0.1.1       mage-memory/' /etc/hosts

git clone https://github.com/yubenyang/mage-artifact.git

export MIND_ROOT="$HOME/mage-artifact/mage-kernel"

echo 'export MIND_ROOT="$HOME/mage-artifact/mage-kernel"' >> ~/.bashrc
echo 'export MIND_ROOT="$HOME/mage-artifact/mage-kernel"' >> ~/.profile
echo 'MIND_ROOT="/home/mage/mage-artifact/mage-kernel"' | sudo tee -a /etc/environment

echo "$USER ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/90-mage-nopasswd
sudo chmod 0440 /etc/sudoers.d/90-mage-nopasswd
sudo visudo -cf /etc/sudoers.d/90-mage-nopasswd

sudo -n true && echo "passwordless sudo works"

wget -O MLNX_OFED_LINUX-5.8-5.1.1.2-ubuntu18.04-x86_64.tgz \
  https://content.mellanox.com/ofed/MLNX_OFED-5.8-5.1.1.2/MLNX_OFED_LINUX-5.8-5.1.1.2-ubuntu18.04-x86_64.tgz

tar -xzf MLNX_OFED_LINUX-5.8-5.1.1.2-ubuntu18.04-x86_64.tgz
cd MLNX_OFED_LINUX-5.8-5.1.1.2-ubuntu18.04-x86_64

sudo ./mlnxofedinstall \
  --without-fw-update \
  --force

sudo reboot