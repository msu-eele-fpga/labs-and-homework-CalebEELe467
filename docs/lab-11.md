# Lab 11 : Platform Device Driver

## Overview
In this lab we created a device driver that was added to the device tree of our fpga. This allowed us to put the fpga leds in software control mode and access the output register with ease. We did this by adding device attributes to the led_patterns device we created. 

### Questions 

> What is the purpose of the platform bus?

The platform bus is a virtual bus that allows us to tell the os how to interact with hardware that is not discoverable.

> Why is the device driver’s compatible property important?

if the device tree node and compatible string match then the driver and device get bound together.

> What is the probe function’s purpose?

Allocate kernel memory, remap physical memory, and attach the container to the platform device. 

> How does your driver know what memory addresses are associated with your device?

The probe remaps and reservers the physical memory. 

> What are the two ways we can write to our device’s registers? In other words, what subsystems do
we use to write to our registers?

We can do it directly with io_write or we can use the device attributes. 

> What is the purpose of our struct led_patterns_dev state container

It contains pointers to the device registers. 
