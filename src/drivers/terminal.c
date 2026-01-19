
// path: src/drivers/terminal.c
//
#include "drivers/terminal.h"
#include "drivers/vga.h"
#include "lib/string.h"
//
// terminal data structure
typedef struct {
    size_t row;			// define current row
    size_t column;		// define current column
    uint8_t color;		// define current color
    uint16_t* buffer;	// define VGA buffer pointer
} terminal_t;
//
static terminal_t m_terminal;
//
// Terminal functions implementation
void terminal_init(void) {
	m_terminal.row = 0;
	m_terminal.column = 0;
	m_terminal.color = entry_color(VGA_COLOR_LIGHT_GREY, VGA_COLOR_BLACK);
    m_terminal.buffer = (uint16_t*)VGA_MEMORY; 
	
	for (size_t i = 0; i < VGA_HEIGHT * VGA_WIDTH; i++) {
		const size_t index = i;
		m_terminal.buffer[index] = vga_entry(' ', m_terminal.color);
	}
}
//
void terminal_setcolor(uint8_t color) {
	m_terminal.color = color;
}
//
void terminal_putentryat(char c, uint8_t color, size_t x, size_t y) {
	const size_t index = y * VGA_WIDTH + x;
	m_terminal.buffer[index] = vga_entry(c, color);
}
//
void terminal_putchar(char c) {
    if (c == '\n') {
        m_terminal.column = 0;
        if (++m_terminal.row == VGA_HEIGHT) m_terminal.row = 0;
        return;
    }

	terminal_putentryat(c, m_terminal.color, m_terminal.column, m_terminal.row);
	if (++m_terminal.column == VGA_WIDTH) {
		m_terminal.column = 0;
		if (++m_terminal.row == VGA_HEIGHT) m_terminal.row = 0;
	}
}
//
void terminal_write(const char* data, size_t size) {
	for (size_t i = 0; i < size; i++) terminal_putchar(data[i]);
}
//
void terminal_writestring(const char* data) {
	terminal_write(data, strlen(data));
}