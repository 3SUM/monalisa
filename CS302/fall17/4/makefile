# Make file for maze generator assignment.

CC	= g++ -Wall -pedantic -std=c++11 -g
DEPS	= linkedQueue.h linkedStack.h

all: main testDS

main: main.o $(DEPS)
	$(CC) -o main main.o

main.o: main.cpp $(DEPS)
	$(CC) -c main.cpp


testDS: testDS.o $(DEPS)
	$(CC) -o testDS testDS.o

testDS.o: testDS.cpp $(DEPS)
	$(CC) -c testDS.cpp


# -----
# clean by removing object files.

clean:
	rm	$(OBJS)

