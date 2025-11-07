#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>

int main() {
	int a = 10;									           // 10 = 0xa = 0b0...01010
	int b = 12;									           // 12 = 0xc = 0b0...01100
	printf("a = %d, b = %d\n\n", a, b);

	printf("=== '-' 연산자 사용 결과 ===\n");
	printf("a - b = %d\n\n", a - b);

	int b_twos = ~b + 1;							          // b의 2의 보수 = 0b1...10100
	int sub = a + (-b);

	printf("=== 2의 보수를 이용한 결과 ===\n");

	printf(" a =  10 = 0b");
	for (int i = sizeof(a)*8 - 1; i >= 0; i--) {	       // 31~0비트
		printf("%d", (a >> i) & 1);					               // 2진수 출력
	}
	printf("\n");

	printf("-b = -12 = 0b");
	for (int i = sizeof(b_twos)*8 - 1; i >= 0; i--) {
		printf("%d", (b_twos >> i) & 1);
	}
	printf("\n");

	printf("---------------------------------------------\n");

	printf("a + (-b) = 0b");
	for (int i = sizeof(sub)*8 - 1; i >= 0; i--) {
		printf("%d", (sub >> i) & 1);
	}
	printf(" = %d\n", (a - b));

	return 0;
}
