//  Main program for testing
//	Test the stack and queue implementations

#include <fstream>
#include <iostream>
#include <string>

#include "linkedQueue.h"
#include "linkedStack.h"

using namespace std;

int main() {
    // *****************************************************************
    //  Headers...

    string bars, stars;
    bars.append(65, '-');
    stars.append(65, '*');

    cout << bars << endl
         << "CS 302 - Assignment #4" << endl;
    cout << "Basic Testing for Linked Stacks and "
         << "Queues Data Structures" << endl;

    // *****************************************************************
    //  Basic tests for linked stack implementation.
    //	Reservse number in a list by pushing each item on stack and then poping.

    cout << endl
         << stars << endl
         << "Test Stack Operations "
            "- Reversing:"
         << endl
         << endl;

    // ---------------------
    //  Integers

    linkedStack<int> istack;
    int inums[] = {2, 4, 6, 8, 10, 12, 14, 16, 18, 20};
    int ilen = (sizeof(inums) / sizeof(inums[0]));

    cout << "Original List:     ";
    for (int i = 0; i < ilen; i++) {
        istack.push(inums[i]);
        cout << inums[i] << " ";
    }

    cout << endl
         << "Reverse List:      ";
    for (int i = 0; i < ilen; i++)
        cout << istack.pop() << " ";

    cout << endl
         << endl;

    // ---------------------
    //  Doubles
    //	Create some stacks for doubles.

    linkedStack<double> dstack;

    double dnums[] = {1.1, 3.3, 5.5, 7.7, 9.9, 11.11, 13.13, 15.15};
    int dlen = (sizeof(dnums) / sizeof(dnums[0]));

    dstack.push(1000.0);

    cout << bars << endl
         << "Test Stack Operations "
         << "- Doubles:" << endl
         << endl;

    cout << "Original List:     ";
    for (int i = 0; i < dlen; i++) {
        dstack.push(dnums[i]);
        cout << dnums[i] << "   ";
    }

    cout << endl
         << "Reverse List:      ";
    for (int i = 0; i < dlen; i++) {
        cout << dstack.pop() << "   ";
        dstack.push(dstack.pop());
    }

    cout << endl
         << endl;

    // --------------------------------------
    //  More testing, large

    cout << bars << endl
         << "Test Stack Operations "
         << "- Large Test:" << endl
         << endl;

    linkedStack<short> mStack;
    int testSize1 = 100000;
    bool workedStk1 = true;

    for (int i = 1; i <= testSize1; i++)
        mStack.push(static_cast<short>(i + 100));

    for (int i = testSize1; i > 0; i--) {
        if (mStack.pop() != static_cast<short>(i + 100))
            workedStk1 = false;
    }

    if (!mStack.isEmpty())
        cout << "main: error, incorrect stack size." << endl;

    if (workedStk1)
        cout << "Multiple items, test passed." << endl;
    else
        cout << "Multiple items, test failed." << endl;

    cout << endl;

    // --------------------------------------
    //  Many entries testing

    cout << bars << endl
         << "Test Stack Operations "
         << "- Many many items:" << endl
         << endl;
    bool workedStk2 = true;

    linkedStack<int> iStackBig;
    int testSize2 = 400000;

    for (int i = 1; i <= testSize2; i++)
        iStackBig.push(i);

    for (int i = testSize2; i > 0; i--) {
        if (iStackBig.pop() != i)
            workedStk2 = false;
    }
    if (!iStackBig.isEmpty())
        workedStk2 = false;

    if (workedStk2)
        cout << "Many items, test passed." << endl;
    else
        cout << "Many items, test failed." << endl;

    cout << endl;

    // *****************************************************************
    //  Test basic queue operations.
    //	Create some integer queues, add items, delete items,
    //	display queues, etc...

    cout << endl
         << stars << endl
         << "Test Queue Operations "
         << "- Integers:" << endl
         << endl;

    linkedQueue<int> queue0, queue1;
    linkedQueue<int> queue2;
    int j;

    for (int i = 1; i <= 20; i++)
        queue0.enqueue(i);

    cout << "Queue 0 (original): ";
    queue0.printQueue();
    cout << endl
         << endl;

    for (int i = 1; i <= 20; i += 2) {
        j = queue0.dequeue();
        queue1.enqueue(j);
        j = queue0.dequeue();
        queue2.enqueue(j);
    }

    cout << "Queue 1 (odds):     ";
    queue1.printQueue();
    cout << endl
         << endl;

    cout << "Queue 2 (evens):    ";
    queue2.printQueue();
    cout << endl
         << endl;

    // --------------------------------------
    //  Floating point tests
    //	Create some queues for floating point items.

    cout << bars << endl
         << "Test Queue Operations "
         << "- Floats:" << endl
         << endl;

    linkedQueue<double> queue3;

    for (int i = 1; i <= 7; i++)
        queue3.enqueue(static_cast<double>(i) + 0.5);

    cout << "Queue 3 (floats, original): ";
    queue3.printQueue();
    cout << endl;

    cout << "Queue 3 (floats, modified): ";
    queue3.printQueue();
    cout << endl
         << endl;

    // --------------------------------------
    //  Larger test.

    cout << bars << endl
         << "Test Queue Operations "
         << "- Large Queue Test:" << endl
         << endl;

    linkedQueue<short> queue4;
    int testSize3 = 3000;
    bool workedStk3 = true;

    for (int i = 1; i <= testSize3; i++)
        queue4.enqueue(static_cast<short>(i + 100));

    for (int i = 1; i <= testSize3; i++)
        if (queue4.dequeue() != static_cast<short>(i + 100))
            workedStk3 = false;

    if (!queue4.isEmptyQueue())
        workedStk3 = false;

    if (workedStk3)
        cout << "Multiple items, test passed." << endl;
    else
        cout << "Multiple items, test failed." << endl;

    cout << endl;

    // --------------------------------------
    //  Many entries testing

    cout << bars << endl
         << "Test Queue Operations "
         << "- Many many items:" << endl
         << endl;
    bool worked = true;

    linkedQueue<int> queue5;
    int testSize = 400000;

    for (int i = 1; i <= testSize; i++)
        queue5.enqueue(i);

    for (int i = 1; i <= testSize; i++)
        if (queue5.dequeue() != i)
            worked = false;

    if (!queue5.isEmptyQueue())
        worked = false;

    if (worked)
        cout << "Many items, test passed." << endl;
    else
        cout << "Many items, test failed." << endl;

    cout << endl;

    // *****************************************************************
    //  All done.

    cout << bars << endl
         << "Game Over, thank you for playing." << endl;

    return 0;
}
