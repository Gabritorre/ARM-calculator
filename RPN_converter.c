
//corresponding of RPN_converter.s made in C
#define EXPR_SIZE 50

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
			new_expr[expr_index] = ' ';
			expr_index += 1;
			while(c != '(' && s_index >= 0) {
				new_expr[expr_index] = c;
				expr_index += 1;
				c = stack[s_index];
				s_index -= 1;
			}
			if(c != '(') {
				return -1;
			}
		}
		else {
			new_expr[expr_index] = 32;
			expr_index += 1;
			if(s_index == 0) {
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
						if (c == '+' || c == '-') {
							new_expr[expr_index] = stack[s_index];
							s_index -= 1;
							expr_index += 1;
							if(s_index == 0) {
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
				s_index++;
				stack[s_index] = c;
			}
		}
	}
	while(s_index > 0) {
		new_expr[expr_index] = ' ';
		expr_index += 1;
		new_expr[expr_index] = stack[s_index];
		s_index -= 1;
		expr_index += 1;
	}
	return 1;
}
