#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

sudo apt-get update
sudo apt-get install -y zsh expect
"$script_dir/mage-install-path.sh" host1

ssh mage-cn 'cd /home/mage/mage-artifact/ && git pull'
ssh mage-mn 'cd /home/mage/mage-artifact/ && git pull'

ssh mage-cn '$MIND_ROOT/../mage-install-path.sh cn'
ssh mage-mn '$MIND_ROOT/../mage-install-path.sh mn'

scp mage-kernel/mind_linux/include/disagg/cnthread_disagg.h mage-cn:/home/mage/mage-artifact/mage-kernel/mind_linux/include/disagg/cnthread_disagg.h
scp mage-kernel/mind_linux/include/disagg/network_fit_disagg.h mage-cn:/home/mage/mage-artifact/mage-kernel/mind_linux/include/disagg/network_fit_disagg.h
scp mage-kernel/apps/xsbench/test-one.zsh mage-cn:/home/mage/mage-artifact/mage-kernel/apps/xsbench/test-one.zsh
scp mage-kernel/scripts/cn/generate-posttest-logs mage-cn:/home/mage/mage-artifact/mage-kernel/scripts/cn/generate-posttest-logs

ssh mage-cn 'cd $MIND_ROOT/mind_linux/tools/perf/ && make -j$(nproc)'
ssh mage-cn '[[ -d FlameGraph ]] || git clone https://github.com/brendangregg/FlameGraph.git'
