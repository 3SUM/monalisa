#include <fstream>
#include <iostream>
#include <string>

#include "LL.h"

int main(int argc, char *argv[]) {
    std::string input_file = "";
    std::ifstream infile;
    int n;
    LL<int> myLL;

    if (argc != 2) {
        std::cout << "Usage: ./main [INPUT FILE]\n";
        exit(1);
    }

    input_file = argv[1];
    infile.open(input_file);

    if (!infile.is_open()) {
        std::cout << "Unable to open file: " << input_file << "\n";
        exit(1);
    }

    infile >> n;
    while (infile) {
        myLL.tailInsert(n);
        infile >> n;
    }

    int max;
    LL<int>::Iterator i;
    LL<int>::Iterator j;
    LL<int>::Iterator nil(nullptr);
    LL<int>::Iterator maxPos;

    j = nil;
    for (i = myLL.begin(); i != j; j--) {
        maxPos = i;
        max = *i;
        i++;

        while (i != j) {
            if (max < *i) {
                maxPos = i;
                max = *i;
            }
            i++;
        }
        if (j == nil) {
            j = myLL.end();
        } else {
            if (max < *j) {
                maxPos = j;
                max = *j;
            }
        }
        myLL.swapNodes(maxPos, j);
        i = myLL.begin();
    }

    std::cout << "Sorted Linked List\n";
    for (auto itr = myLL.begin(); itr != nullptr; itr++)
        std::cout << *itr << " ";
    std::cout << "\n\n";

    return 0;
}