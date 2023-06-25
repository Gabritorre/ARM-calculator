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
		if(c == 44 || c == 46){
			return false;
		}
	}
	return true;
}

int covert_to_RPN(char* expr) {
	char new_expr[EXPR_SIZE];
	char stack[50];
	int expr_index = 0;
	int s_index = 0;
	for(int i = 0; i < EXPR_SIZE; i++) {
		char c = expr[i];
		if(c >= '0' && c <= '9') {
			new_expr[expr_index] = c;
			expr_index += 1;
		}
		else if(c == '(') {
			s_index += 1;
			stack[s_index] = c;
		}
		else if(c == ')') {
			c = stack[s_index];
			s_index -= 1;
			while(c != '(' && s_index >= 0) {
				new_expr[expr_index] = c;
				expr_index += 1;
				c = stack[s_index];
				s_index -= 1;
			}
			if(c != '(') {
				printf("parentesi non bilanciate\n");
				return -1;
			}
		}
		else {
			while(true){	//bisogna fare qualcosa per sto ciclo
				char stack_top = stack[s_index];
				if(stack_top == '+' || stack_top == '-' || stack_top == '(') {
					if(c == '*' || c == '/') {
						s_index += 1;
						stack[s_index] = c;
					}
					else {
						//ci va lo stesso codice che c'è nell'if sotto
					}
				}
				else {
					if( c == '*' || c == '\') {
						new_expr[expr_index] = stack[s_index];
						s_index -= 1;
						expr_index += 1;
					}
				}
			}
		}
	}


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
