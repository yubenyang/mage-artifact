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