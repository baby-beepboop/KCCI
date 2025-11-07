// enum [열거형 이름] {[변수 이름]}: 열거형
#include <stdio.h>

enum dayOfWeek {sun=0, mon, tue, wed, thu, fri, sat};    // 열거형 정의

int main() {
	enum dayOfWeek week;		 // 열거형 변수 선언
	week = tue;							 // 열거형 값 할당
	printf("%d\n", week);    // 출력: 2

	return 0;
}
