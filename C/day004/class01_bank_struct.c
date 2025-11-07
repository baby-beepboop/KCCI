#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <string.h>

#define NAME_LEN 20

enum {OPEN = 1, DEPOSIT, WITHDRAW, INQUIRY, EXIT = 9};

typedef struct {
	int num;
	int bal;
	char custName[NAME_LEN];
} AcctInfo;

AcctInfo accts[100];
int acctCnt = 0;

void showMenu() {
	char *menu[] = {"---------- Menu ----------\n",
					"1. Open Account\n",
					"2. Deposit\n",
					"3. Withdraw\n",
					"4. Print All Account Info\n",
					"9. Exit\n"};

	printf("\n");

	for (int i = 0; i < 6; i++) {
		printf("%s", *(menu + i));
	}
	
	printf("\n");
}

void open() {
	int id;
	char name[NAME_LEN];
	int depAmt;

	printf("\n------ Open Account ------\n");

	printf("Account Number: ");
	scanf("%d", &id);
	printf("Name: ");
	scanf("%s", &name);
	printf("Deposit Amount: ");
	scanf("%d", &depAmt);
	printf("\n");

	accts[acctCnt].num = id;
	accts[acctCnt].bal = depAmt;
	strcpy(accts[acctCnt].custName, name);
	acctCnt++;
}

void deposit() {
	int amt, id;

	printf("\n-------- Deposit --------\n");

	printf("Account Number: ");
	scanf("%d", &id);
	printf("Deposit Amount: ");
	scanf("%d", &amt);

	for (int i = 0; i < acctCnt; i++) {
		if (accts[i].num == id) {
			accts[i].bal = accts[i].bal + amt;
			printf("\nDeposit Complete\n\n");
			return;
		}
	}

	printf("\nInvalid account number.\n\n");
}

void withdraw() {
	int amt, id;

	printf("\n-------- Withdraw --------\n");

	printf("Account Number: ");
	scanf("%d", &id);
	printf("Withdrawal Amount: ");
	scanf("%d", &amt);

	for (int i = 0; i < acctCnt; i++) {
		if (accts[i].num == id) {
			if (accts[i].bal < amt) {
				printf("\nInsufficient balance.\n\n");
				return;
			}

			accts[i].bal = accts[i].bal - amt;
			printf("\nWithdrawal Complete\n\n");
			return;
		}
	}

	printf("\nInvalid account number.\n\n");
}

void balInquiry() {
	printf("\n---- All Account Info ----\n");

	for (int i = 0; i < acctCnt; i++) {
		printf("Account Number: %d\n", accts[i].num);
		printf("Name: %s\n", accts[i].custName);
		printf("Balance: %d\n\n", accts[i].bal);
	}
}

int main() {
	int sel;

	while (1) {
		showMenu();
		printf("Select an option: ");
		scanf("%d", &sel);

		switch (sel) {
			case OPEN:
				open(); break;
			case DEPOSIT:
				deposit(); break;
			case WITHDRAW:
				withdraw(); break;
			case INQUIRY:
				balInquiry(); break;
			case EXIT:
				return 0;
			default:
				printf("Please select again.\n");
		}
	}

	return 0;
}
