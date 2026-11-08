format ELF64

public _start

section '.bss' writeable
    b rb 4095

section '.text' executable
_start:
    cmp qword [rsp], 3
    jl exit_program

    mov r15, [rsp+16] ; file1
    mov r14, [rsp+24] ; file2

    mov rax, 2
    mov rdi, r15
    mov rsi, 0
    mov rdx, 0
    syscall

    cmp rax, 0
    jl exit_program

    mov r13, rax

    mov rax, 2
    mov rdi, r14
    mov rsi, 1
    mov rdx, 0
    syscall

    cmp rax, 0
    jl exit_program

    mov r12, rax

    record_file1_in_bufer:
        mov rax, 0
        mov rdi, r13
        mov rsi, b
        mov rdx, 4095
        syscall

        cmp rax, 0
        jle close_files
        mov rbx, rax

        mov rsi, b
        add rsi, rbx
        mov rcx, rsi
        sub rcx, 1
        sub rsi, 2

    find_end_str_in_file1:
        cmp byte [rsi], 0x0A
        je calculate_lenght1
        cmp rsi, b
        je calculate_lenght2

        sub rsi, 1
        jmp find_end_str_in_file1

    calculate_lenght1:
        mov rdx, rcx
        sub rdx, rsi
        add rsi, 1
        jmp record_bufer_in_file2

    calculate_lenght2:
        mov rdx, rcx
        sub rdx, rsi

    record_bufer_in_file2:
        mov rax, 1
        mov rdi, r12
        syscall

        cmp rsi, b
        je close_files

        sub rsi, 1
        mov rcx, rsi
        sub rsi, 1
        jmp find_end_str_in_file1

    close_files:
        close_file1:
            mov rax, 3
            mov rdi, r13
            syscall
        close_file2:
            mov rax, 3
            mov rdi, r12
            syscall

    exit_program:
        mov rax, 60
        mov rdi, 0
        syscall
