format ElF64 write executable
public _start

section '.data' writeable
    msg1 db "Serguchanov", 0xA, 0
    msg2 db "Timur", 0xA, 0
    msg3 db "Nikolayevich", 0xA, 0

section '.text' executable
_start:
    mov rax, 4
    mov rbx, 1
    mov rcx, msg1
    mov rdx, 12
    int 0x80

    mov rax, 4
    mov rbx, 1
    mov rcx, msg2
    mov rdx, 6
    int 0x80

    mov rax, 4
    mov rbx, 1
    mov rcx, msg3
    mov rdx, 13
    int 0x80

    mov rax, 1
    mov rbx, 0
    int 0x80