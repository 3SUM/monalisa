CC	= g++ -g -Wall -pedantic -std=c++11
DEPS = LL.h

all: main

main: main.o $(DEPS)
	$(CC) -o main main.o

main.o: main.cpp $(DEPS)
	$(CC) -c main.cpp


# -----
# clean by removing object files.

clean:
	rm	$(OBJS)
