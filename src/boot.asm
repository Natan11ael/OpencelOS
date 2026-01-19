; config
[org 0x7c00]                ; Set the origin address where BIOS loads the bootloader
KERNEL_LOCATION equ 0x1000  ; Memory address where the kernel will be loaded

; Save the boot drive number provided by BIOS in DL
mov [BOOT_DISK], dl 

; Initialize segment registers and setup the stack
xor ax, ax                          
mov es, ax
mov ds, ax
mov bp, 0x8000              ; Set base pointer for the stack
mov sp, bp                  ; Set stack pointer to base pointer

; Prepare parameters to load the kernel from disk
mov bx, KERNEL_LOCATION     ; Destination buffer (ES:BX)
mov dh, 10                  ; Number of sectors to read

mov ah, 0x02                ; BIOS read sector function
mov al, dh                  ; Number of sectors
mov ch, 0x00                ; Cylinder 0
mov dh, 0x00                ; Head 0
mov cl, 0x02                ; Sector 2 (Sector 1 is the bootloader)
mov dl, [BOOT_DISK]         ; Drive number
int 0x13                    ; Low-level disk services interrupt
                
; Set video mode to clear the screen
mov ah, 0x0                 ; Set video mode function
mov al, 0x3                 ; 80x25 text mode
int 0x10                    ; Video services interrupt

; Enter Protected Mode
cli                         ; Disable interrupts before switching modes
lgdt [GDT_desc]             ; Load the Global Descriptor Table (GDT)

; Switch to Protected Mode by setting the first bit of CR0
mov eax, cr0
or eax, 1
mov cr0, eax

; Far jump to flush the CPU pipeline and update the Code Segment (CS)
jmp CODE_SEG:start_protected_mode
jmp $                       ; Infinite loop (safety)

BOOT_DISK: db 0             ; Variable to store the boot drive ID

; Segment Offset Constants
CODE_SEG equ code_desc - GDT_Start
DATA_SEG equ data_desc - GDT_Start

; Global Descriptor Table (GDT) definition
GDT_Start:
    null_desc: dd 0, 0  ; Mandatory null descriptor
    code_desc:          ; Code segment descriptor (flat model)
        dw 0xffff, 0
        db 0
        db 10011010b    ; Access byte (exec/read)
        db 11001111b    ; Flags (32-bit, 4KB granularity)
        db 0
    ;
    data_desc:          ; Data segment descriptor
        dw 0xffff, 0
        db 0
        db 10010010b    ; Access byte (read/write)
        db 11001111b    ; Flags
        db 0
    ;
GDT_End:

; GDT Register structure
GDT_desc:
    dw GDT_End - GDT_Start - 1
    dd GDT_Start
;

; Transition to 32-bit Protected Mode
[bits 32]
start_protected_mode:
    ; Update all segment registers with the Data Segment selector
    mov ax, DATA_SEG
	mov ds, ax
	mov ss, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	
    ; Reposition the stack for 32-bit environment
	mov ebp, 0x90000
	mov esp, ebp

    ; Jump to the loaded kernel's entry point
    jmp KERNEL_LOCATION
;

; Boot Sector Padding and Signature
times 510-($-$$) db 0       ; Fill the rest of the 512 bytes with zeros
db 0x55, 0xaa               ; Standard boot signature (Magic number)