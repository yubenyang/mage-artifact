# This script acts as a "config file" for the cluster setup.

# MIND_ROOT should be set in zshrc anyways.
#export MIND_ROOT="${MIND_ROOT:-$HOME/mage-artifact/mage-kernel}"

# CLUSTER SETUP
cn_vm_name=mage-compute

cn_vm_hostname=mage-compute
mn_vm_hostname=mage-memory

cn_control_sshname=mage-cn
cn_control_ip=192.168.122.50
cn_nic='ib0'
cn_mac='' # RoCE only; unused when using_roce='false'
cn_data_ip='10.10.10.201'

mn_control_sshname=mage-mn
mn_control_ip='192.168.122.51'
mn_nic='ib0'
mn_mac='' # RoCE only; unused when using_roce='false'
mn_data_ip='10.10.10.202'
mn_nic_numa=0

frontend_sshname='root@192.168.122.1'
frontend_ip=192.168.122.1

using_roce='false'
data_subnet_prefix='24'
