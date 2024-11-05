#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <sys/mman.h> // for mmap
#include <fcntl.h>    // for file open flags
#include <unistd.h>   // for getting the page size and sleep
#include <signal.h>   // Dealing with CTRL C

static volatile int KeepRunning = 1;

void intHandler(int dummy)
{
    KeepRunning = 0;
    
}

    void usage()
    {
        fprintf(stderr, "Usage: led_patterns [OPTION] [foo]...\n");
        fprintf(stderr, "Control FPGA LED Outputs\n\n");
        fprintf(stderr, "Example: led_patterns -v -p 0xf0 500\n\n");
        fprintf(stderr, "Input Arguments:\n");
        fprintf(stderr, "\t-h\t Print this help Menu and exit\n");
        fprintf(stderr, "\t-v\t Verbose Mode. Prints LED Pattern in binary and the display duration\n");
        fprintf(stderr, "\t-p\t Set the LED Pattern and duration\n");
        fprintf(stderr, "\t-f\t Load LED Patterns and durations from a text file\n");
        exit(1);
    }

    int main(int argc, char **argv)
    {
        const size_t PAGE_SIZE = sysconf(_SC_PAGE_SIZE); // Size of a page of memory
        const uint32_t CONTROL_REG = 0xff200000;
        const uint32_t LED_REG = 0xff200008;

        if (argc == 1) // if no input arguments print help menu and exit
        {
            usage();
        }

        int c;
        // int optind;
        int vflag = 0;
        int fflag = 0;
        int pflag = 0;
        // NOtes for me : argc stores input options +1

        while (((c = getopt(argc, argv, "hvf:p:")) != -1) && (KeepRunning == 1))
        {

            switch (c)
            {
            case 'h': // Prints Help Menu
                usage();
                exit(1);
                break;
            case 'v': // Verbose Mode
                vflag = 1;
                break;
            case 'f': // Read file
                fflag = 1;
                if (pflag == 1)
                {
                    fprintf(stderr, "Error: Arguments -p and -f cannot be given together\n");
                    KeepRunning = 0;
                    exit(1);
                }

                break;
            case 'p': // Manual Pattern Input
                pflag = 1;
                if (fflag == 1)
                {
                    fprintf(stderr, "Error: Arguments -p and -f cannot be given together\n");
                    KeepRunning = 0;
                    exit(1);
                }
                else if ((argc - optind - 1) % 2)
                {
                    fprintf(stderr, "Error: Argument -p requires even number of inputs\n");
                    KeepRunning = 0;
                    exit(1);
                }

                break;
            case '?': // If unknown input print help menu and exit
                usage();
                KeepRunning = 0;
                exit(1);
                break;
            }
        }

        int fd = open("/dev/mem", O_RDWR | O_SYNC);
        if(fd == -1)
        {
            fprintf(stderr, "failed to open /dev/mem.\n");
            exit(1);
        }
        // ------ Put In Software Control Mode ----------
        uint32_t page_aligned_addr = CONTROL_REG & ~(PAGE_SIZE - 1);
        uint32_t *page_virtual_addr = (uint32_t *)mmap(NULL, PAGE_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, fd, page_aligned_addr);
        if (page_virtual_addr == MAP_FAILED)
        {
            fprintf(stderr, "failed to map memory.\n");
        }
        uint32_t offset_in_page = CONTROL_REG & (PAGE_SIZE - 1);
        uint32_t *target_virtual_addr = page_virtual_addr + offset_in_page / sizeof(uint32_t *);
        uint32_t VALUE = 1;
        *target_virtual_addr = VALUE;
        usleep(500 * 1000);
        //---------------------------------------------------

        // ----- Calculate address of LED_REG-----------

        uint32_t page_aligned_addr2 = LED_REG & ~(PAGE_SIZE - 1);
        uint32_t *page_virtual_addr2 = (uint32_t *)mmap(NULL, PAGE_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, fd, page_aligned_addr2);
        if (page_virtual_addr2 == MAP_FAILED)
        {
            fprintf(stderr, "failed to map memory.\n");
        }
        uint32_t offset_in_page2 = LED_REG & (PAGE_SIZE - 1);
        uint32_t *target_virtual_addr2 = page_virtual_addr2 + offset_in_page2 / sizeof(uint32_t *);
        

        //------------------------------------------------------------------

        optind--;
        while (pflag == 1 && KeepRunning == 1)
        {

            for (int i = optind; i < argc; i += 2)
            {
                if (vflag == 1)
                {
                    fprintf(stderr, "LED pattern = %8b \t Display time = %s ms\n", strtoul(argv[i], NULL, 0), argv[i + 1]);
                }
                /*
                Do Stuff with FPGA Memory Here
                */

                uint32_t VALUE = strtoul(argv[i], NULL, 0);
                *target_virtual_addr2 = VALUE;
                usleep(strtoul(argv[i + 1], NULL, 0) * 1000); // Convers ms String into int of microseconds then sleeps
            }
            signal(SIGINT, intHandler);
        }

        if (fflag == 1 && KeepRunning == 1)
        {
            FILE *fptr;
            char line[50];
            char *Output;
            char *Output2;

            fptr = fopen(argv[optind], "r");

            while (fgets(line, sizeof(line), fptr) != NULL)
            {
                Output = strtok(line, " ");
              
                while (Output != NULL)
                {
                    
                    Output2 = strtok(NULL, "\n");
                    if(vflag)
                    {
                    fprintf(stderr, "LED Patterns = %8b\t",strtoul(Output, NULL, 0));
                    fprintf(stderr, "Display time = %sms\n", Output2);
                    }
                    uint32_t VALUE = strtoul(Output, NULL, 0);
                    *target_virtual_addr2 = VALUE;
                    usleep(strtoul(Output2, NULL, 0) * 1000); // Convers ms String into int of microseconds then sleeps
                    Output = strtok(NULL, " ");
                    
              
                }
            }
        }
        *target_virtual_addr = 0;
        fprintf(stderr, "\nProgram Ended\nThe system is now in Hardware Control Mode\n\n");
    }
