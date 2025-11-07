/* ABCDEFGHIJKLMNOPQRSTUVWXYZ
   BCDEFGHIJKLMNOPQRSTUVWXYZA
   ...
   ZABCDEFGHIJKLMNOPQRSTUVWXY
   ABCDEFGHIJKLMNOPQRSTUVWXYZ */
#include <stdio.h>

int main() {
	char alpha[] = {"ABCDEFGHIJKLMNOPQRSTUVWXYZ"};

	for (int i = 0; i < 26; i++) {
		for (int j = 0; j < 26; j++) {
			printf("%c", alpha[(i + j) % 26]);
		}
		printf("\n");
	}

	return 0;
}
