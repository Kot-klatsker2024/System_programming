format ELF64

extrn initscr
extrn start_color
extrn init_pair
extrn attron
extrn curs_set
extrn mvaddch
extrn refresh
extrn usleep
extrn endwin
extrn getch
extrn nodelay
extrn noecho
public _start


section ".text" executable
_start:
    call initscr

    mov rdi, rax
    mov rsi, 1
    call nodelay

    call noecho

    call start_color

    mov rdi, 1
    call curs_set

    mov r15, 0
    mov r14, 50
    mov r13, 100000
    mov r12, 2

    restart2:
        mov r15, 0
        mov r14, 50

        mov rdi, 1
        mov rsi, 1
        mov rdx, 0
        call init_pair

        mov rdi, 256
        call attron
        jmp draw1

    restart1:
        add r12, 1
        mov rax, r12
        mov rdx, 0
        mov rbx, 2
        div rbx
        cmp rdx, 0
        je restart2

        mov r15, 0
        mov r14, 50

        mov rdi, 2
        mov rsi, 5
        mov rdx, 0
        call init_pair

        mov rdi, 512
        call attron

    draw1:
        speed_and_exit_program1:
            call getch

            cmp rax, 103
            je exit_program

            cmp rax, 97
            jne no_speed1
            sub r13, 15000

        no_speed1:
        mov rdi, r15
        mov rsi, r14
        mov rdx, "-"
        call mvaddch

        call refresh

        sub r14, 1

        mov rdi, r13
        call usleep

        cmp r14, 10
        jne draw1

    mov rdi, r15
    mov rsi, r14
    mov rdx, "-"
    call mvaddch

    call refresh

    mov rdi, r13
    call usleep

    add r15, 1
    mov rdi, r15
    mov rsi, r14
    mov rdx, "-"
    call mvaddch

    call refresh

    mov rdi, r13
    call usleep

    draw2:
        speed_and_exit_program2:
            call getch

            cmp rax, 103
            je exit_program

            cmp rax, 97
            jne no_speed2
            sub r13, 15000

        no_speed2:
        add r14, 1

        mov rdi, r15
        mov rsi, r14
        mov rdx, "-"
        call mvaddch

        call refresh

        mov rdi, r13
        call usleep

        cmp r14, 50
        jne draw2

    add r15, 1
    cmp r15, 6
    jge restart1

    jmp draw1

    exit_program:
        call endwin
        mov rax, 60
        mov rdi, 0
        syscall
