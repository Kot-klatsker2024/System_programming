format ELF64

public _start

section ".data" writeable
    result db ?

section ".text" executable
_start:
    cmp qword [rsp], 4
    jl exit_program

    mov r12, [rsp + 16]
    mov r13, [rsp + 24]
    mov r14, [rsp + 32]

    movzx eax, byte [r12]
    sub eax, 48
    mov edx, 0
    movzx ecx, byte [r13]
    sub ecx, 48
    div ecx

    movzx ecx, byte [r12]
    sub ecx, 48
    add eax, ecx

    movzx ecx, byte [r14]
    sub ecx, 48
    mov edx, 0
    div ecx


    add eax, 48
    mov [result], al

    mov rax, 1
    mov rdi, 1
    mov rsi, result
    mov rdx, 1
    syscall

    exit_program:
        mov rax, 60
        mov rdi, 0
        syscall
