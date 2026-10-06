format ELF64

public _start

section ".data" writeable
    N = 36
    char db "$"
    endl db 0xA

section ".text" executable
_start:
    mov r12, N
    mov r13, 1
    mov rsi, char
    loop_str:
        mov rbx, r13
        loop_8:
            mov rax, 1
            mov rdi, 1
            mov rdx, 1
            syscall

            sub r12, 1
            cmp r12, 0
            je exit_program

            sub rbx, 1
            cmp rbx, 0
            jne loop_8

        mov r14, rsi

        mov rax, 1
        mov rdi, 1
        mov rsi, endl
        mov rdx, 1
        syscall

        mov rsi, r14
        add r13, 1
        cmp r12, 0
        jne loop_str

    exit_program:
        mov rax, 1
        mov rdi, 1
        mov rsi, endl
        mov rdx, 1
        syscall

        mov rax, 60
        mov rdi, 0
        syscall
