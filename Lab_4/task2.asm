format ELF64

public _start

section ".data" writeable
    number db ?, ?, ?
    sum db ?, ?, ?

section ".text" executable
_start:
    mov rax, 0
    mov rdi, 0
    mov rsi, number
    mov rdx, 3
    syscall

    mov rbx, 10
    movzx eax, [number]
    sub eax, 48
    mul rbx

    mov r12, rax

    movzx eax, [number+1]
    sub eax, 48

    add r12, rax

    mov r13, -1
    mov r14, 1
    mov r15, 1
    mov r9, 0

    sum_loop:
        mov r10, r14
        imul r10, r14
        mov rbx, r14
        sub rbx, 1
        multiplier:
            cmp rbx, 0
            je zero_found

            imul r15, r13

            sub rbx, 1
            cmp rbx, 0
            jnz multiplier

        zero_found:
            imul r15, r10
            add r9, r15
            mov r15, 1
            add r14, 1
            cmp r14, r12
            jle sum_loop

    minus:
        cmp r9, 0
        jge plus

        mov eax, r9d
        mov [sum], 45
        neg eax

        mov edx, 0
        mov ecx, 10
        div ecx
        add eax, 48
        add edx, 48
        mov [sum+1], al
        mov [sum+2], dl

        jmp exit_programm

    plus:
        mov eax, r9d
        mov edx, 0
        mov ecx, 10
        div ecx
        add eax, 48
        add edx, 48
        mov [sum], al
        mov [sum+1], dl

    exit_programm:
        mov rax, 1
        mov rdi, 1
        mov rsi, sum
        mov rdx, 3
        syscall

        mov rax, 60
        mov rdi, 0
        syscall
