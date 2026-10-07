format ELF64

public _start

section ".data" writeable
    number db ?, ?, ?
    answer db ?, ?
    all_answer db ?, ?, ?, ?
    endl db 0xA

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

    mov r13, 0
    mov r14, 0

    poll:
        mov rax, 0
        mov rdi, 0
        mov rsi, answer
        mov rdx, 2
        syscall

        movzx eax, [answer]
        sub eax, 48

        mov r15, rax

        cmp r15, 0
        je NO

        cmp r15, 1
        je YES

    jmp exit_programm

    NO:
        add r13, 1
        sub r12, 1
        jnz poll

    jmp calculations

    YES:
        add r14, 1
        sub r12, 1
        jnz poll

    calculations:
        cmp r13, r14
        ja all_NO
        jb all_YES
        je NONE

    all_NO:
        mov [all_answer], 78
        mov [all_answer+1], 79
        jmp exit_programm

    all_YES:
        mov [all_answer], 89
        mov [all_answer+1], 69
        mov [all_answer+2], 83
        jmp exit_programm

    NONE:
        mov [all_answer], 78
        mov [all_answer+1], 79
        mov [all_answer+2], 78
        mov [all_answer+3], 69

    exit_programm:
        mov rax, 1
        mov rdi, 1
        mov rsi, all_answer
        mov rdx, 4
        syscall

        mov rax, 1
        mov rdi, 1
        mov rsi, endl
        mov rdx, 1
        syscall

        mov rax, 60
        mov rdi, 0
        syscall
