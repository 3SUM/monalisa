# Luis Maya
# CS 302 Assignment #09
# Make file for disjointSets project

OBJS 	= testDS.o disjointSets.o
OBJS1	= connect.o sensorNetwork.o disjointSets.o
CC		= g++ -Wall -pedantic -g -std=c++11
DEPS	= disjointSets.h
DEPS1	= sensorNetwork.h disjointSets.h

all: testDS connect

testDS: testDS.cpp $(OBJS)
	$(CC) -o testDS $(OBJS)

testDS.o: testDS.cpp $(DEPS)
	$(CC) -c testDS.cpp

disjointSets.o: disjointSets.cpp $(DEPS)
	$(CC) -c disjointSets.cpp


connect: connect.cpp $(OBJS1)
	$(CC) -o connect $(OBJS1)

connect.o: connect.cpp $(DEPS1)
	$(CC) -c connect.cpp

sensorNetwork.o: sensorNetwork.cpp disjointSets.cpp $(DEPS1)
	$(CC) -c sensorNetwork.cpp

# -----
# clean by removing object files.

clean:
	rm	$(OBJS1) testDS.o
