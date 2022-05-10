#include "sortAlgorithms.h"

sortAlgorithms::sortAlgorithms() {
    length = 0;
    myArray = nullptr;
}

sortAlgorithms::~sortAlgorithms() {
    delete[] myArray;
    myArray = nullptr;
    length = 0;
}

void sortAlgorithms::generateData(int n) {
    length = n;
    myArray = new short[length];

    for (int i = 0; i < length; i++)
        myArray[i] = rand() % LIMIT;
}

int sortAlgorithms::getLength() {
    return length;
}

short sortAlgorithms ::getItem(int index) {
    if (index < length) {
        return myArray[index];
    } else {
        std::cout << "Invalid value!" << std::endl;
    }

    return 0;
}

void sortAlgorithms::printData() {
    for (int i = 0; i < length; i++) {
        ((i % 10) == 9) ? std::cout << std::setw(6) << myArray[i] << '\n' : std::cout << std::setw(6) << myArray[i] << ' ';
    }
}

void sortAlgorithms::bubbleSort() {
    bool swapped;

    for (int k = 0; k < length - 1; k++) {
        swapped = false;
        for (int i = 0; i < length - k - 1; i++)
            if (myArray[i] < myArray[i + 1]) {
                std::swap(myArray[i], myArray[i + 1]);
                swapped = true;
            }
        if (!swapped)
            break;
    }
}

void sortAlgorithms::insertionSort() {
    int i, j;

    i = 1;

    while (i < length) {
        j = i;
        while (j > 0 && myArray[j - 1] < myArray[j]) {
            std::swap(myArray[j], myArray[j - 1]);
            j = j - 1;
        }
        i = i + 1;
    }
}

void sortAlgorithms::quickSort() {
    return quickSort(0, length - 1);
}

void sortAlgorithms::countSort() {
    int key = LIMIT;
    int n = 0;
    short *count;

    count = new short[key];
    for (int i = 0; i < key; i++)
        count[i] = 0;
    for (int i = 0; i < length; i++)
        count[myArray[i]]++;
    for (int i = 4999; i >= 0; i--) {
        if (count[i] > 0) {
            for (int j = 0; j < count[i]; j++) {
                myArray[n] = i;
                n++;
            }
        }
    }
}

void sortAlgorithms::quickSort(int low, int high) {
    int p;

    if (low < high) {
        p = partition(low, high);
        quickSort(low, p);
        quickSort(p + 1, high);
    }
}

int sortAlgorithms::partition(int low, int high) {
    int pivot = myArray[low];
    int i = low - 1;
    int j = high + 1;

    while (true) {
        do {
            i++;
        } while (myArray[i] > pivot);

        do {
            j--;
        } while (myArray[j] < pivot);

        if (i < j) {
            std::swap(myArray[i], myArray[j]);
        } else {
            return j;
        }
    }
}

void sortAlgorithms::mergeSort() {
    mergeSort(0, length - 1);
}

void sortAlgorithms::mergeSort(int start, int end) {
    if (start >= end)
        return;

    int mid = (end + start) / 2;
    mergeSort(start, mid);
    mergeSort(mid + 1, end);
    merge(start, mid, mid + 1, end);
}

void sortAlgorithms::merge(int start, int midL, int midR, int end) {
    int tempLength = end - start + 1;
    short *workArray;
    workArray = new short[tempLength];
    int left = start;
    int right = midR;

    for (int i = 0; i < tempLength; i++) {
        if (left > midL)
            workArray[i] = myArray[right++];
        else if (right > end)
            workArray[i] = myArray[left++];
        else if (myArray[left] >= myArray[right])
            workArray[i] = myArray[left++];
        else
            workArray[i] = myArray[right++];
    }

    for (int i = 0; i < tempLength; i++)
        myArray[start++] = workArray[i];

    delete[] workArray;
}
