# Luis Maya
# CS 302 Assignment #10
# Make file for undirectedGraph project

OBJS 	= springfield.o undirectedGraph.o
CC		= g++ -Wall -pedantic -g -std=c++11
DEPS	= undirectedGraph.h priorityQueue.h

all: springfield

springfield: springfield.cpp $(OBJS)
	$(CC) -o springfield $(OBJS)

springfield.o: springfield.cpp $(DEPS)
	$(CC) -c springfield.cpp

undirectedGraph.o: undirectedGraph.cpp $(DEPS)
	$(CC) -c undirectedGraph.cpp

# -----
# clean by removing object files.

clean:
	rm	$(OBJS)
