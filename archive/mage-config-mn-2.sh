#!/usr/bin/env bash
set -euo pipefail

cd "$MIND_ROOT/mem-server"
make

hostname
cat /etc/hosts | grep '127.0.1.1'

ofed_info -s
dmesg | grep -i ofed
lsmod | egrep 'mlx5|ib_core|rdma|mlx_compat'
lspci | egrep -i 'mellanox|connectx|infiniband'
ibv_devinfo
rdma link show
grep RUN_FW_UPDATER_ONBOOT /etc/infiniband/openib.conf
printenv MIND_ROOT
sudo -n true && echo "passwordless sudo works"