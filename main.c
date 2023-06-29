#include <stdio.h>
#include <stdbool.h>

#define EXPR_SIZE 64

// take in input the expression in RPN notation and an integet to check if the function encountered an error
extern long calculate(char*, int*);
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
	printf("Insert the expression\n\tmax size %d\n\tallowed characters: 123456789()+-*/\n--> ", EXPR_SIZE);
	fgets(expression, sizeof(expression), stdin);
	expression[EXPR_SIZE-1] = 10;
	long result = 0;
	char expression_rpn[EXPR_SIZE*2] = {0};
	if(check_expr_validity(expression)) {
		if(-1 == convert_to_RPN(expression, expression_rpn)) {
			printf("Conversion Error: the input expression is not valid\n");
		}
		else {
			//printf("RPN expression: %s\n", expression_rpn);
			int error = 0;
			result = calculate(expression_rpn, &error);
			if(error == 1){
				printf("Computation Error: the input expression is not valid\n");
			}
			else{
				printf("Result: %ld\n", result);
			}
		}
	}
	else {
		printf("Error: unknown character found in the input expression\n");
	}
}
