// CS 302
// Final Project, Maximum Flow Algorithm

// Note, must use C++11 compiler option
//	g++ -Wall -Wpedantic -g -std=c++11

#include <iostream>
#include <string>
#include <cstdlib>
#include <iomanip>

#include "directedGraph.h"

using namespace std;

// *****************************************************************

int main(int argc, char *argv[])
{

// ------------------------------------------------------------------
//  Headers.

	string	stars, bars, dashes;
	string	fName;
	stars.append(65, '*');
	bars.append(65, '=');
	dashes.append(65,'-');
	const char* bold   = "\033[1m";
	const char* unbold   = "\033[0m";

	cout << stars << endl << bold << "CS 302 - Assignment #11" << endl;
	cout << "Maximum Flow Program" << unbold << endl;
	cout << endl;

// ------------------------------------------------------------------
//  Check argument
//	requires formatted graph file.

	if (argc == 1) {
		cout << "usage: <graphFileName>" << endl;
		return 0;
	}

	if (argc != 2) {
		cout << "main: Error, invalid command line argument." << endl;
		return 0;
	}

// ------------------------------------------------------------------
//  Read graph and perform page rank operations.

	string graphFile;
	directedGraph myGraph;
	double max;
	const int MAX_SIZE = 100;

	graphFile = string(argv[1]);

	if (myGraph.readGraph(graphFile)) {

		if (myGraph.getVertexCount() < MAX_SIZE)
			myGraph.printGraph();

		myGraph.showGraphStats();

		max = myGraph.findMaxFlow();

		cout << "Max Flow: " << setprecision(2) << fixed << max << endl;
		if (myGraph.getVertexCount() <= MAX_SIZE) {
			cout << endl << "Flow Graph:" << endl;
			myGraph.printFlowGraph();
		}

	} else {
		cout << "main: Error reading " << graphFile << "." << endl;
	}

// ------------------------------------------------------------------
//  All done.

	cout << endl;
	cout << stars << endl;
	cout << "Game over, thanks for playing." << endl;

	return 0;
}
