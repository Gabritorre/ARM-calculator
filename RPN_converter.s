
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
	mov w12, #32
	strb w12,[x1], #1		// add a space before the operators to the output string
find_open_bracket:
	cmp x2, #0	//if the stack is empty then quit with an error
	b.eq error_exit

	ldrb w10, [sp], #16		//pop from the stack
	add x2, x2, #-1		//decrement the stack counter
	cmp w10, #'('
	b.eq main_loop
	strb w10, [x1], #1
	b find_open_bracket


operators:			//check if the character is a operator
	mov w11, #32	//if the character is a operator add a space in the output string
	strb w11, [x1], #1
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
	cmp w10, #'('
	b.eq error_exit
	mov w12, #32		//add a space before the operator
	strb w12, [x1], #1
	strb w10, [x1] , #1
	b empty_the_stack

exit:
	//ad a space in the output string (fundamental when the expression is only a number)
	mov w10, #32
	strb w10, [x1], #1
	// add \n to the end of the output string
	mov w10, #10
	strb w10, [x1]
	mov w0, #0
	ret

error_exit:		//if the parenthesis are not balanced return -1
	add sp, sp, x2, lsl #4		//reset the stack pointer to the initial state
	mov w0, #-1
	ret

/*
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
str: .string "1+(4-2\n"
res: .string "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

*/
