main: main.o stable.o error.o
	gcc -o main main.o stable.o error.o -std=c99

main.o: main.c
	gcc -o main.o -c main.c -std=c99

stable.o: stable.c
	gcc -o stable.o -c stable.c -std=c99

teste: teste.o buffer.o error.o
	gcc -o teste teste.o buffer.o error.o -std=c99

teste.o: teste.c
	gcc -o teste.o -c teste.c -std=c99

buffer.o: buffer.c 
	gcc -o buffer.o -c buffer.c -std=c99

error.o: error.c
	gcc -o error.o -c error.c -std=c99

clean:
	rm -rf *.o