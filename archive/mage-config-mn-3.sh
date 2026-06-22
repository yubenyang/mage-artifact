ssh mage-mn 'sudo apt-get update && sudo apt-get install -y zsh expect numactl'

ssh mage-mn 'cd /home/mage/mage-artifact/ && git pull'

ssh mage-mn 'sudo cp /etc/default/grub /etc/default/grub.bak && sudo sed -i '\''s/^GRUB_CMDLINE_LINUX=.*/GRUB_CMDLINE_LINUX="hugepagesz=1G hugepages=32"/'\'' /etc/default/grub && grep "^GRUB_CMDLINE_LINUX=" /etc/default/grub && sudo update-grub && sudo reboot'