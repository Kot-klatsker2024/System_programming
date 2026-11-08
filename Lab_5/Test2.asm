format ELF64

public _start

section '.data' writeable
    file1 db "a.txt", 0
    file2 db "b.txt", 0

section '.bss' writeable
    b rb 1

section '.text' executable
_start:
    cmp qword [rsp], 2
    jl exit_program

    mov rax, [rsp+16]
    movzx r15, byte [rax]
    sub r15, 48

    mov rax, 2
    mov rdi, file1
    mov rsi, 0
    syscall
    cmp rax, 0
    jl exit_program
    mov r12, rax

    mov rax, 2
    mov rdi, file2
    mov rsi, 1
    mov rdx, 0
    syscall
    cmp rax, 0
    jl close_file1
    mov r14, rax

    mov r13, 1

processing_loop:
    mov rax, 0
    mov rdi, r12
    mov rsi, b
    mov rdx, 1
    syscall

    cmp rax, 0
    je close_all

    cmp r13, r15
    jne skip_write

    mov rax, 1
    mov rdi, r14
    mov rsi, b
    mov rdx, 1
    syscall

    mov r13, 0

skip_write:
    add r13, 1
    jmp processing_loop

close_all:
    close_file2:
        mov rax, 3
        mov rdi, r14
        syscall

    close_file1:
        mov rax, 3
        mov rdi, r12
        syscall

exit_program:
    mov rax, 60
    mov rdi, 0
    syscall
