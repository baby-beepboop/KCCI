// 문자열 합치기
#define _CRT_SECURE_NO_WARNINGS    // 이거 안쓰면 sprintf 대신 sprintf_s 써야됨
#include <stdio.h>
#include <string.h>

int main() {
	char fruits[3][11] = {"strawberry", "apple", "peach"};
	char like[] = "I like ";
	char merge[100] = "";    // 문자열 초기화

	// sprintf(저장할 변수, "%s%s", 합칠 변수, 합칠 변수): 문자열 변환 함수
	sprintf(merge, "%s%s, %s and %s", like, fruits[0], fruits[1], fruits[2]);
	printf("%s!\n\n", merge);

	// strcat(합칠 변수, 합칠 변수): 문자열 2개 연결 함수
	merge[0] = NULL;    // 값이 있는 문자열 변수 초기화
	strcat(merge, like);
	strcat(merge, fruits[0]);
	printf("%s!\n\n", merge);

	// strcpy(저장할 문자열, 복사할 문자열): 문자열 복사 함수
	strcpy(merge, like);
	strcpy(merge, fruits[1]);
	printf("%s!\n", merge);

	strcpy(merge, like);
	strcat(merge, fruits[1]);
	printf("%s!\n", merge);

	return 0;
}
