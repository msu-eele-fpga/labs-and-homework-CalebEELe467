#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <sys/mman.h> // for mmap
#include <fcntl.h>    // for file open flags
#include <unistd.h>   // for getting the page size
#include <getopt.h>

void usage()
{
    fprintf(stderr, "led_patterns [OPTION]... [ARGUMENT]...\n");
    fprintf(stderr, "Control FPGA LED Outputs\n");
    fprintf(stderr, "Example: led_patterns -v stuff Here");
    fprintf(stderr, "Input Arguments:\n");
    fprintf(stderr, "\t-h\t Print this help Menu and exit");
    fprintf(stderr, "\t-v\t Verbose Mode. Prints LED Pattern in binary and the display duration");
    fprintf(stderr, "\t-p\t Set the LED Pattern and duration");
    fprintf(stderr, "\t-f\t Load LED Patterns and durations from a text file");

}

int main(int argc, char **argv)
{
    char c;
    int digit_optind = 0;
    int aopt = 0, bopt = 0;
    char *copt = 0, *dopt = 0;
    while ((c = getopt(argc, argv, "hvf:p:")) ! = -1){

        
    }




























}