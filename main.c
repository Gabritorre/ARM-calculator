#include <stdio.h>
#include <stdbool.h>

#define EXPR_SIZE 10
//1..9
//() +-*/ <space>

extern long calculate(char*);

//check the validity of the symbols used inside the expression
bool check_expr_validity(char* expr) {
	for (int i = 0; expr[i] != 10 &&  expr[i] != 0; i++) {
		char c = expr[i];
		if ((c < 40 || c > 57) && c != 32) {
			return false;
		}
	}
	return true;
}

int main() {
	char expression[EXPR_SIZE];
	fgets(expression, sizeof(expression), stdin);
	expression[EXPR_SIZE-1] = 10;
	printf("expression: %s\n", expression);
	printf("valid? %d\n", check_expr_validity(expression));
	long result = 0;
	if(check_expr_validity(expression)){
		result = calculate(expression);
	}
	printf("result: %ld\n", result);

	return 0;
}
