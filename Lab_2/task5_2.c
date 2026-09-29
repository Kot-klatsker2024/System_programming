// Самостоятельное определение системного вызова через встроенный ассемблер GCC
long syscall(long number, long arg1, long arg2, long arg3) {
    long ret;
    // Передаем параметры в регистры x86_64, как этого требует ядро Linux
    __asm__ volatile (
        "movq %1, %%rax\n\t"  // Номер системного вызова в RAX
        "movq %2, %%rdi\n\t"  // Дескриптор (stdout) в RDI
        "movq %3, %%rsi\n\t"  // Адрес буфера в RSI
        "movq %4, %%rdx\n\t"  // Длина буфера в RDX
        "syscall\n\t"
        "movq %%rax, %0\n\t"  // Сохраняем результат
        : "=r" (ret)
        : "g" (number), "g" (arg1), "g" (arg2), "g" (arg3)
        : "rax", "rdi", "rsi", "rdx", "rcx", "r11", "memory"
    );
    return ret;
}

void _start() {
    char N[] = "1019734634";
    int sum = 0;

    for (int i = 0; i < 10; i++) {
        sum += (N[i] - 48);
    }

    char result[3];
    result[0] = (sum / 10) + 48;
    result[1] = (sum % 10) + 48;
    result[2] = 0xA;

    // Вызываем наш собственный syscall
    // 1 — это номер sys_write, 1 — дескриптор stdout
    syscall(1, 1, (long)result, 3);

    // 60 — это номер sys_exit, 0 — код возврата
    syscall(60, 0, 0, 0);
}
