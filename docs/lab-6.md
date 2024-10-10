
# Lab 6 : Creating a custom component in platform designer

## Overview
In this lab we used platfomr designer to create an avalon file that instantiated our led_patterns component from lab 4 and allowed register level reads and writes. This lab set up the required hardware such that the SOC processor has the capability to directly affect the Led patterns. 

## Deliverables

## Lab Report

### System Architecture 

![Lab 6 Block Diagram](/docs/assets/Lab_6_System_Block_diagram.png)

The avalon bus wrapper has three registers that it can read and write from the are shown above in the block diagram as "LED_Control_reg", "Base_period_reg", and "led_reg". These registers feed in to the led_patterns component created previously and will be able to directly affect the output of that component in the future. 


### Register Map

| Address | Register Name |
| ------- | --------------|
| 0x00    | HPS_led_Control|
| 0x01    | Base_period|
| 0x02    | led_reg |


![led_control Register](/docs/assets/lab_6__led_control_reg.png)
LED hps Control Register at address 0x00. This register sets the control mode of the led patterns component.


![Base Period Register](/docs/assets/lab_6__base_period_reg.png)
Base Period Register at address 0x01. The lower 8 bits of this register sets the base period used by the led_patterns component.

![Led Register](/docs/assets/lab_6__led_reg.png)
Led Register at address 0x02. This register allows for direct access to the LED outputs.

These Registers are accessed in read and write processes in the wrapper component. When the read or write bit are set the data is either transfered out to the read data or read in to the current registers from the write data port on the component. 

## Questions
### Platform Designer

1. How did you connect these registers to the ARM CPUs in the HPS?

    A: The hps axi master is connected to the ip_core component using the signal bus menu in platform designer. This allows the hps to interact with the registers read by the avalon wrapper. 

2. What is the base address of your component in your Platform Designer system?

    A: The base address is 0 as shown in the following screeenshot
    ![Base address of avalon component](/docs/assets/avalon_wrapper_base_address_screenshot.png)











