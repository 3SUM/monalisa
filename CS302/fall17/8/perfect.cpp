#include <iostream>
#include <sstream>
#include <string>

#include "priorityQueue.h"

using namespace std;

struct numberPair {
    unsigned long long a;
    unsigned long long b;
    unsigned long long n;
};

unsigned long long exp_by_squaring(unsigned long long x, unsigned long long n) {
    if (n == 0)
        return 1;
    else if (n == 1)
        return x;
    else if ((n % 2) == 0)
        return exp_by_squaring(x * x, n / 2);
    else if ((n % 2) != 0)
        return (x * exp_by_squaring(x * x, (n - 1) / 2));

    return 0;
}

int main(int argc, char *argv[]) {
    // *****************************************************************
    //  Data declarations...

    int tempLimit;
    unsigned long long limitValue;
    unsigned long long currPriority;
    unsigned long long prevPriority;
    stringstream mySS;

    numberPair myPair;
    numberPair tempPair;
    priorityQueue<numberPair> myHeap0;

    // *****************************************************************
    //  Get/verify command line arguments.
    //	Error out if bad arguments...

    if (argc == 1) {
        cout << "Usage: ./perfect -l <limitValue>" << endl;
        exit(1);
    }

    if (argc != 3) {
        cout << "Error, invalid command line options." << endl;
        exit(1);
    }

    if (string(argv[1]) != "-l") {
        cout << "Error, invalid limit specifier." << endl;
        exit(1);
    }

    mySS << argv[2];
    mySS >> tempLimit;

    if (tempLimit < 10 || tempLimit > 1000000) {
        cout << "Error, invalid limit value." << endl;
        exit(1);
    }

    limitValue = (unsigned long long)tempLimit;

    // *****************************************************************
    // Display header

    cout << "CS 302 - Assignment #8" << endl;
    cout << "Perfect Powers Program." << endl
         << endl;

    // *****************************************************************
    // Perfect Powers Algorithm

    prevPriority = 0;
    currPriority = 0;

    myPair.a = 2;
    myPair.b = 2;
    myPair.n = exp_by_squaring(myPair.a, myPair.b);

    myHeap0.insert(myPair, myPair.n);

    while (myHeap0.peek() <= limitValue) {
        myHeap0.deleteMin(myPair, currPriority);

        if (currPriority != prevPriority)
            cout << currPriority << " ";

        prevPriority = currPriority;

        tempPair = myPair;
        tempPair.a = tempPair.a + 1;
        tempPair.n = exp_by_squaring(tempPair.a, tempPair.b);
        myHeap0.insert(tempPair, tempPair.n);

        if (myPair.a == 2) {
            myPair.b = myPair.b + 1;
            myPair.n = exp_by_squaring(myPair.a, myPair.b);
            myHeap0.insert(myPair, myPair.n);
        }
    }
    cout << endl;

    // *****************************************************************
    // All done

    return 0;
}
