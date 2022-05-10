# Luis Maya
# CS 302 Assignment #07
# Make file for product reviews project

OBJS 	= hashTest.o hashTable.o
OBJS1	= reviews.o reviewData.o hashTable.o
CC		= g++ -Wall -pedantic -g -std=c++11
DEPS	= hashTable.h
DEPS1	= reviewData.h hashTable.h

all: hashTest reviews

hashTest: hashTest.cpp $(OBJS)
	$(CC) -o hashTest $(OBJS)

hashTest.o: hashTest.cpp $(DEPS)
	$(CC) -c hashTest.cpp

hashTable.o: hashTable.cpp $(DEPS)
	$(CC) -c hashTable.cpp


reviews: reviews.cpp $(OBJS1)
	$(CC) -o reviews $(OBJS1)

reviews.o: reviews.cpp $(DEPS1)
	$(CC) -c reviews.cpp

reviewData.o: reviewData.cpp hashTable.cpp $(DEPS1)
	$(CC) -c reviewData.cpp

# -----
# clean by removing object files.

clean:
	rm	$(OBJS1) hashTest.o
