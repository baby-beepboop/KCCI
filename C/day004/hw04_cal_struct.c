// 자료구조 - stack을 활용한 계산기 프로그램
#include <stdio.h>
#include <string.h>

#define MAX_LEN 100
#define MAX_STACK 100
#define MAX_TOKENS 100

typedef enum {
	NUM, OP
} TokenType;

typedef struct {
	TokenType type;
	int val;
	char op;
} Token;

// 괄호 짝 검사
int chkParenMatch(const char *exp) {
	int openStack[MAX_STACK];
	int openTop = -1;

	int unmatchedClose[MAX_STACK];
	int unmatchedCloseCnt = 0;

	for (int i = 0; (exp[i] != '\0') && (i < MAX_LEN); i++) {
		if (exp[i] == '(') {
			if (openTop < MAX_STACK - 1) {    // 스택이 비어있는지 확인
				openTop++;					            // 스택의 맨 위에 자리를 만들고
				openStack[openTop] = i;		      // '(' 푸시(저장)
			}
			else {							              // 스택 오버플로우
				printf("Error: Parenthesis stack overflow (Input length limit)\n");
				return 1;
			}
		}

		else if (exp[i] == ')') {
			if (openTop >= 0) {								            // 스택에 여는 괄호가 있는지 확인
				openTop--;									                // 정상적으로 팝
			}
			else {
				if (unmatchedCloseCnt < MAX_STACK) {
					unmatchedClose[unmatchedCloseCnt] = i;    // 짝이 없는 ')' 저장
					unmatchedCloseCnt++;
				}
			}
		}
	}

	if ((unmatchedCloseCnt > 0) || (openTop >= 0)) {
		return unmatchedCloseCnt + (openTop + 1);
	}

	return 0;
}

// 파싱(구문 분석)
int parseExpression(const char *expr, Token tokens[], int *tokenCnt) {
	int cnt = 0;
	int i = 0;
	
	for (int i = 0; expr[i] != '\0'; i++) {
		if (expr[i] == ' ') continue;    // 공백 무시

		// 숫자
		if ('0' <= expr[i] && expr[i] <= '9') {
			int num = 0;

			while (('0' <= expr[i]) && (expr[i] <= '9')) {
				num = num * 10 + (expr[i] - '0');			          // 문자 -> 숫자 변환
				i++;
			}

			tokens[cnt].type = NUM;
			tokens[cnt].val = num;
			
			cnt++;
			i--;
		}

		// 연산자 및 괄호
		else if (strchr("+-*/()", expr[i]) != NULL) {
			tokens[cnt].type = OP;
			tokens[cnt].op = expr[i];
			
			cnt++;
		}

		else {
			printf("ERROR: Invalid character '%c'\n", expr[i]);
			return 1;
		}

		if (cnt >= MAX_TOKENS) {
			printf("ERROR: Too many tokens\n");
			return 1;
		}
	}

	*tokenCnt = cnt;

	return 0;
}

// 연산자 우선순위
int opPrecedence(char op) {
	if (op == '+' || op == '-') return 1;
	if (op == '*' || op == '/') return 2;

	return 0;
}

// 후위 표기법 변환
int toPostfix(Token infix[], int infixCnt, Token postfix[], int *postfixCnt) {
	char opStack[MAX_STACK];
	int top = -1;
	int cnt = 0;

	for (int i = 0; i < infixCnt; i++) {
		// 숫자
		if (infix[i].type == NUM) {
			postfix[cnt] = infix[i];
			cnt++;
		}

		// 연산자 및 괄호
		else if (infix[i].type == OP) {
			char op = infix[i].op;

			// 괄호
			if (op == '(') {
				if (top >= MAX_STACK - 1) {
					printf("ERROR: Operator stack overflow\n");
					return 1;
				}

				top++;
				opStack[top] = op;								               // 스택에 '(' 푸시
			}
			else if (op == ')') {
				while ((top >= 0) && (opStack[top] != '(')) {    // 스택의 top이 '(' 나올 때까지 ')' 팝
					postfix[cnt].type = OP;
					postfix[cnt].op = opStack[top];
					top--;
					cnt++;
				}

				if (top < 0) {
					printf("ERROR: Mismatched parenthesis\n");
					return 1;
				}

				top--;											                     // '(' 제거
			}

			// 연산자
			else {
				while ((top >= 0) && (opPrecedence(opStack[top]) >= opPrecedence(op))) {    // 스택 top의 연산자 우선순위가 현재 연산자보다 높거나 같을 때
					postfix[cnt].type = OP;
					postfix[cnt].op = opStack[top];											                      // 팝
					top--;
					cnt++;
				}

				top++;
				opStack[top] = op;															                            // 우선순위가 낮아지면 현재 연산자 푸시
			}
		}
	}

	while (top >= 0) {
		postfix[cnt].type = OP;
		postfix[cnt].op = opStack[top];
		top--;
		cnt++;
	}

	*postfixCnt = cnt;

	return 0;
}

// 후위 표기식 계산
int evalPostfix(Token postfix[], int postfixCnt, int *res) {
	int stack[MAX_STACK];
	int top = -1;

	for (int i = 0; i < postfixCnt; i++) {
		if (postfix[i].type == NUM) {
			top++;
			stack[top] = postfix[i].val;
		}

		else if (postfix[i].type == OP) {
			if (top < 1) {
				printf("ERROR: Not enough operands\n");
				return 1;
			}

			int b = stack[top];
			top--;
			int a = stack[top];
			top--;
			int result = 0;

			switch (postfix[i].op) {
				case '+': result = a + b; break;
				case '-': result = a - b; break;
				case '*': result = a * b; break;
				case '/':
					if (b == 0) {
						printf("ERROR: Division by zero\n");
						return 1;
					}

					result = a / b; break;
				default:
					printf("ERROR: Unknown operator '%c'\n", postfix[i].op);
					return 1;
			}
			
			top++;
			stack[top] = result;
		}
	}

	if (top != 0) {
		printf("ERROR: Stack not empty after evaluation\n");
		return 1;
	}

	*res = stack[top];
	
	return 0;
}

int main() {
	char inbuff[MAX_LEN];

	printf("=== Calculator Program ===\n");

	while (1) {
		while (1) {
			printf("Enter expression: ");
			if (fgets(inbuff, sizeof(inbuff), stdin) == NULL) {
				printf("Input Error!\n");
				return 1;
			}

			// fgets의 '\n' 제거
			size_t len = strlen(inbuff);				         // size_t: 크기나 길이를 나타내는 정수형 데이터 타입
			if (len > 0 && inbuff[len - 1] == '\n') {
				inbuff[len - 1] = '\0';
			}

			int parenErr = chkParenMatch(inbuff);
			if (parenErr == 0) break;
			else {
				printf("%d parenthesis errors found, please re-enter.\n\n", parenErr);
			}
		}

		if (strchr(inbuff, '=') != NULL) break;    // strchr: 문자열 안에서 특정 문자를 찾는 함수
	}
	
	// 수식의 '=' 제거
	char *eq = strchr(inbuff, '=');
	if (eq) {
		*eq = '\0';
	}
	//printf("계산할 수식: %s\n", inbuff);

	// 파싱
	Token tokens[MAX_TOKENS];
	int tokenCnt = 0;

	if (parseExpression(inbuff, tokens, &tokenCnt) != 0) {
		printf("Parsing error!\n");
		return 1;
	}

	/*
	printf("파싱된 토큰: ");
	for (int i = 0; i < tokenCnt; i++) {
		if (tokens[i].type == NUM) {
			printf("NUM %d ", tokens[i].val);
		}
		else {
			printf("OP %c ", tokens[i].op);
		}
	}
	printf("\n");
	*/

	// 후위 표기법 변환
	Token postfix[MAX_TOKENS];
	int postfixCnt = 0;

	if (toPostfix(tokens, tokenCnt, postfix, &postfixCnt) != 0) {
		printf("Postfix conversion error!\n");
		return 1;
	}

	/*
	printf("후위 표기식: ");
	for (int i = 0; i < postfixCnt; i++) {
		if (postfix[i].type == NUM) {
			printf("%d ", postfix[i].val);
		}
		else {
			printf("%c ", postfix[i].op);
		}
	}
	printf("\n");
	*/

	// 후위 표기식 계산
	int res;

	if (evalPostfix(postfix, postfixCnt, &res) != 0) {
		printf("Evaluation Error!\n");
		return 1;
	}

	printf("--------------------------\n");
	printf("%s= %d\n", inbuff, res);

	return 0;
}
