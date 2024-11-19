# Lab 10 : Device Trees

## Overview
In this lab we created a new base device tree for the de10nano based on the de0. We then modified the kernal to use the userled on the board as a heartbeat led. Then the device tree was modified to reflect this change in funcitonality. 



### Questions 
> What is the purpose of a device tree?

A device tree allows us to tell the system what devices are attached to it and how to interact with these devices. It allows for standardization of the interaction between the processor and any devices it is attached to without having to write a unique driver for every device that is attached to the processor.



