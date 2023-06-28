all: main.o compute.o RPN_converter.o
	clang main.o compute.o RPN_converter.o -o prog

main.o: main.c
	clang -Wall -c -g main.c -o main.o

compute.o: compute.s
	clang --target=aarch64-elf -Wall -g -c compute.s -o compute.o

RPN_converter.o: RPN_converter.s
	clang --target=aarch64-elf -Wall -g -c RPN_converter.s -o RPN_converter.o

clean:
	rm *.o



# for testing:
compute:
	clang --target=aarch64-elf -Wall -g -c compute.s -o compute.o
	ld.lld -nostdlib compute.o -o prog

convert:
	clang --target=aarch64-elf -Wall -g -c RPN_converter.s -o RPN_converter.o
	ld.lld -nostdlib RPN_converter.o -o prog


