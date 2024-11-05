# led_patterns.c 

## Usage
Led Patterns is is a C program that interacts directly with registers on the SOC. The program accesses /dev/mem and puts the FPGA in sofware control mode then writes the input patterns to the LED Output Register for the input period of time. The program is accessable via the command line and must be run as root inorder to access /dev/mem correctly. The led patterns to be displayed can be input as a list of arguments in the command line or can be read directly from a text file. The help menu and some examples are shown below. 

### Help Menu
`sudo ./led_patterns -h`

![Help Menu](/docs/assets/led_patterns/HelpMenu.png)


### Command Line input in Verbose Mode
`sudo ./led_patterns -v -p 0xf0 500 0x0f 500 0xff 500`

![Command Line Input Terminal](/docs/assets/led_patterns/CommandLineInput.png)

>[!NOTE] 
> -p Must be the last input option

### Text File input
`sudo ./led_patterns -f inputfile.txt`

>[!NOTE] 
> -f Must be the last input option. Here is an example text [file](/sw/led-patterns/inputfile.txt) with correct formatting


## Building
Inorder to use led_patterns.c the FPGA must be programmed with this [bitstream](/hdl/lab6/soc_system.rbf) that creates the linking of the registers written to by led_patterns.c. 

The raw C file must be crosscompiled for the arm processor on the FPGA with the -static flag to make sure the linking is correct. Here is an example

`arm-linux-gnueabihf-gcc -o led_patterns led_patterns.c -static`
