//TODO
// add a space in the output string when encounter a operator


	.text
	.p2align 2

	.global convert_to_RPN
convert_to_RPN:
	mov x2, #0		// counter stack elements

main_loop:	//scan the input string
	ldrb w10, [x0], #1
	cmp w10, #10
	b.eq empty_the_stack	//if the character is '\n' the input string is finished

number:		//check if the character is a number
	cmp w10, #'0'
	b.lt open_bracket
	cmp w10, #'9'
	b.gt open_bracket
	strb w10, [x1], #1
	b main_loop

open_bracket:		//check if the character is an open parenthesis
	cmp w10, #'('
	b.ne close_bracket
	str w10, [sp, #-16]!		//push '(' in the stack
	add x2, x2, #1				//increment the stack counter
	b main_loop

close_bracket:		//check if the character is a close parenthesis
	cmp w10, #')'
	b.ne operators
find_open_bracket:
	ldrb w10, [sp], #16		//pop from the stack
	add x2, x2, #-1		//decrement the stack counter
	cmp w10, #'('
	b.eq main_loop
	strb w10, [x1], #1
	b find_open_bracket


operators:			//check if the character is a operator
	cmp x2, #0
	b.ne loop_priority
	strb w10, [sp, #-16]!		//push operator in the stack
	add x2, x2, #1				//increment the stack counter
	b main_loop

loop_priority:
	ldrb w11, [sp]		//peek to the top of the stack
	cmp w11, #'('
	b.eq push_operator
	cmp w11, #'+'
	b.eq equal_priority
	cmp w11, #'-'
	b.eq equal_priority
	ldrb w11, [sp], #16			//pop from the stack
	add x2, x2, #-1				//decrement the stack counter
	strb w11, [x1], #1
	cmp x2, #0
	b.eq push_operator
	b loop_priority


equal_priority:
	cmp w10, #'*'
	b.eq push_operator
	cmp w10, #'/'
	b.eq push_operator
	ldrb w11, [sp], #16		//pop from the stack
	add x2, x2, #-1			//decrement the stack counter
	strb w11, [x1], #1
	cmp x2, #0			// if the stack is empty quit the loop
	b.eq push_operator
	b loop_priority


push_operator:
	strb w10, [sp, #-16]!		//push operator in the stack
	add x2, x2, #1 				//increment the stack counter
	b main_loop


empty_the_stack:
	cmp x2, #0
	b.eq exit
	ldrb w10, [sp], #16
	add x2, x2, #-1
	strb w10, [x1] , #1
	b empty_the_stack

exit:
	// add \n to the end of the output string
	mov w10, #10
	strb w10, [x1]
	ret

	.global _start
_start:
	adr x0, str
	adr x1, res
	bl convert_to_RPN


	mov x0, #1
	mov x8, #93
	svc #0

	.data
	.p2align 2
	.global str
str: .string "5+(6*(4+1)/2)+(5-1-2-3*(1*3))\n"
res: .string "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
