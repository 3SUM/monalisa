# Luis Maya
# CS 302 Assignment #11
# Make file for directedGraph project

OBJS 	= maxFlow.o directedGraph.o hashTable.o
CC		= g++ -Wall -pedantic -g -std=c++11 -O3
DEPS	= directedGraph.h linkedQueue.h hashTable.h
DEPS1	= hashTable.h

all: maxFlow

maxFlow: maxFlow.cpp $(OBJS)
	$(CC) -o maxFlow $(OBJS)

maxFlow.o: maxFlow.cpp $(DEPS)
	$(CC) -c maxFlow.cpp

hashTable.o: hashTable.cpp $(DEPS1)
	$(CC) -c hashTable.cpp

directedGraph.o: directedGraph.cpp hashTable.cpp $(DEPS)
	$(CC) -c directedGraph.cpp

# -----
# clean by removing object files.

clean:
	rm	$(OBJS)
