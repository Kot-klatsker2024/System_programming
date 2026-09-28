format ELF64
public _start
section ".data" writeable
    S db "iJEcfjYGYkTaRdjdLixIKVNkM", 0xA, 0
    endl db 0xA

section ".text" executable
_start:
    mov rsi, S
    add rsi, 25
    sub rsi, 1

    round:
        mov rax, 1
        mov rdi, 1
        mov rdx, 1
        syscall

        sub rsi, 1
        cmp rsi, S
        jae round

    mov rax, 1
    mov rdi, 1
    mov rsi, endl
    mov rdx, 1
    syscall

    mov rax, 60
    mov rdi, 0
    syscall