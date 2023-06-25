all: main.o compute.o
	clang main.o compute.o -o prog

main.o: main.c
	clang -Wall -c -g main.c -o main.o

compute.o: compute.s
	clang --target=aarch64-elf -Wall -g -c compute.s -o compute.o

ass:
	clang --target=aarch64-elf -Wall -g -c compute.s -o compute.o
	ld.lld -nostdlib compute.o -o prog

clean:
	rm *.o

#ld.lld -nostdlib main.o -o prog
