# Make file for assignment #1.

OBJS	= main.o lis.o
CC	= g++ -g -Wall -pedantic -std=c++11

all: main

main: main.o lis.o lis.h
	$(CC) -o main $(OBJS)

main.o: main.cpp lis.h
	$(CC) -c main.cpp

lis.o: lis.cpp lis.h
	$(CC) -c lis.cpp

# -----
# clean by removing object files.

clean:
	rm	$(OBJS)

