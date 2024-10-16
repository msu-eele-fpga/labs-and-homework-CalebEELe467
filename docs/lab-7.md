
# Lab 7 : Verifying custom component with devmem and system console


## Overview
In this lab we added the jtag to avalon maste bridge component to our soc sytem component generated with platform designer. Then we used system console to then write to the registers that contorl the led outputs and base period. Then c code was used to manipulat devmem and control the leds via putty over uart. 


### Questions 
If the deliverables include questions you need to answer, put the answers here. Use blockquotes to indicate the question, then answer underneath the blockquote. Example formatting is shown below.

> What hex value did you write to base_period to have a 0.125 second base period?

    A: The full 32 bit value was 0x00000002

> What hex value did you write to base_period to have a 0.5625 second base period?

    A: The full 32 bit value was 0x00000009

