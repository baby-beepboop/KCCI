// 소수(prime number) 출력 프로그램
#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>

int main() {
	int num;
	int isPrime;
	int count = 0;

	printf("2 이상의 정수를 입력하세요: ");
	scanf("%d", &num);

	for (int i = 2; i <= num; i++) {
		isPrime = 1;

		for (int j = 2; j * j <= i; j++) {
			if (i % j == 0) {
				isPrime = 0;
				break;
			}
		}

		if (isPrime) {
			printf("%2d ", i);
			count++;

			if (count % 5 == 0) {
				printf("\n");
				}
		}
	}

	return 0;
}
