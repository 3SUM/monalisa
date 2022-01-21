// CS 218 - Provided C++ program
//	This programs calls assembly language routines.

//  Must ensure g++ compiler is installed:
//	sudo apt-get install g++

// ***************************************************************************

#include <iostream>

using namespace std;

// ***************************************************************
//  Prototypes for external functions.
//	The "C" specifies to use the standard C/C++ style
//	calling convention.

extern "C" bool getArguments(int, char* [], FILE **, FILE **, bool *);
extern "C" void countDigits(FILE*, int []);
extern "C" void showGraph(FILE *, int [], bool);


// ***************************************************************
//  Basic C++ program (does not use any objects).

int main(int argc, char* argv[])
{

// --------------------------------------------------------------------
//  Declare variables and simple display header
//	By default, C++ integers are doublewords (32-bits).

	FILE		*rdFileDesc, *wrFileDesc;
	bool		displayToScreen;
	int			digitCounts[10] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0};


// --------------------------------------------------------------------
//  If command line arguments OK
//	count the digits
//	display results

	if (getArguments(argc, argv, &rdFileDesc, &wrFileDesc, &displayToScreen)) {

		countDigits(rdFileDesc, digitCounts);

		showGraph(wrFileDesc, digitCounts, displayToScreen);
	}


// --------------------------------------------------------------------
//  Note, file are closed automatically by OS.
//  All done...

	return 0;
}
