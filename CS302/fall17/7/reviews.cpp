//  CS 302 Assignment #5
//  Check zip codes
//  Provided main program.

#include <cstdlib>
#include <iostream>
#include <string>

#include "reviewData.h"

using namespace std;

int main(int argc, char *argv[]) {
    // *****************************************************************
    //  Data declarations...

    string stars, bars;
    char userOpt;
    string indent = "   ";
    string reviewsFile;
    string dataFile;
    string prodStr = "";
    bool keepProcessing = true;
    double scr;
    unsigned int cnt;

    stars.append(65, '*');
    bars.append(50, '=');

    // ------------------------------------------------------------------
    //  Get/verify command line arguments.
    //	Error out if bad arguments...

    if (argc == 1) {
        cout << "Usage: reviews -m <masterReviewsFile>" << endl;
        exit(1);
    }

    if (argc != 3) {
        cout << "Error, invalid command line options." << endl;
        exit(1);
    }

    if (string(argv[1]) != "-m") {
        cout << "Error, invalid master review file"
             << " specifier." << endl;
        exit(1);
    }

    reviewsFile = string(argv[2]);

    // ------------------------------------------------------------------
    //  Read master review file.

    reviewData reviewSet1;

    if (!reviewSet1.readMasterReviewData(reviewsFile)) {
        cout << "reviews: Error reading master "
             << "reviews codes file." << endl;
        exit(1);
    }

    // ------------------------------------------------------------------
    //  Display some cute headers...

    cout << stars << endl
         << "CS 302 - Assignment #5" << endl;
    cout << "Amazon Review Checking Program" << endl;
    cout << endl;

    // ------------------------------------------------------------------
    //  Get user processing option.

    while (keepProcessing) {
        cout << bars << endl;
        cout << "Select Option:" << endl;
        cout << indent << "'p' - process input file." << endl;
        cout << indent << "'s' - show statistics" << endl;
        cout << indent << "'a' - show entire tree contents (debug)" << endl;
        cout << indent << "'l' - lookup product" << endl;
        cout << indent << "'m' - find/show product with maximum "
             << "number of reviews" << endl;
        //		cout << indent << "'h' - find/show product with highest score" << endl;
        cout << indent << "'q' - quit" << endl;
        cout << "> ";
        cin >> userOpt;

        switch (userOpt) {
            case 'p':
                dataFile = "";
                cout << "Enter input file: ";
                while (dataFile == "")
                    cin >> dataFile;
                if (!reviewSet1.getReviews(dataFile))
                    cout << "reviews: Error reading "
                         << " input data file." << endl;
                break;

            case 's':
                reviewSet1.showStats();
                break;

            case 'a':
                reviewSet1.printAllReviews();
                break;

            case 'l':
                prodStr = "";
                cout << "Enter Product: ";
                while (prodStr == "")
                    cin >> prodStr;
                cout << endl;
                if (reviewSet1.search(prodStr, scr, cnt))
                    reviewSet1.printProduct(prodStr, scr, cnt);
                else
                    cout << "Product, " << prodStr << " not found." << endl;
                cout << endl;
                break;

            case 'm':
                reviewSet1.showMaxReview();
                break;

                //			case 'h':
                //				reviewSet1.showMaxScore();
                //				break;

            case 'q':
                keepProcessing = false;
                cout << endl;
                break;

            default:
                cout << "Error, invalid selection.  "
                     << "Please re-try" << endl;
        }
    }

    // *****************************************************************
    //  All done.

    cout << stars << endl
         << "Game Over, thank you for playing." << endl;

    return 0;
}
