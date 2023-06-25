all: main.o compute.o
	clang main.o compute.o -o prog

main.o: main.c
	clang -Wall -c main.c -o main.o

compute.o: compute.s
	clang --target=aarch64-elf -Wall -c compute.s -o compute.o

clean:
	rm *.o

#ld.lld -nostdlib main.o -o prog
