//  Main program for testing Disjoint Sets object

#include <cstdlib>
#include <iostream>
#include <string>

#include "disjointSets.h"

using namespace std;

int main(int argc, char* argv[]) {
    // *****************************************************************
    //  Headers...

    string stars, bars, dashes;
    stars.append(65, '*');
    bars.append(65, '=');
    dashes.append(40, '-');
    const char* bold = "\033[1m";
    const char* unbold = "\033[0m";

    cout << stars << endl
         << bold << "CS 302 - Assignment #9" << endl;
    cout << "Disjoint Sets" << unbold << endl;
    cout << endl;

    // ------------------------------------------------------------------
    //  Error testing

    disjointSets badTest;

    if (badTest.createSets(-10))
        cout << "Error invaid creatation of badTest(-10)." << endl;

    if (badTest.createSets(5000000))
        cout << "Error invaid creatation of badTest(5000000)." << endl;

    // ------------------------------------------------------------------
    //  Initial testing

    {
        disjointSets setTest0;
        int m01, m23, m45;
        int m0123, m456, m4567, m45678;
        int m012345678;

        cout << dashes << endl;
        cout << "Test Set 0" << endl
             << endl;

        if (!setTest0.createSets(10))
            cout << "Error creating setTest0." << endl;
        cout << "Initial State:" << endl;
        setTest0.printSets();
        cout << endl;

        cout << dashes << endl;
        m01 = setTest0.setUnion(0, 1);
        cout << "  union(0,1) -> " << m01 << endl;
        m23 = setTest0.setUnion(2, 3);
        cout << "  union(2,3) -> " << m23 << endl;
        m45 = setTest0.setUnion(4, 5);
        cout << "  union(4,5) -> " << m45 << endl;

        cout << endl
             << "New State 1:" << endl;
        cout << "Size: " << setTest0.getTotalSets() << endl;
        setTest0.printSets();
        cout << endl;

        cout << dashes << endl;
        m0123 = setTest0.setUnion(m01, m23);
        cout << "  union(" << m01 << "," << m23 << ") -> " << m0123 << endl;
        m456 = setTest0.setUnion(m45, 6);
        cout << "  union(" << m45 << ",6"
             << ") -> " << m456 << endl;
        m4567 = setTest0.setUnion(m456, 7);
        cout << "  union(" << m456 << ",7"
             << ") -> " << m4567 << endl;
        m45678 = setTest0.setUnion(m4567, 8);
        cout << "  union(" << m4567 << ",8"
             << ") -> " << m45678 << endl;

        cout << endl
             << "New State 2:" << endl;
        setTest0.printSets();
        cout << endl;

        cout << dashes << endl;
        cout << "  setFind(1): " << setTest0.setFind(1) << endl;
        cout << "  setFind(2): " << setTest0.setFind(2) << endl;
        cout << "  setFind(4): " << setTest0.setFind(4) << endl;
        cout << "  setFind(7): " << setTest0.setFind(7) << endl;

        cout << endl
             << "New State 3:" << endl;
        setTest0.printSets();
        cout << endl;

        cout << dashes << endl;
        m012345678 = setTest0.setUnion(m0123, m45678);
        cout << "m0123 = " << m0123 << endl;
        cout << "m45678 = " << m45678 << endl;
        cout << "  union(m0123,m45678) -> " << m012345678 << endl;

        cout << endl
             << "New State 4:" << endl;
        setTest0.printSets();
        cout << endl;

        cout << dashes << endl;
        cout << "  setFind(3): " << setTest0.setFind(3) << endl;
        cout << "  setFind(5): " << setTest0.setFind(5) << endl;
        cout << "  setFind(7): " << setTest0.setFind(7) << endl;

        cout << endl
             << "New State 5:" << endl;
        setTest0.printSets();
        cout << endl;

        cout << dashes << endl;
        cout << "  setFind(0): " << setTest0.setFind(0) << endl;

        cout << endl
             << "New State 6:" << endl;
        setTest0.printSets();
        cout << endl;

        cout << dashes << endl;
        cout << "  setFind(4): " << setTest0.setFind(4) << endl;
        cout << "  setFind(6): " << setTest0.setFind(6) << endl;
        cout << "  setFind(8): " << setTest0.setFind(8) << endl;

        cout << endl
             << "Final State:" << endl;
        setTest0.printSets();
        cout << endl;
    }

    // ------------------------------------------------------------------

    disjointSets setTest1;
    int set = 1;

    cout << dashes << endl;
    cout << "Test Set 1" << endl
         << endl;

    if (!setTest1.createSets(10))
        cout << "Error creating setTest1." << endl;

    if (setTest1.setFind(0) == setTest1.setFind(1))
        cout << "testDS: error, set operations failed." << endl;

    cout << endl
         << "Initial State:" << endl;
    setTest1.printSets();
    cout << endl;

    for (int i = 1; i < 10; i++)
        set = setTest1.setUnion(set, i);

    if (setTest1.setFind(1) != setTest1.setFind(2))
        cout << "testDS: error, set find operations failed." << endl;

    if (setTest1.getSetSize(1) != 9)
        cout << "testDS: error, set size operations failed." << endl;

    cout << "Set Size: " << setTest1.getSetSize(1) << endl;

    cout << endl
         << "Final State:" << endl;
    setTest1.printSets();
    cout << endl;

    // ------------------------------------------------------------------

    {
        disjointSets setTest2;
        int tstSet = 0;

        if (!setTest2.createSets(1000))
            cout << "Error creating setTest2." << endl;
        tstSet = setTest2.setUnion(0, 1);
        tstSet = setTest2.setUnion(1, 997);
        tstSet = setTest2.setUnion(1, 998);
        tstSet = setTest2.setUnion(1, 999);

        if (tstSet != 999)
            cout << "testDS: Error " << tstSet << endl;
    }

    // ------------------------------------------------------------------
    //  Quiz

    cout << dashes << endl;
    cout << "Quiz Test Set" << endl
         << endl;

    disjointSets quizSet;
    int setParent = 0;

    if (!quizSet.createSets(10))
        cout << "Error creating quizSet." << endl;

    cout << endl
         << "Initial State:" << endl;
    quizSet.printSets();
    cout << endl;

    setParent = quizSet.setUnion(0, 1);
    setParent = quizSet.setUnion(2, 3);
    setParent = quizSet.setUnion(4, 5);

    cout << endl
         << "Intermediate State 1:" << endl;
    quizSet.printSets();
    cout << endl;

    setParent = quizSet.setUnion(1, 3);
    setParent = quizSet.setUnion(5, 6);
    setParent = quizSet.setUnion(5, 7);
    setParent = quizSet.setUnion(5, 8);

    cout << endl
         << "Intermediate State 2:" << endl;
    quizSet.printSets();
    cout << endl;

    setParent = quizSet.setUnion(3, 5);

    cout << endl
         << "Final State:" << endl;
    quizSet.printSets();
    cout << endl;

    if (setParent != 4)
        cout << "testDS: error in quiz set. " << setParent << endl;

    cout << "find(0) = " << quizSet.setFind(0) << endl;
    cout << "find(4) = " << quizSet.setFind(4) << endl;
    cout << "find(7) = " << quizSet.setFind(7) << endl;
    cout << "find(6) = " << quizSet.setFind(6) << endl;
    cout << "find(8) = " << quizSet.setFind(8) << endl;
    cout << "find(9) = " << quizSet.setFind(9) << endl;
    cout << endl;

    // ------------------------------------------------------------------
    //  Larger test

    cout << dashes << endl;
    cout << "Large Set Test" << endl
         << endl;

    disjointSets lrgTst;

    int max = 500000;  // must be even

    if (!lrgTst.createSets(max))
        cout << "Error creating lrgTst." << endl;

    int evnPrt = 0;
    int oddPrt = 1;

    for (int i = 0; i < max; i++) {
        if (i % 2 == 0)
            evnPrt = lrgTst.setUnion(evnPrt, i);
        else
            oddPrt = lrgTst.setUnion(oddPrt, i);
    }

    if (lrgTst.getSetCount() != 2)
        cout << "Lage Set, Set Count Error." << endl;
    else
        cout << "Large Set Test, Sets Count - OK" << endl;

    if (lrgTst.getSetSize(evnPrt) != max / 2 || lrgTst.getSetSize(oddPrt) != max / 2)
        cout << "Large Set Error." << endl;
    else
        cout << "Large Set Test, Sets - OK" << endl;

    // *****************************************************************
    //  All done.

    cout << endl
         << stars << endl
         << "Game Over, thank you for playing." << endl;

    return 0;
}
