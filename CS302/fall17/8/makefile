# Luis Maya
# CS 302 Assignment #08
# Make file for priorityQueue project

OBJS 	= pqTest.o
OBJS1	= perfect.o
CC		= g++ -Wall -pedantic -g -std=c++11
DEPS	= priorityQueue.h

all: pqTest perfect

pqTest: pqTest.cpp $(OBJS)
	$(CC) -o pqTest $(OBJS)

pqTest.o: pqTest.cpp $(DEPS)
	$(CC) -c pqTest.cpp


perfect: perfect.cpp $(OBJS1)
	$(CC) -o perfect $(OBJS1)

perfect.o: perfect.cpp $(DEPS)
	$(CC) -c perfect.cpp

# -----
# clean by removing object files.

clean:
	rm	$(OBJS) $(OBJS1)
