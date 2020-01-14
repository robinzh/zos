ARCH ?= arm64
HOST ?= aarch64-linux-gnu
CROSS ?= aarch64-linux-gnu-

OUT ?= $(CURDIR)/out

SRC_BUSYBOX=$(CURDIR)/busybox/busybox-1.31.0
SRC_KERNEL=$(CURDIR)/kernel/linux-4.19

ROOTFS=$(OUT)/rootfs

all: rootfs busybox kernel pack
rootfs:
	$(Q)mkdir -p $(ROOTFS)/bin
	$(Q)mkdir -p $(ROOTFS)/boot
	$(Q)mkdir -p $(ROOTFS)/dev/pts
	$(Q)mkdir -p $(ROOTFS)/dev/shm
	$(Q)mkdir -p $(ROOTFS)/etc/init.d
	$(Q)mkdir -p $(ROOTFS)/home
	$(Q)mkdir -p $(ROOTFS)/komod
	$(Q)mkdir -p $(ROOTFS)/lib/firmware
	$(Q)mkdir -p $(ROOTFS)/mnt
	$(Q)mkdir -p $(ROOTFS)/proc
	$(Q)mkdir -p $(ROOTFS)/root
	$(Q)mkdir -p $(ROOTFS)/sbin
	$(Q)mkdir -p $(ROOTFS)/sys
	$(Q)mkdir -p $(ROOTFS)/tmp
	$(Q)mkdir -p $(ROOTFS)/usr/bin
	$(Q)mkdir -p $(ROOTFS)/usr/lib
	$(Q)mkdir -p $(ROOTFS)/usr/sbin
	$(Q)mkdir -p $(ROOTFS)/usr/share
	$(Q)mkdir -p $(ROOTFS)/var/run
	$(Q)mkdir -p $(ROOTFS)/opt
	$(Q)cp rootfs/* $(ROOTFS) -a
	$(Q)pushd $(ROOTFS); ln -s sbin/init init;popd

	#$(Q)cp -r $(shell dirname $(shell realpath $(shell which $(CROSS)gcc)))/../$(HOST)/lib $(ROOTFS)
	#$(Q)find $(ROOTFS) -name *.a|xargs rm -rf
	#$(Q)-$(CROSS)strip -s $(ROOTFS)/lib/*	


busybox:
	$(Q)mkdir -p $(OUT)/busybox
	$(Q)make ARCH=$(ARCH) CROSS_COMPILE=$(CROSS) -C $(SRC_BUSYBOX) O=$(OUT)/busybox -j12 defconfig
	$(Q)make ARCH=$(ARCH) CROSS_COMPILE=$(CROSS) -C $(SRC_BUSYBOX) O=$(OUT)/busybox -j12 
	$(Q)make ARCH=$(ARCH) CROSS_COMPILE=$(CROSS) -C $(SRC_BUSYBOX) O=$(OUT)/busybox -j12  \
		CONFIG_PREFIX=$(ROOTFS) install

kernel:
	$(Q)mkdir -p $(OUT)/kernel
	$(Q)make ARCH=$(ARCH) CROSS_COMPILE=$(CROSS) -C $(SRC_KERNEL) O=$(OUT)/kernel -j12 defconfig
	$(Q)make ARCH=$(ARCH) CROSS_COMPILE=$(CROSS) -C $(SRC_KERNEL) O=$(OUT)/kernel -j12 
	$(Q)make ARCH=$(ARCH) CROSS_COMPILE=$(CROSS) -C $(SRC_KERNEL) O=$(OUT)/kernel -j12 \
		INSTALL_MOD_PATH=$(ROOTFS) INSTALL_MOD_STRIP=1 modules_install
	$(Q)cp $(OUT)/kernel/arch/$(ARCH)/boot/Image $(OUT)
	
pack:
	$(Q)pushd $(ROOTFS);find .|cpio -o -H newc > $(OUT)/initrd
	$(Q)gzip -k -f $(OUT)/initrd
clean:
	$(Q)rm -fr $(OUT)

.PHONY: rootfs busybox kernel pack
