# Luis Maya
# CS302 Section #1002
# Assignment #06
# Makefile for happyNums

CC	= g++ -Wall -pedantic -std=c++11 -pthread

all: happyNums

happyNums.o: happyNums.cpp
	$(CC) -c happyNums.cpp

happyNums: happyNums.o
	$(CC) -o happyNums happyNums.o

# -----
# clean by removing object files.

clean:
	rm happyNums.o happyNums
