	.text
	.p2align 2

	.global calculate

calculate:
	mov x3, #0	//count how many digits have the number
parse_number:
	ldrb w1, [x0]
	cmp x1, #'0'
	b.lt end_number
	cmp x1, #'9'
	b.gt end_number
	add x2, x1, #-48	//string to decimal value
	str x2, [sp, #-16]!	//store the decimal value in the stack
	add x3, x3, #1		//increment the digits counter
	add x0, x0, #1		//go to the next character
	b parse_number

end_number:
	cmp x3, #0
	b.eq exit
	mov x4, #1	//motiplicator factor
compose_number:
	ldr x2, [sp], #16	//get the digit from te stack
	mul x2, x2, x4		//multiply the digit by the moltiplicator factor
	add x10, x10, x2	// add to product to the partial result
	mov x6, #10			//temp register that contain the value 10 in order to do the moltiplication
	mul x4, x4, x6		//multiply the moltiplicator factor by 10
	add x3, x3, #-1		//decrement the counter
	cmp x3, #0
	b.ne compose_number

exit:
	mov x0, x10
	ret



	.global _start
_start:
	adr x0, str
	bl calculate


	mov x0, #1
	mov x8, #93
	svc #0

	.data
	.p2align 2
	.global str
str: .string "123\n"

