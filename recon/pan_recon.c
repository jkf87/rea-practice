// 03의 의사코드만 보고 다시 쓴 코드. 원본 소스(native/pan.c)는 보지 않았다는 가정.
// 0x27f = 639, 0x668f6d / 2^32 ≈ 1/639 → (x * 200) / 639 를 곱셈으로 바꾼 것.
#include <stdio.h>
#include <stdlib.h>

int position_to_pan(int x) {
    if (x < 0) x = 0;
    if (x > 639) x = 639;
    return x * 200 / 639 - 100;
}

int main(int argc, char **argv) {
    int x = argc > 1 ? atoi(argv[1]) : 320;
    printf("x=%d pan=%d\n", x, position_to_pan(x));
    return 0;
}
