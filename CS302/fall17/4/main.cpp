#include <fstream>
#include <iostream>
#include <string>

#include "linkedQueue.h"
#include "linkedStack.h"

using namespace std;

int main(int argc, char *argv[]) {
    // ---------------------
    //  Initial delcarations and headers

    string stars;
    string userString;
    linkedQueue<char> myQueue;  // linkedQueue object
    linkedStack<char> myStack;  // linkedStack object
    bool isPalindrome;

    stars.append(60, '*');

    // ---------------------
    //  Get command line string.

    if (argc < 2) {
        cout << "Error, missing command line argument." << endl;
        exit(1);
    }

    if (argc > 2) {
        cout << "Error, too many command line arguments." << endl;
        exit(1);
    }

    userString = string(argv[1]);

    // ---------------------
    //  Push/enqueue user string
    //	Check if string is palindrome
    //	Show results

    cout << stars << endl;
    cout << "CS 302 - Assignment #4" << endl;
    cout << "Palindromes" << endl;
    cout << endl;

    for (unsigned int i = 0; i < userString.length(); i++) {
        if (isalpha(userString[i]) || isdigit(userString[i])) {
            myQueue.enqueue(tolower(userString[i]));  // Enqueue string one character at a time
            myStack.push(tolower(userString[i]));     // Push string one character at a time
        }
    }

    isPalindrome = true;                         // Set isPalindrome to TRUE
    while (!myStack.isEmpty())                   // While stack != EMPTY
        if (myQueue.dequeue() != myStack.pop())  // Dequeue and pop each character at the same time
            isPalindrome = false;                // If chars do not match, set isPalindrome to false

    cout << "The string: \'" << userString;
    if (isPalindrome)
        cout << "\' is a palindrome." << endl;  // Print if string is a palindrome
    else
        cout << "\' is not a palindrome." << endl;  // Print if string is not a palindrome
    cout << endl;

    // ------------------------------
    //  Done, terminate program.

    cout << "Game over, thanks for playing." << endl;

    return 0;
}
