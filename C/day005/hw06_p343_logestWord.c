// 길이가 가장 긴 단어 찾기
#include <stdio.h>

int main() {
	char word;
	int len = 0, maxLen = 0;

	while ((word = getchar()) != EOF) {
		if (word == '\n') {
			if (len > maxLen) {
				maxLen = len;
			}
			len = 0;
		}
		else {
			len++;
		}
	}

	printf("가장 긴 단어의 길이: %d\n", maxLen);

	return 0;
}
