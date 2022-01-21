# CS 302 Assignment #5

CC		= g++ -Wall -pedantic -g -std=c++11
DEPS	= binTree.hpp

all: Assignment05 DeepCopy

DeepCopy.o: DeepCopy.cpp $(DEPS)
	$(CC) -c DeepCopy.cpp

DeepCopy: DeepCopy.o $(DEPS)
	$(CC) -o DeepCopy DeepCopy.o


Assignment05.o: Assignment05.cpp $(DEPS)
	$(CC) -c Assignment05.cpp

Assignment05: Assignment05.o $(DEPS)
	$(CC) -o Assignment05 Assignment05.o

# -----
# clean by removing object files.

clean:
	rm	Assignment05.o DeepCopy.o

