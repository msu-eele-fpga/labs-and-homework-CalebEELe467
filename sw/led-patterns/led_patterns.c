#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <sys/mman.h> // for mmap
#include <fcntl.h>    // for file open flags
#include <unistd.h>   // for getting the page size

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
    int c;

    int vflag, fflag, pflag = 0;
    char *fvalue, *pvalue = NULL;

    while ((c = getopt(argc, argv, "hvf:p:")) ! = -1)
    {
        fprintf(stderr, "arguments %d", argc);
        switch (c)
        {
        case 'h': // Prints Help Menu
            usage();
            break;
        case 'v': // Verbose Mode
            vflag = 1;
            break;
        case 'f': // Read file
            fflag = 1;
            break;
        case 'p': // Manual Pattern Input
            pflag = 1;
            break;
        }
    }
}