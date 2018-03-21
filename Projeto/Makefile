all: center freq

center: center.o buffer.o
	gcc -o center center.o buffer.o error.o

freq: freq.o stable.o error.o
	gcc -o freq freq.o stable.o error.o

center.o: center.c
	gcc -o center.o -c center.c -std=c99

freq.o: freq.c
	gcc -o freq.o -c freq.c -std=c99

buffer.o: buffer.c buffer.h error.o
	gcc -o buffer.o -c buffer.c -std=c99

stable.o: stable.c
	gcc -o stable.o -c stable.c -std=c99

error.o: error.c error.h
	gcc -o error.o -c error.c -std=c99

clean:
	rm -rf *.o