//  CS 302 Assignment #1
//	Provided Main Program

#include <cstdlib>
#include <iostream>
#include <sstream>
#include <string>

#include "lis.h"

using namespace std;

// *********************************************************************

int main(int argc, char *argv[]) {
    // ---------------
    //  Initial declarations.

    enum algorithmOption { BRUTE_FORCE,
                           DYNAMIC,
                           NONE };
    string stars;
    stars.append(60, '*');

    algorithmOption algoOpt = NONE;
    string fileName;
    int maxLength = 0;
    lis myLis;
    stringstream ss;

    // ---------------
    //  Validate command line argument.
    //	<-bf|-dy> <length>

    if (argc == 1) {
        cout << "Usage: ./main <-bf|-dy> <length>" << endl;
        exit(1);
    }

    if (argc != 3) {
        cout << "Error, invalid command line options." << endl;
        exit(1);
    }

    if (string(argv[1]) == "-bf")
        algoOpt = BRUTE_FORCE;

    if (string(argv[1]) == "-dy")
        algoOpt = DYNAMIC;

    if (algoOpt == NONE) {
        cout << "Error, invalid algorithm option." << endl;
        exit(1);
    }

    if (string(argv[2]) != "") {
        ss << argv[2];
        ss >> maxLength;
    }

    // ---------------
    //  Solve (as per selected algorithm).

    if (!myLis.makeList(maxLength)) {
        cout << "main: Error, invalid array length."
             << " Program terminated." << endl;
        exit(1);
    }

    if (algoOpt == BRUTE_FORCE)
        maxLength = myLis.lisBF();

    if (algoOpt == DYNAMIC)
        maxLength = myLis.lisDY();

    // ---------------
    //  Display headers, list, and result.

    cout << stars << endl;
    cout << "CS 302 - Assignment #1" << endl;
    cout << "Longest Increasing Subsequence Algorithms." << endl;
    cout << endl;

    cout << "Algorithm: ";
    switch (algoOpt) {
        case BRUTE_FORCE:
            cout << "Brute Force" << endl;
            break;
        case DYNAMIC:
            cout << "Dynamic Programming" << endl;
            break;
        default:
            cout << "Error, invalid selection." << endl;
            break;
    }
    cout << endl;
    myLis.displayList();
    cout << "Longest Subsequence = " << maxLength << endl;

    // ---------------
    //  Done, end program.

    return 0;
}
