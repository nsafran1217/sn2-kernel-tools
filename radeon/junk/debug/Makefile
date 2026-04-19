obj-m := sn2_fsb_test.o

# Cross-compile for ia64 SN2
# Set KDIR to the path of your ia64 kernel source tree (with .config and prepared headers)
# Example: KDIR=/home/user/linux-3.x-ia64
ARCH := ia64
CROSS_COMPILE := ia64-linux-

KDIR :=  /home/nathan/altix_cross/src/mainline/linux-sn2/

all:
	$(MAKE) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) -C $(KDIR) M=$(PWD) modules

clean:
	$(MAKE) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) -C $(KDIR) M=$(PWD) clean