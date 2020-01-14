sudo qemu-system-aarch64 -M virt,virtualization=true,gic-version=3 \
	-cpu cortex-a53 -smp 8 -m 4906 \
	-nographic -semihosting \
	-net nic,macaddr="14:58:d0:48:d8:f8" -net tap,ifname=$net_dev \
	-kernel out/Image \
	-append "console=ttyAMA0 ppm=0x80000000,2g,0xc0000000,512m" \
	-initrd out/initrd 
	#-dtb host.dtb \

