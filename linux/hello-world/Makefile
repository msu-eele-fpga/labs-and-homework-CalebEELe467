ifneq ($(KERNELRELEASE),)
#kbuild part of make file
obj-m := hello-world.o

else


KDIR ?=../../../../../linux-socfpga 

default:
	$(MAKE) -C $(KDIR) ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- M=$$PWD

clean:
	$(MAKE) -C $(KDIR) M=$$PWD clean
endif