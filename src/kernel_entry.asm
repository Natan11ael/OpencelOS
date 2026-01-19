[bits 32]
[extern _kernel_main]

global __start
__start:
    call _kernel_main
    jmp $