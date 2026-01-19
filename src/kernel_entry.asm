[bits 32]               ; Define that this code runs in 32-bit Protected Mode
[extern _kernel_main]   ; Declare that '_kernel_main' is defined in an external file (your C code)
; This allows the linker to connect this call to your C function

global __start          ; Export the symbol '__start' so the linker knows the entry point
__start:
    call _kernel_main   ; Execute the main C function of your kernel 
    jmp $               ; Infinite loop: if the kernel ever returns, hang the CPU 
    ; to prevent it from executing random memory/garbage