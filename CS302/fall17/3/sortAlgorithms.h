#pragma once

#include <cstdlib>
#include <iomanip>
#include <iostream>

class sortAlgorithms {
   public:
    sortAlgorithms();
    ~sortAlgorithms();
    void generateData(int);
    int getLength();
    short getItem(int);
    void printData();
    void bubbleSort();
    void insertionSort();
    void quickSort();
    void countSort();
    void mergeSort();

   private:
    int length;
    short *myArray;
    static const int LIMIT = 5000;
    void quickSort(int, int);
    int partition(int, int);
    void mergeSort(int, int);
    void merge(int, int, int, int);
};
