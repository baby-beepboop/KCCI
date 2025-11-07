// 미니 정렬 프로그램
#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>

void swap(double *pa, double *pb) {
	double temp;

	temp = *pa;
	*pa = *pb;
	*pb = temp;
}

void lineUp(double *maxp, double *midp, double *minp) {
	if (*maxp - *midp < 0) {
		swap(maxp, midp);
	}
	if (*maxp - *minp < 0) {
		swap(maxp, minp);
	}
	if (*midp - *minp < 0) {
		swap(midp, minp);
	}
}

int main() {
	double max, mid, min;

	printf("실수값 3개 입력: ");
	scanf("%lf %lf %lf", &max, &mid, &min);

	lineUp(&max, &mid, &min);
	printf("정렬된 값 출력: %.1lf, %.1lf, %.1lf\n", max, mid, min);

	return 0;
}
