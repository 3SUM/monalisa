// CS 302, Assignment #8
// Main program for testing hash table

#include <fstream>
#include <iostream>
#include <string>

#include "hashTable.h"

using namespace std;

int main() {
    // *****************************************************************
    //  Headers...

    string bars, stars;
    double tmp1;
    unsigned int tmp2;

    bars.append(40, '-');
    stars.append(65, '*');

    cout << bars << endl
         << "CS 302 - Assignment #7" << endl;
    cout << "Hash Table Test Program." << endl;
    cout << endl;

    // *****************************************************************
    //  Very simple initial testing...

    {
        hashTable tstHash0;

        string words0[10] = {"the", "a", "there", "answer", "any",
                             "by", "bye", "their", "ball", "balloon"};
        int len0 = 10;

        for (int i = 0; i < len0; i++) {
            if (!tstHash0.insert(words0[i], static_cast<double>(i))) {
                cout << "Error, unable to insert word " << words0[i] << "." << endl;
            }
        }

        for (int i = 0; i < len0; i++) {
            if (!tstHash0.search(words0[i], tmp1, tmp2)) {
                cout << "Error, hash lost word " << words0[i] << "." << endl;
            }
        }

        cout << endl
             << "Hash Dump (for testing)" << endl;
        cout << bars << endl
             << endl;
        tstHash0.printHash();
        cout << endl
             << endl;

        cout << "Test Hash Zero Stats" << endl
             << endl;
        tstHash0.showHashStats();
        cout << endl
             << bars << endl;

        for (int i = 0; i < len0; i++) {
            if (!tstHash0.remove(words0[i])) {
                cout << "Error, hash delete fail" << words0[i] << "." << endl;
            }
        }

        cout << endl
             << "Hash Dump (for testing -> should be empty)" << endl;
        cout << bars << endl
             << endl;
        tstHash0.printHash();
        cout << endl
             << endl;

        cout << "Test Hash Zero Stats (now empty)" << endl
             << endl;
        tstHash0.showHashStats();
        cout << endl
             << stars << endl;
    }

    // -----------------------------------------------------------------
    //  Slightly larger test set.

    hashTable tstHash1;

    string words1[50] = {"aah", "aahed", "aahing", "aahs", "aal",
                         "aalii", "aaliis", "aals", "aardvark",
                         "aardwolf", "aargh", "aarrgh", "aarrghh", "aas",
                         "aasvogel", "ab", "aba", "abaca", "abacas",
                         "abaci", "aback", "abacus", "abacuses", "abaft",
                         "abaka", "abakas", "abalone", "abalones", "abamp",
                         "abampere", "abamps", "abandon", "abandons",
                         "abapical", "abas", "abase", "abased", "abasedly",
                         "abaser", "abasers", "abases", "abash", "abashed",
                         "abashes", "abashing", "abasia", "abasias",
                         "abasing", "abatable", "abate"};
    int len1 = 50;

    for (int i = 0; i < len1; i++) {
        if (!tstHash1.insert(words1[i], static_cast<double>(i))) {
            cout << "Error, unable to insert word " << words1[i] << "." << endl;
        }
    }

    for (int i = 0; i < len1; i++) {
        if (!tstHash1.search(words1[i], tmp1, tmp2)) {
            cout << "Error, hash lost word " << words1[i] << "." << endl;
        }
    }

    cout << endl
         << endl;
    cout << "Test Hash One" << endl
         << endl;
    tstHash1.showHashStats();

    for (int i = 0; i < len1; i++) {
        if (!tstHash1.remove(words1[i])) {
            cout << "Error, hash delete fail " << words1[i] << "." << endl;
        }
    }

    cout << endl;
    cout << "Test Hash One (now empty)" << endl
         << endl;
    tstHash1.showHashStats();

    cout << endl
         << stars << endl;

    // -----------------------------------------------------------------
    //  Much larger, more significant test.
    // 	This test inserts, searches, and removes 26^4 (456,976)
    //	'IDs' which are just unique letter strings for testing.

    hashTable tstHash2;
    char ltr1, ltr2, ltr3, ltr4;
    string str = "";

    ltr1 = 'a';
    for (int i = 0; i < 26; i++) {
        ltr2 = 'a';
        for (int j = 0; j < 26; j++) {
            ltr3 = 'a';
            for (int k = 0; k < 26; k++) {
                ltr4 = 'a';
                for (int l = 0; l < 26; l++) {
                    str = "";
                    str.append(1, ltr1);
                    str.append(1, ltr2);
                    str.append(1, ltr3);
                    str.append(1, ltr4);
                    if (!tstHash2.insert(str, static_cast<double>(i)))
                        cout << "Error, insert fail. ("
                             << str << ")" << endl;
                    ltr4++;
                }
                ltr3++;
            }
            ltr2++;
        }
        ltr1++;
    }

    cout << "Test Hash Two" << endl
         << endl;
    tstHash2.showHashStats();
    cout << endl;

    //	tstHash2.printHash();				// debugging only...

    ltr1 = 'a';
    for (int i = 0; i < 26; i++) {
        ltr2 = 'a';
        for (int j = 0; j < 26; j++) {
            ltr3 = 'a';
            for (int k = 0; k < 26; k++) {
                ltr4 = 'a';
                for (int l = 0; l < 26; l++) {
                    str = "";
                    str.append(1, ltr1);
                    str.append(1, ltr2);
                    str.append(1, ltr3);
                    str.append(1, ltr4);
                    if (!tstHash2.search(str, tmp1, tmp2))
                        cout << "Error, hash lost word - "
                             << str << "." << endl;
                    ltr4++;
                }
                ltr3++;
            }
            ltr2++;
        }
        ltr1++;
    }

    ltr1 = 'a';
    for (int i = 0; i < 26; i++) {
        ltr2 = 'a';
        for (int j = 0; j < 26; j++) {
            ltr3 = 'a';
            for (int k = 0; k < 26; k++) {
                ltr4 = 'a';
                for (int l = 0; l < 26; l++) {
                    str = "";
                    str.append(1, ltr1);
                    str.append(1, ltr2);
                    str.append(1, ltr3);
                    str.append(1, ltr4);
                    if (!tstHash2.remove(str))
                        cout << "Error, hash delete failed - "
                             << str << "." << endl;
                    ltr4++;
                }
                ltr3++;
            }
            ltr2++;
        }
        ltr1++;
    }

    cout << endl;
    cout << "Test Hash Two (now empty)" << endl
         << endl;
    tstHash2.showHashStats();
    cout << endl;

    // *****************************************************************
    //  All done.

    cout << bars << endl
         << "Game Over, thank you for playing." << endl;

    return 0;
}
