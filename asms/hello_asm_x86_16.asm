; config
[bits 16]
[org 0x7c00]

; say A to Z
mov ah, 0x0e ; write mode
mov al, 'A'  ; store A
a_to_z:
    int 0x10    ; put char
    inc al      ; ++i

    ; if al != 'Z': next cicle
    cmp al, 'Z' + 1
    jne a_to_z
;

; say Hello World
mov bx, hello_world ; get local datacall print
call print
jmp next_step
print:
    mov al, [bx] ; al = *bx

    ; if al == 0: exit
    cmp al, 0
    je done

    int 0x10 ; put char
    inc bx   ; *bx++
    jmp print
done:
    ret
;

next_step:
    nop
;

; ask and get one input char
mov bx, aks_char
call print
get_input_char:
    mov ah, 0 ; wait input
    int 0x16  ; get input
    mov [_char], al ; save char
    mov ah, 0x0e ; write mode
    int 0x10 ; put input char 
;

; ask and get input name
mov di, _str ; store input text
mov bx, aks_name
call print
get_input_str:
    mov ah, 0 ; wait input
    int 0x16  ; get input
    
    ; end if enter is pressed
    cmp al, 13
    je _enter

    mov [di], al ; save char
    inc di

    mov ah, 0x0e ; write mode
    int 0x10 ; put input char 
    jmp get_input_str
;

_enter:
    mov byte [di], 0  ;

    mov ah, 0x0e ; write mode
    mov al, 13 ; return init
    int 0x10
    mov al, 10 ; next line
    int 0x10
    jmp say_hello
;

; say hello
say_hello:
    mov bx, greet
    call print
    mov bx, _str
    call print
    jmp exit
;

exit:
    jmp $
;

; static var
hello_world:
    db 13, 10, "Hello, world", 0
;

aks_char:
    db 13, 10, "type a character:", 0
;

aks_name:
    db 13, 10, "type your name:", 0
;

greet:
    db "Hello ", 0
;

; generale var
_char:
    db 0,
;

_str:
    times 20 db 0
;

; bin struct
times 510-($-$$) db 0
db 0x55, 0xaa