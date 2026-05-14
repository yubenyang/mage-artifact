#!/usr/bin/env bash
set -euo pipefail

cd "$MIND_ROOT/mind_linux"
make mrproper

sudo sed -i -E '/^GRUB_CMDLINE_LINUX_DEFAULT=/ s/"$/ cma=22G"/' /etc/default/grub
sudo update-grub
sudo reboot