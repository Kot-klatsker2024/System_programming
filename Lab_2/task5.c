#include <stdio.h>

int main() {
    char N[] = "1019734634";
    int sum = 0;

    for (int i = 0; i < 10; i++) {
        sum += (N[i] - '0');
    }

    printf("%d\n", sum);
    return 0;
}

