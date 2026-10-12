// REA 실습용으로 직접 만든 작은 네이티브 프로그램.
// 공의 x 위치(0~639)를 스테레오 팬 값(-100~100)으로 바꾼다.
#include <stdio.h>
#include <stdlib.h>

int position_to_pan(int x) {
    if (x < 0) x = 0;
    if (x > 639) x = 639;
    return (x * 200) / 639 - 100;
}

int main(int argc, char **argv) {
    int x = argc > 1 ? atoi(argv[1]) : 320;
    printf("x=%d pan=%d\n", x, position_to_pan(x));
    return 0;
}
