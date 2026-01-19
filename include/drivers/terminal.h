// path: include/drivers/terminal.h
//
#ifndef TERMINAL_H
#define TERMINAL_H
#include <stdint.h>
#include <stddef.h>
//
void terminal_init(void);
void terminal_setcolor(uint8_t color);
static inline void terminal_putentryat(char c, uint8_t color, size_t x, size_t y);
void terminal_putchar(char c);
void terminal_write(const char* data, size_t size);
void terminal_writestring(const char* data);
//
#endif