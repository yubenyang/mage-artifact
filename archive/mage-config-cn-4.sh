ssh mage-cn 'sudo apt-get update && sudo apt-get install -y zsh expect numactl'

ssh mage-cn 'cd /home/mage/mage-artifact/ && git pull'

ssh mage-cn 'cd $MIND_ROOT/mind_linux && make olddefconfig && scripts/config --enable DMA_CMA && make olddefconfig && sudo ./build_kernel_and_modules.sh && sudo update-grub && sudo reboot'

ssh mage-cn 'cd MLNX_OFED_LINUX-5.8-5.1.1.2-ubuntu18.04-x86_64 && sudo ./mlnxofedinstall --force-dkms --with-neohost-backend --without-fw-update --force && sudo reboot'