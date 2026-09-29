format ELF64

public _start

section ".data" writeable
    N db "1019734634"
    result db ?, ?
    endl   db 0xA

section ".text" executable
_start:
    mov r12, 0
    mov rsi, N
    add rsi, 10
    mov r13, rsi
    mov rsi, N

    N_loop:
        mov al, [rsi]
        add rsi, 1
        sub al, 48
        movzx r14, al
        add r12, r14
        cmp rsi, r13
        jne N_loop

    mov eax, r12d
    mov edx, 0
    mov ecx, 10
    div ecx

    add eax, 48
    add edx, 48

    mov [result], al
    mov [result+1], dl

    mov rax, 1
    mov rdi, 1
    mov rsi, result
    mov rdx, 2
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, endl
    mov rdx, 1
    syscall

    mov rax, 60
    mov rdi, 0
    syscall
