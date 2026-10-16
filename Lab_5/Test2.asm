format ELF64
public _start

section '.text' executable
_start:
    ; 1. Проверяем аргументы командной строки
    mov rcx, [rsp]         ; rcx = argc (количество аргументов)
    cmp rcx, 4             ; Должно быть минимум 4 (./prog, file_in, file_out, k)
    jl exit_error

    ; 2. Парсим число k из строки (аргумент 3)
    mov rsi, [rsp + 32]    ; rsi = указатель на строку с числом k
    xor r12, r12           ; r12 будет хранить итоговое число k
parse_k_loop:
    movzx rax, byte [rsi]  ; Читаем текущий символ строки
    test al, al            ; Проверяем на конец строки (нуль-терминатор)
    jz parse_k_done
    cmp al, '0'            ; Проверка на валидность символа
    jl exit_error
    cmp al, '9'
    jg exit_error

    sub al, '0'            ; Переводим ASCII символ в цифру
    imul r12, 10           ; Умножаем текущий результат на 10
    add r12, rax           ; Добавляем новую цифру
    inc rsi                ; Переходим к следующему символу
    jmp parse_k_loop
parse_k_done:
    test r12, r12          ; k не должно быть равно 0
    jz exit_error

    ; 3. Открываем входной файл (аргумент 1)
    mov rax, 2             ; sys_open
    mov rdi, [rsp + 16]    ; имя входного файла
    xor rsi, rsi           ; O_RDONLY = 0
    syscall
    test rax, rax          ; Проверка на ошибку
    js exit_error
    mov r14, rax           ; r14 = дескриптор входного файла

    ; 4. Открываем/создаем выходной файл (аргумент 2)
    mov rax, 2             ; sys_open
    mov rdi, [rsp + 24]    ; имя выходного файла
    mov rsi, 577           ; O_WRONLY(1) | O_CREAT(64) | O_TRUNC(512) = 577
    mov rdx, 0644q         ; Права доступа rw-r--r--
    syscall
    test rax, rax          ; Проверка на ошибку
    js close_in_and_exit
    mov r15, rax           ; r15 = дескриптор выходного файла

    ; Подготовка к основному циклу
    xor r13, r13           ; r13 = текущий "сквозной" счетчик символов (0)
    xor r10, r10           ; r10 = индекс в выходном буфере (out_idx = 0)

read_block:
    ; 5. Читаем блок данных из входного файла
    mov rax, 0             ; sys_read
    mov rdi, r14           ; дескриптор входного файла
    lea rsi, [in_buf]      ; адрес входного буфера
    mov rdx, 4096          ; размер буфера
    syscall
    test rax, rax
    js close_all_and_exit  ; Если ошибка чтения
    jz flush_and_end       ; Если 0 — конец файла (EOF), сбрасываем остатки и выходим

    mov rbp, rax           ; rbp = количество реально прочитанных байт
    xor rbx, rbx           ; rbx = внутренний индекс во входном буфере (in_idx = 0)

process_buffer:
    cmp rbx, rbp           ; Проверяем, не кончился ли входной буфер
    je read_block          ; Если кончился — идем читать следующий блок

    inc r13                ; Увеличиваем сквозной счетчик символов
    cmp r13, r12           ; Проверяем, наступил ли k-й символ
    jne next_char          ; Если нет — пропускаем символ

    ; Если символ k-й: копируем его в выходной буфер
    mov al, [in_buf + rbx]
    mov [out_buf + r10], al
    inc r10                ; Увеличиваем индекс выходного буфера
    xor r13, r13           ; Сбрасываем сквозной счетчик

    ; Проверяем, не заполнился ли выходной буфер
    cmp r10, 4096
    jne next_char

    ; Сбрасываем заполненный выходной буфер на диск
    mov rax, 1             ; sys_write
    mov rdi, r15           ; выходной файл
    lea rsi, [out_buf]
    mov rdx, 4096
    syscall
    xor r10, r10           ; Обнуляем индекс выходного буфера

next_char:
    inc rbx                ; Переходим к следующему символу во входном буфере
    jmp process_buffer

flush_and_end:
    ; Если в выходном буфере остались недозаписанные данные — пишем их
    test r10, r10
    jz close_all_and_exit
    mov rax, 1             ; sys_write
    mov rdi, r15
    lea rsi, [out_buf]
    mov rdx, r10           ; Записываем ровно столько байт, сколько осталось
    syscall

close_all_and_exit:
    ; Закрываем выходной файл
    mov rax, 3             ; sys_close
    mov rdi, r15
    syscall

close_in_and_exit:
    ; Закрываем входной файл
    mov rax, 3             ; sys_close
    mov rdi, r14
    syscall

exit_success:
    mov rax, 60            ; sys_exit
    xor rdi, rdi           ; код возврата 0
    syscall

exit_error:
    mov rax, 60            ; sys_exit
    mov rdi, 1             ; код возврата 1 (ошибка)
    syscall

section '.bss' writeable
    in_buf  rb 4096        ; Буфер для чтения
    out_buf rb 4096        ; Буфер для записи
