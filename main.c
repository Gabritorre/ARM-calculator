#include <stdio.h>
#include <stdbool.h>

#define EXPR_SIZE 50
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

int convert_to_RPN(char* expr) {
	char new_expr[EXPR_SIZE];
	for(int i = 0; i < EXPR_SIZE; i++) {
		new_expr[i] = 0;
	}
	char stack[50];
	int expr_index = 0;
	int s_index = 0;
	for(int i = 0; i < EXPR_SIZE; i++) {
		char c = expr[i];
		if(c == '\n') {
			break;
		}
		else if(c >= '0' && c <= '9') {
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
			if(s_index == 0) {
				printf("push di %c\n", c);
				s_index++;
				stack[s_index] = c;
			}
			else{
				while(true){
					char stack_top = stack[s_index];
					if(stack_top == '(') {
						break;
					}
					if(stack_top == '+' || stack_top == '-') {
						printf("comparo %c con %c\n", stack_top, c);
						if (c == '+' || c == '-') {
							printf("pop di %c\n", stack_top);
							new_expr[expr_index] = stack[s_index];
							s_index -= 1;
							expr_index += 1;
							if(s_index == 0) {
								printf("breakko\n");
								break;
							}
							else continue;
						}
						else {
							break;
						}

					}
					else {
						new_expr[expr_index] = stack[s_index];
						s_index -= 1;
						expr_index += 1;
						if(s_index == 0) {
							break;
						}
						else continue;
					}
				}
				printf("push di %c\n", c);
				s_index++;
				stack[s_index] = c;
			}
		}
	}
	while(s_index > 0) {
		new_expr[expr_index] = stack[s_index];
		s_index -= 1;
		expr_index += 1;
	}
	printf("conversione: %s\n", new_expr);
	return 1;


}

int main() {
	char expression[EXPR_SIZE];
	fgets(expression, sizeof(expression), stdin);
	expression[EXPR_SIZE-1] = 10;
	printf("expression: %s\n", expression);
	printf("valid? %d\n", check_expr_validity(expression));
	long result = 0;
	convert_to_RPN(expression);
/*	if(check_expr_validity(expression)){*/
/*		result = calculate(expression);*/
/*	}*/
/*	printf("result: %ld\n", result);*/

	return 0;
}
