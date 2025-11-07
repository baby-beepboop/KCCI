// 대소문자 변환 프로그램
#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>

int main() {
	char sentence[80];
	int cnt = 0;

	printf("문장 입력: ");
	fgets(sentence, sizeof(sentence), stdin);

	for (int i = 0; sentence[i] != '\0'; i++) {
		if (sentence[i] >= 'A' && sentence[i] <= 'Z') {
			sentence[i] = sentence[i] + 32;
			cnt++;
		}
	}

	printf("바뀐 문장: %s", sentence);
	printf("바뀐 문자 수: %d\n", cnt);

	return 0;
}
