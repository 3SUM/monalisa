# Make file for word ladder assignment.

OBJS	= main.o sortAlgorithms.o
CC	= g++ -g -Wall -pedantic -std=c++11
DEPS	= sortAlgorithms.h

all: main

main: main.o sortAlgorithms.o $(DEPS)
	$(CC) -o main $(OBJS)

main.o: main.cpp $(DEPS)
	$(CC) -c main.cpp

sortAlgorithms.o: sortAlgorithms.cpp $(DEPS)
	$(CC) -c sortAlgorithms.cpp

# -----
# clean by removing object files.

clean:
	rm	$(OBJS)

