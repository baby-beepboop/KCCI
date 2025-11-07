// 은행 (함수 포인터 배열, 구조체 동적 메모리 할당 활용)
#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <stdlib.h>
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

	AcctInfo *acct = accts + *acctCnt;
	acct->num = id;						       // acct->num == (*acct).num
	acct->bal = depAmt;
	strcpy(acct->custName, name);

	(*acctCnt)++;
}

void deposit(AcctInfo *accts, int *acctCnt) {
	int amt, id;

	printf("\n-------- Deposit --------\n");

	printf("Account Number: ");
	scanf("%d", &id);
	printf("Deposit Amount: ");
	scanf("%d", &amt);

	AcctInfo *acct = accts;
	for (int i = 0; i < acctCnt; i++) {
		//AcctInfo* acct = &accts[i];

		if (acct->num == id) {
			acct->bal = acct->bal + amt;

			printf("\nDeposit Complete\n\n");
			return;
		}
	}

	printf("\nInvalid account number.\n\n");
}

void withdraw(AcctInfo *accts, int *acctCnt) {
	int amt, id;

	printf("\n-------- Withdraw --------\n");

	printf("Account Number: ");
	scanf("%d", &id);
	printf("Withdrawal Amount: ");
	scanf("%d", &amt);

	AcctInfo *acct = accts;
	for (int i = 0; i < acctCnt; i++) {
		//AcctInfo *acct = &accts[i];

		if (acct->num == id) {
			if (acct->bal < amt) {
				printf("\nInsufficient balance.\n\n");
				return;
			}

			acct->bal = acct->bal - amt;

			printf("\nWithdrawal Complete\n\n");
			return;
		}
	}

	printf("\nInvalid account number.\n\n");
}

void balInquiry(AcctInfo *accts, int *acctCnt) {
	printf("\n---- All Account Info ----\n");

	AcctInfo *acct = accts;
	for (int i = 0; i < *acctCnt; i++) {
		//AcctInfo *acct = &accts[i];

		printf("Account Number: %d\n", acct->num);
		printf("Name: %s\n", acct->custName);
		printf("Balacne: %d\n\n", acct->bal);
	}
}

int main() {
	//AcctInfo accts[100];
	AcctInfo *p_accts = (AcctInfo *) malloc(sizeof(AcctInfo) * 100);
	/*
	p_accts->num = 666;
	p_accts->bal = 666;
	strcpy(p_accts->custName, "JJANG-MIN");
	printf("*DEBUG*: %d %d %s\n", p_accts->num, p_accts->bal, p_accts->custName);
	*/

	int acctCnt = 0;
	int sel;

	void (*fp_showMenu)();
	void (*fp[])(AcctInfo*, int*) = {NULL, open, deposit, withdraw, balInquiry};

	while (1) {
		fp_showMenu = showMenu;
		fp_showMenu();
		printf("Select an option: ");
		scanf("%d", &sel);

		if ((sel >= 1) && (sel <= 4)) {
			fp[sel](p_accts, &acctCnt);
		}

		else if (sel == 9) {
			free(p_accts);
			return 0;
		}
		
		else {
			printf("Please select again.\n");
		}
	}

	return 0;
}
