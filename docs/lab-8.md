
# Lab 8 : led_patterns.c 

## Overview
In this lab we created a C program that interacts with /dev/mem to write the led_reg output when the FPGA is in sofware control mode. The C program can be run from the terminal with various input arguments. The [README](/sw/led-patterns/README.md) file explains the programs usage and building. 




### How do you Calculate the Physical addresses of the component created previously?

The base address of the lighweight bridge is 0xff200000 which is the address of the LED_Control Register in my custom component this will function as the starting point for the calculation of the physical address.

The page alligned address is then calculated by anding with the inverse of the pagesize -1 like so

`page_aligned_addr = CONTROL_REG & ~(PAGE_SIZE - 1)`

then a pointer to the virtual page address is created

`*page_virtual_addr = (uint32_t *)mmap(NULL, PAGE_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, fd, page_aligned_addr)`

Then the offset in the page of memory is calculated 

`offset_in_page = CONTROL_REG & (PAGE_SIZE - 1)`

Then the page offset and the page address are combined to get the final address 

`*target_virtual_addr = page_virtual_addr + offset_in_page / sizeof(uint32_t *)`

These are the same calculations given in the dev/mem code supplied earlier. 


    

    

