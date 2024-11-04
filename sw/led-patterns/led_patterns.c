#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <sys/mman.h> // for mmap
#include <fcntl.h>    // for file open flags
#include <unistd.h>   // for getting the page size
#include <signal.h>   // Dealing with CTRL C

static volatile int KeepRunning = 1;

void intHandler(int dummy) 
{
    KeepRunning = 0;
    fprintf(stderr, "\nProgram Cancelled\n");
}

void usage()
{
    fprintf(stderr, "led_patterns [OPTION]... [ARGUMENT]...\n");
    fprintf(stderr, "Control FPGA LED Outputs\n");
    fprintf(stderr, "Example: led_patterns -v stuff Here");
    fprintf(stderr, "Input Arguments:\n");
    fprintf(stderr, "\t-h\t Print this help Menu and exit\n");
    fprintf(stderr, "\t-v\t Verbose Mode. Prints LED Pattern in binary and the display duration\n");
    fprintf(stderr, "\t-p\t Set the LED Pattern and duration\n");
    fprintf(stderr, "\t-f\t Load LED Patterns and durations from a text file\n");
}

int main(int argc, char **argv)
{
   if(argc == 1) // if no input arguments print help menu and exit
        {
            usage();
        }

    int c;
    //int optind;
    int vflag, fflag, pflag = 0;
        //NOtes for me : argc stores input options +1
    
    while (((c = getopt(argc, argv, "hvf:p:")) != -1) && (KeepRunning == 1))
    {
        
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
            if(pflag)
            {
                fprintf(stderr, "Error: Arguments p and f cannot be given together\n");
            }
            KeepRunning = 0;
            break;
        case 'p': // Manual Pattern Input
            pflag = 1;    
            if(fflag)
            {
                fprintf(stderr, "Error: Arguments p and f cannot be given together\n");
            }
            KeepRunning = 0;
            break;
        case '?':   // If unknown input print help menu and exit
            usage();
            KeepRunning = 0;
            break;
        }       

        optind--;
        while(pflag == 1 && KeepRunning == 1)
        {   
            
         for (int i = optind; i < argc; i+=2)
         {
            fprintf(stderr, "LED pattern = %s\t Display time = %s ms\n",argv[i], argv[i+1]);
          }
          signal(SIGINT, intHandler);
        }
        
    }
}
