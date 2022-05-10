// Luis Maya
// CS302 Section #1002
// Assignment #01
#pragma once

#include <climits>
#include <cmath>
#include <iomanip>
#include <iostream>

class lis {
   public:
    lis();
    ~lis();
    void displayList();
    bool makeList(int);
    int lisBF();
    int lisDY();
    int lisREC(int, int);

   private:
    int length;
    int *myArray;
    static const int MINLEN = 10;
    static const int MAXLEN = 100000;
    static const int LIMIT = 7000;
};
