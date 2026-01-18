[bits 16]
[org 0x7c00]

; actions
mov bx, _out ; get str
mov ah, 0x0e ; write mode
call _print
mov di, _in ; store input text
call _input

_exit: jmp $
;

; funcitons
_print:
    mov al, [bx] ; al = *bx

    ; if al == 0: exit
    cmp al, 0
    je _done

    int 0x10 ; put char
    inc bx   ; *bx++
    jmp _print
_done:
    ret
;

_input:
    mov ah, 0 ; wait input
    int 0x16  ; get input
    
    ; end if enter is pressed
    cmp al, 13
    je _enter

    mov [di], al ; save char
    inc di

    mov ah, 0x0e ; write mode
    int 0x10 ; put input char 
    jmp _input
_enter:
    mov byte [di], 0  ;

    mov ah, 0x0e ; write mode
    mov al, 13 ; return init
    int 0x10
    mov al, 10 ; next line
    int 0x10
    ret
;

; variables
_out: db "Digite alguma coisa: ", 0
_in: db 0,
;

; bin struct
times 510-($-$$) db 0
db 0x55, 0xaa