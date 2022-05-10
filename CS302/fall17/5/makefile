# CS 302 Assignment #5
# Make file for product reviews project

OBJS	= reviews.o reviewData.o
CC	= g++ -Wall -pedantic -g -std=c++11
DEPS	= reviewData.h avlTree.h
DEPS1	= avlTree.h

all: reviews avlTest

avlTest.o: avlTest.cpp $(DEPS1)
	$(CC) -c avlTest.cpp

avlTest: avlTest.o $(DEPS1)
	$(CC) -o avlTest avlTest.o


reviews.o: reviews.cpp $(DEPS)
	$(CC) -c reviews.cpp

reviewData.o: reviewData.cpp $(DEPS)
	$(CC) -c reviewData.cpp

reviews: reviews.o reviewData.o $(DEPS)
	$(CC) -o reviews $(OBJS)

# -----
# clean by removing object files.

clean:
	rm	$(OBJS)

