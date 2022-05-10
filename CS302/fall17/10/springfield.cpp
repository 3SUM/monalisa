//  Springfield Fiber Installation
//	Help Mayor Quimby install Google fiber cabling.

#include <cstdlib>
#include <iostream>
#include <string>

#include "undirectedGraph.h"

using namespace std;

int main(int argc, char* argv[]) {
    // *****************************************************************
    //  Headers...

    string stars, bars, dashes;
    string fName;
    stars.append(65, '*');
    bars.append(65, '=');
    dashes.append(40, '-');
    const char* bold = "\033[1m";
    const char* unbold = "\033[0m";
    bool doTest = false;

    cout << stars << endl
         << bold << "CS 302 - Assignment #10" << endl;
    cout << "Springfield Fiber Installation" << unbold << endl;
    cout << endl;

    // ------------------------------------------------------------------
    //  Check argument

    if (argc == 1) {
        cout << "usage: <-t|fileName>" << endl;
        return 0;
    }

    if (argc != 2) {
        cout << "main: Error, invalid command line arguments." << endl;
        return 0;
    }

    if (argc == 2)
        if (string(argv[1]) == "-t")
            doTest = true;

    // ------------------------------------------------------------------
    //  If requested, do error testing...

    if (doTest) {
        cout << bars << endl;
        cout << "Error testing: " << endl
             << endl;

        undirectedGraph badGraph1(-1);
        undirectedGraph badGraph2(3);
        undirectedGraph badGraph3(10);  // ok
        undirectedGraph badGraph4;

        badGraph3.addEdge(11, -11, 100.0);
        badGraph1.setGraphSize(-2);
        badGraph2.setGraphSize(2);
        badGraph3.setGraphSize(20);

        if (badGraph3.getGraphSize() != 20)
            cout << "main: Error, graph size functions do"
                 << " not work correctly." << endl;

        badGraph3.addEdge(11, -11, 100.0);
        badGraph3.addEdge(51, 11, 100.0);
        badGraph3.addEdge(-11, 11, 100.0);
        badGraph3.addEdge(3, 3, 10.0);
        badGraph3.addEdge(5, 7, 100.0);  // ok
        badGraph4.addEdge(10, 10, 10.0);

        badGraph3.setTitle("My Graph");
        if (badGraph3.getTitle() != "My Graph")
            cout << "main: Error, title functions do not"
                 << " work correctly." << endl;

        if (badGraph3.readGraph("none.txt"))
            cout << "main: Error, able to read non-existant"
                 << " graph file." << endl;
        if (badGraph4.readLocationNames("names.txt"))
            cout << "main: Error, able to read names for "
                 << "non-existant graph." << endl;

        badGraph3.setTitle("Unused Example");
        if (badGraph3.getTitle() != "Unused Example")
            cout << "main: title functions do not work." << endl;

        badGraph1.prims(-1);
        badGraph2.prims(1);
        badGraph3.prims(100);

        badGraph2.printMatrix();

        cout << endl;
        {
            // note, this ensure destructor is called...
            undirectedGraph okGraph(1000);
        }
    }

    // ------------------------------------------------------------------
    //  Create graph from file.

    if (!doTest) {
        string graphFile;
        undirectedGraph myGraph;

        graphFile = string(argv[1]);

        cout << bars << endl;
        cout << "Springfield Fiber Configuration: " << endl
             << endl;

        if (myGraph.readGraph(graphFile)) {
            if (myGraph.getGraphSize() < 10)
                myGraph.printMatrix();
            if (!myGraph.readLocationNames("names.txt"))
                cout << "main: Error, Springfield Location Names"
                     << " unavailable." << endl;
            myGraph.prims(0);
        } else {
            cout << "main: Error reading " << graphFile << "." << endl;
        }
    }

    // *****************************************************************
    //  All done.

    cout << endl
         << stars << endl;
    if (doTest)
        cout << "Testing Complete." << endl;
    else
        cout << "Mayor Quimby thanks you." << endl;

    return 0;
}
