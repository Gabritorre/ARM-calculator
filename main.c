#include <stdio.h>
#include <stdbool.h>

#define EXPR_SIZE 50
//1..9
//() +-*/ <space>

extern long calculate(char*);
extern int convert_to_RPN(char*, char*);

//check the validity of the symbols used inside the expression
bool check_expr_validity(char* expr) {
	for (int i = 0; expr[i] != 10 &&  expr[i] != 0; i++) {
		char c = expr[i];
		if ((c < 40 || c > 57) && c != 32) {
			return false;
		}
		if(c == 44 || c == 46){
			return false;
		}
	}
	return true;
}


int main() {
	char expression[EXPR_SIZE] = {0};
	fgets(expression, sizeof(expression), stdin);
	expression[EXPR_SIZE-1] = 10;
	printf("expression: %s\n", expression);
	printf("valid? %d\n", check_expr_validity(expression));
	long result = 0;
	char expression_rpn[EXPR_SIZE] = {0};
	if(check_expr_validity(expression)) {
		if(-1 == convert_to_RPN(expression, expression_rpn)) {
			printf("error: the input expression is not valid\n");
		}
		else {

			printf("RPN expression: %s\n", expression_rpn);
			result = calculate(expression_rpn);
			printf("result: %ld\n", result);
		}
	}
	else {
		printf("Error: unknown character found in the input expression\n");
	}


	return 0;
}
