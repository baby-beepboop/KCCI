/*
----+----+----+----+----+----+
=== ASCII CODE Table ===
------------------------
  DEC   HEX  OCT  CHAR  
------------------------
    0  0x00  000   NUL  
...
  127  0x7F  177   DEL  
*/
#include <stdio.h>

int main() {
	printf("%20s\n", "========================== ASCII CODE Table ==========================");
	printf("%19s\n", "----------------------------------------------------------------------");
	printf("%5s%6s%6s%5s%6s%6s%5s%6s%6s%5s%6s%6s  \n", "DEC", "HEX", "CHAR", "DEC", "HEX", "CHAR", "DEC", "HEX", "CHAR", "DEC", "HEX", "CHAR");
	printf("%19s\n", "----------------------------------------------------------------------");
	
	const char *asciiChar[] = {"NUL", "SOH", "STX", "ETX", "EOT",
							   "ENQ", "ACK", "BEL", "BS", "HT",
							   "LF", "VT", "FF", "CR", "SO",
							   "SI", "DLE", "DC1", "DC2", "DC3",
							   "DC4", "NAK", "SYN", "ETB", "CAN",
							   "EM", "SUB", "ESC", "FS", "GS",
							   "RS", "US", "SP", "DEL"};

	for (int row = 0; row < 32; row++) {
		for (int col = 0; col < 4; col++) {
			int i = row + col * 32;
			if (i > 127) continue;

			if (i <= 32) {
				printf("%5d%4s%02x%6s", i, "  0x", i, asciiChar[i]);
			}

			else if (i == 127) {
				printf("%5d%4s%02x%6s", i, "  0x", i, asciiChar[33]);
			}

			else {
				printf("%5d%4s%02x%6c", i, "  0x", i, i);
			}
		}

		printf("\n");
	}

	return 0;
}
