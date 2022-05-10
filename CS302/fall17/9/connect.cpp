//  CS 302 - Assignment #9
//  Provided main program for sensor network connectivity.

#include <cstdlib>
#include <iostream>
#include <sstream>
#include <string>

#include "sensorNetwork.h"

using namespace std;

// *********************************************************************
//  Get and check command line arguments...
//	-df <inputFileName> -rpt <outputFileName>

bool getArgs(int argc, char *argv[], string &inputFileName,
             string &outputFileName) {
    stringstream ss;

    if (argc == 1) {
        cout << "Usage: ./connect -df <dataFileName> "
             << "-rpt <reportFileName>" << endl;
        return false;
    }

    if (argc != 5) {
        cout << "Error, invalid command line arguments." << endl;
        return false;
    }

    if (string(argv[1]) != "-df") {
        cout << "Error, invalid input file specifier." << endl;
        return false;
    }

    inputFileName = string(argv[2]);

    if (string(argv[3]) != "-rpt") {
        cout << "Error, invalid output file specifier." << endl;
        return false;
    }

    outputFileName = string(argv[4]);

    return true;
}

// *****************************************************************

int main(int argc, char *argv[]) {
    // ------------------------------------------------------------------
    //  Declarations and headers...

    string stars, bars, dashes;
    stars.append(65, '*');
    bars.append(65, '=');
    dashes.append(40, '-');
    const char *bold = "\033[1m";
    const char *unbold = "\033[0m";

    string dataFileName;
    string rptFileName;

    cout << stars << endl
         << bold << "CS 302 - Assignment #9" << endl;
    cout << "Sensor Network Connectivity Program" << unbold << endl;
    cout << endl;

    // ------------------------------------------------------------------
    //  Determine sensor network connectivity
    //	get command line arguments
    //	read data file
    //	show summary statistics
    //	create final connectivity report

    sensorNetwork myNetwork;

    if (getArgs(argc, argv, dataFileName, rptFileName)) {
        if (myNetwork.readFile(dataFileName)) {
            myNetwork.showStats();
            cout << endl;
            if (!myNetwork.createReport(rptFileName))
                cout << "Error create report." << endl;
        } else {
            cout << "Error reading input file." << endl;
        }
    }

    // ------------------------------------------------------------------
    //  All done.

    cout << endl
         << stars << endl
         << "Game Over, thank you for playing." << endl;

    return 0;
}
