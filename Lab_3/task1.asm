format ELF64

public _start

section ".data" writeable
    result db ?, ?

section ".text" executable
_start:
    cmp qword [rsp], 2
    jl exit_program

    mov rbx, [rsp+16]

    movzx eax, byte [rbx]
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

    exit_program:
        mov rax, 60
        mov rdi, 0
        syscall
