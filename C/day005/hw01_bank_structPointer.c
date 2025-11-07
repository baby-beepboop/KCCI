// 은행 (구조체 포인터 활용)
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

void showMenu() {
	char* menu[] = { "---------- Menu ----------\n",
					"1. Open Account\n",
					"2. Deposit\n",
					"3. Withdraw\n",
					"4. Print All Account Info\n",
					"9. Exit\n" };

	printf("\n");

	for (int i = 0; i < 6; i++) {
		printf("%s", *(menu + i));
	}

	printf("\n");
}

void open(AcctInfo *accts, int *acctCnt) {
	int id, depAmt;
	char name[NAME_LEN];

	printf("\n------ Open Account ------\n");

	printf("Account Number: ");
	scanf("%d", &id);
	printf("Name: ");
	scanf("%s", &name);
	printf("Deposit Amount: ");
	scanf("%d", &depAmt);
	printf("\n");

	AcctInfo *acct = &accts[*acctCnt];
	//accts[acctCnt].num = id;
	acct->num = id;
	//accts[acctCnt].bal = depAmt;
	acct->bal = depAmt;
	//strcpy(accts[acctCnt].custName, name);
	strcpy(acct->custName, name);

	(*acctCnt)++;
}

void deposit(AcctInfo *accts, int acctCnt) {
	int amt, id;

	printf("\n-------- Deposit --------\n");

	printf("Account Number: ");
	scanf("%d", &id);
	printf("Deposit Amount: ");
	scanf("%d", &amt);

	for (int i = 0; i < acctCnt; i++) {
		AcctInfo *acct = &accts[i];

		//if (accts[i].num == id) {
		if (acct->num == id) {
			//accts[i].bal = accts[i].bal + amt;
			acct->bal = acct->bal + amt;

			printf("\nDeposit Complete\n\n");
			return;
		}
	}

	printf("\nInvalid account number.\n\n");
}

void withdraw(AcctInfo *accts, int acctCnt) {
	int amt, id;

	printf("\n-------- Withdraw --------\n");

	printf("Account Number: ");
	scanf("%d", &id);
	printf("Withdrawal Amount: ");
	scanf("%d", &amt);

	for (int i = 0; i < acctCnt; i++) {
		AcctInfo *acct = &accts[i];

		//if (accts[i].num == id) {
		if (acct->num == id) {
			//if (accts[i].bal < amt) {
			if (acct->bal < amt) {
				printf("\nInsufficient balance.\n\n");
				return;
			}

			//accts[i].bal = accts[i].bal - amt;
			acct->bal = acct->bal - amt;

			printf("\nWithdrawal Complete\n\n");
			return;
		}
	}

	printf("\nInvalid account number.\n\n");
}

void balInquiry(AcctInfo *accts, int acctCnt) {
	printf("\n---- All Account Info ----\n");

	for (int i = 0; i < acctCnt; i++) {
		AcctInfo *acct = &accts[i];

		//printf("Account Number: %d\n", accts[i].num);
		printf("Account Number: %d\n", acct->num);
		//printf("Name: %s\n", accts[i].custName);
		printf("Name: %s\n", acct->custName);
		//printf("Balance: %d\n\n", accts[i].bal);
		printf("Balacne: %d\n\n", acct->bal);
	}
}

int main() {
	AcctInfo accts[100];
	int acctCnt = 0;
	int sel;

	while (1) {
		showMenu();
		printf("Select an option: ");
		scanf("%d", &sel);

		switch (sel) {
		case OPEN:
			open(accts, &acctCnt); break;
		case DEPOSIT:
			deposit(accts, acctCnt); break;
		case WITHDRAW:
			withdraw(accts, acctCnt); break;
		case INQUIRY:
			balInquiry(accts, acctCnt); break;
		case EXIT:
			return 0;
		default:
			printf("Please select again.\n");
		}
	}

	return 0;
}
