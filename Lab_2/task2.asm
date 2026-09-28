format ELF64 

public _start

section ".data" writeable
    K = 4
    M = 9
    N = K * M
    char = "$"
    matrix rb 1000
    endl db 0xA

section ".text" executable
_start:
    mov rcx, N
    mov rsi, matrix

record:
    mov byte [rsi], char
    add rsi, 1
    sub rcx, 1
    cmp rcx, 0
    jne record

    mov rsi, matrix
    mov r13, K

K_loop:
    mov r14, M

M_loop:
    mov rax, 1
    mov rdi, 1
    mov rdx, 1
    syscall

    add rsi, 1
    sub r14, 1
    cmp r14, 0
    jne M_loop

    mov r12, rsi

    mov rax, 1
    mov rdi, 1
    mov rsi, endl
    mov rdx, 1
    syscall

    mov rsi, r12

    sub r13, 1
    cmp r13, 0
    jne K_loop
    
    mov rax, 60
    mov rdi, 0
    syscall