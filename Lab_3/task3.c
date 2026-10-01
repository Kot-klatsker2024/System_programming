#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
   
    if (argc < 4) {
        printf("Использование: %s <a> <b> <c>\n", argv[0]);
        return 1;
    }

    int a = atoi(argv[1]);
    int b = atoi(argv[2]);
    int c = atoi(argv[3]);

    if (b == 0 || c == 0) {
        printf("Ошибка: Деление на ноль невозможно!\n");
        return 1;
    }

    int result = (((a / b) + a) / c);

    printf("Результат: %d\n", result);

    return 0;
}
