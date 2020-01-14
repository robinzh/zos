# zos
sudo apt-get install -y  build-essitial gcc-aarch64-linux-gnu flex bison libssl-dev
sudo apt-get install -y  qemu-system-common bridge-utils uml-utilities

wget qemu-4.2.0.tar.xz
tar -xJf qemu-4.2.0.tar.xz
cd qemu-4.2.0
./configure --enable-system --target-list=aarch64-softmmu,aarch64-linux-user
make -j12 ;make -j12 install



wget https://mirrors.edge.kernel.org/pub/linux/kernel/v4.x/linux-4.19.tar.xz
wget https://busybox.net/downloads/busybox-1.31.0.tar.bz2
mkdir kernel busybox
tar -xJf linux-4.19.tar.xz -C kernel
tar -xjf busybox-1.31.0.tar.bz2 -C busybox
