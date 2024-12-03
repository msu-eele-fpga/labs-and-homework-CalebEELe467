#include <../linux/init.h>
#include <../linux/module.h>
static int __init kernel_module_init(void) {
    printk(KERN_ALERT "Hello, world\n");
    return(0);
}

module_init(kernel_module_init);

static void __exit kernel_module_exit(void) {
    printk(KERN_ALERT "Goodbye, Cruel World\n");
}
module_exit(kernel_module_exit);

MODULE_DESCRIPTION("Hello World Kernel Module");
MODULE_AUTHOR("Caleb Binfet");
MODULE_LICENSE("Dual MIT/GPL");
MODULE_VERSION("1.0");
