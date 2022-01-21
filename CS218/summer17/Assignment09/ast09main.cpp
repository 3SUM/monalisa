// CS 218 - Provided C++ program
//	This programs calls assembly language routines.

//  NOTE: To compile this program, and produce an object file
//	must use the "g++" compiler with the "-c" option.
//	This, the command "g++ -c main.c" will produce
//	an object file named "main.o" for linking.

//  Must ensure g++ compiler is installed:
//	sudo apt-get install g++

// ***************************************************************

#include <cstdlib>
#include <iostream>
#include <fstream>
#include <cstdlib>
#include <string>
#include <iomanip>

using namespace std;

#define SUCCESS 0
#define NOSUCCESS 1

#define MAXLENGTH 500

#define SUCCESS 0
#define NOSUCCESS 1
#define OUTOFRANGE 2
#define ENDOFINPUT 3


// ***************************************************************
//  Prototypes for external functions.
//	The "C" specifies to use the C-style standard calling convention.

extern "C" void bubbleSort(int[], int);
extern "C" void simpleStats(int[], int, int *, int *, int *);
extern "C" int iAverage(int[], int);
extern "C" long long variance(int[], int);
extern "C" int readTernaryNumber(int *);


// ***************************************************************

int main()
{

// --------------------------------------------------------------------
//  Declare variables.
//	For C/C++, 'int' is a 32-bit signed integer value.
//	For C/C++, 'long long' is a 64-bit signed integer value.

	string	bars;
	bars.append(50,'-');

	int	i, status, newNumber;
	int	list[MAXLENGTH];
	int	len = 0;
	int	min, max, med, ave;
	long long	var;

// --------------------------------------------------------------------
//	Display header.

	cout << bars << endl;
	cout << "CS 218 - Assignment #9" << endl << endl;

// --------------------------------------------------------------------
//  Read numbers from user:

	for (len=0; len<MAXLENGTH; len++) {

		cout << "Enter Ternary Number: ";
		fflush(stdout);

		status = readTernaryNumber(&newNumber);

		if (status == NOSUCCESS) break;

		list[len] = newNumber;
	}

// --------------------------------------------------------------------
//  If valid, display results

	if (len == 0) {
		cout << "Error, no numbers entered." << endl;
		cout << "Program terminated." << endl;

	} else {

		cout << endl << bars << endl;
		cout << "Program Results" << endl << endl;

		bubbleSort(list, len);
		simpleStats(list, len, &min, &max, &med);
		ave = iAverage(list, len);
		var = variance(list, len);

		cout << "Sorted List: " << endl;

		for ( i = 0; i < len; i++) {
			cout << setw(10) << list[i];
			if (i%5==4 || i==(len-1) )
				cout << endl;
			else
				cout << "  ";
		}

		cout << endl << "Statistical Results:" << endl;
		cout << "   Length   =  " << len << endl;
		cout << "   Minimum  =  " << min << endl;
		cout << "   Maximum  =  " << max << endl;
		cout << "   Median   =  " << med << endl;
		cout << "   Average  =  " << ave << endl;
		cout << "   Variance =  " << var << endl;
		cout << endl << endl;
	}

// --------------------------------------------------------------------
//  All done...

	return 0;


}

