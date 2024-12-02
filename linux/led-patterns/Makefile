ifneq ($(KERNELRELEASE),)
#kbuild part of make file
obj-m := led_patterns.o

else


KDIR ?= /lib/modules/`uname -r`/build

default:
	$(MAKE) -C $(KDIR) M=$$PWD

clean:
	$(MAKE) -C $(KDIR) M=$$PWD clean
endif
