// path: src/kernel.c
//
#include <stdbool.h>
#include "drivers/terminal.h"
//
void kernel_main() {
	terminal_init(); 								// Initialize terminal interface
	terminal_writestring("Hello, kernel World!\n"); // Print message to the terminal

    while(1); // Infinite loop to keep the kernel running
}