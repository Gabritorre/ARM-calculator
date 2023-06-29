	.text
	.p2align 2

	.global calculate

calculate:


	mov x3, #0	//count how many digits have the number
	mov x7, #0	//count how many numbers there are in the stack
parse_expr:
	ldrb w10, [x0]		//get a character
	cmp w10, #10		//if the character is a new line
	b.eq exit

	add x0, x0, #1		//point to the next character
	cmp w10, #32		//if the character is a space
	b.eq end_number
	cmp w10, #'0'		//if the character is a operator
	b.lt operator
	add x2, x10, #-48	//string to decimal value
	str x2, [sp, #-16]!	//store the decimal value in the stack
	add x3, x3, #1		//increment the digits counter
	b parse_expr

end_number:
	cmp x3, #0
	b.eq parse_expr
	mov x4, #1	//motiplier factor
	mov x11, #0
compose_number:
	ldr x2, [sp], #16	//get the digit from te stack
	mul x2, x2, x4		//multiply the digit by the moltiplicator factor
	add x11, x11, x2	// add to product to the partial result
	mov x6, #10			//temp register that contain the value 10 in order to do the moltiplication
	mul x4, x4, x6		//multiply the moltiplier factor by 10
	add x3, x3, #-1		//decrement the counter
	cmp x3, #0
	b.ne compose_number

push_number_stack:	//insert the final number in the stack
	str x11, [sp, #-16]!
	add x7, x7, #1
	b parse_expr

operator:
	cmp x7, #2
	b.lt error_exit
	ldr x8, [sp], #16		//pop the two operands from the stack
	ldr x9, [sp], #16
	add x7, x7, #-2
	cmp w10, #'+'
	b.eq sum
	cmp w10, #'-'
	b.eq sub
	cmp w10, #'*'
	b.eq mult
	cmp w10, #'/'
	b.eq divi


sum:
	add x12, x8, x9
	str x12, [sp, #-16]!
	add x7, x7, #1
	b parse_expr
sub:
	sub x12, x9, x8
	str x12, [sp, #-16]!
	add x7, x7, #1
	b parse_expr
mult:
	mul x12, x8, x9
	str x12, [sp, #-16]!
	add x7, x7, #1
	b parse_expr
divi:
	sdiv x12, x9, x8
	str x12, [sp, #-16]!
	add x7, x7, #1
	b parse_expr


exit:
	ldr x0, [sp], #16
	add x7, x7, #-1
	cmp x7, #0		//if the stack is not empty there is an error
	b.ne error_exit
	ret

error_exit:
	add sp, sp, x7, lsl #4		//reset the stack to the initial state
	mov x10, #1
	str x10, [x1]
	ret

/*
	.global _start
_start:
	adr x0, str
	adr x1, error
	bl calculate


	mov x0, #1
	mov x8, #93
	svc #0

	.data
	.p2align 2
	.global str
str: .string "1  +\n"
error: .word 1
*/
