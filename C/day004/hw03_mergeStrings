// 2개의 문자열을 합치기
#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <string.h>

void merge(char *out, char *s1, char *s2) {
	strcpy(out, s1);
	out[strlen(out) - 1] = '\0';
	
	strcat(out, s2);
	/*
	char *p_out = 0, *p_s2 = 0;

	*p_out = out;
	*p_s2 = s2;

	while (*p_out) {
		p_out++;
	}
	while (*p_s2) {
		*(p_out++) = *(p_s2++);
	}

	*p_out = '\0';
	*/
}

int main() {
	char str1[80], str2[80];
	char outBuff[200];

	printf("Enter first string: ");
	fgets(str1, 80, stdin);
	printf("Enter second string: ");
	fgets(str2, 80, stdin);

	merge(outBuff, str1, str2);
	printf("Combined string: %s\n", outBuff);

	return 0;
}
