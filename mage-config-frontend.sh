#!/usr/bin/env bash
set -euo pipefail

sudo apt install -y \
  moreutils cmake \
  thrift-compiler libthrift-dev \
  libevent-dev libhiredis-dev \
  libboost-system-dev \
  build-essential

export MIND_ROOT="/home/yuyang/mage-artifact/mage-kernel"
echo 'export MIND_ROOT="/home/yuyang/mage-artifact/mage-kernel"' >> ~/.bashrc
echo 'export MIND_ROOT="/home/yuyang/mage-artifact/mage-kernel"' >> ~/.profile
echo 'MIND_ROOT="/home/yuyang/mage-artifact/mage-kernel"' | sudo tee -a /etc/environment

cd "$MIND_ROOT/frontend"
./build_mind_ctrl.sh