#include "lis.h"

lis::lis() {
    length = 0;
    myArray = nullptr;
}

lis::~lis() {
    if (myArray) {
        delete[] myArray;
    }
    myArray = nullptr;
    length = 0;
}

void lis::displayList() {
    std::cout << "Length: " << length << std::endl;
    std::cout << "List:" << std::endl;

    for (int i = 0; i < length; i++) {
        ((i % 10) == 9) ? std::cout << std::setw(7) << myArray[i] << '\n' : std::cout << std::setw(7) << myArray[i] << ' ';
    }

    std::cout << std::endl;
}

bool lis::makeList(int n) {
    length = n;

    if (length >= MINLEN && length <= MAXLEN) {
        myArray = new int[length];
        for (int i = 0; i < length; i++)
            myArray[i] = rand() % LIMIT;

        return true;
    }

    return false;
}

int lis::lisBF() {
    return lisREC(0, INT_MIN);
}

int lis::lisDY() {
    if (myArray == nullptr || length == 0)
        return 0;

    int *maxLIS;
    maxLIS = new int[length];

    for (int i = 0; i < length; i++) {
        maxLIS[i] = 1;

        for (int j = 0; j < i; j++) {
            if (myArray[i] > myArray[j])
                maxLIS[i] = std::max(maxLIS[i], maxLIS[j] + 1);
        }
    }

    int result = 0;
    for (int i = 0; i < length; i++) {
        if (maxLIS[i] > result)
            result = maxLIS[i];
    }

    delete[] maxLIS;

    return result;
}

int lis::lisREC(int index, int prev) {
    int include = 0;

    if (index == length)
        return 0;

    int exclude = lisREC(index + 1, prev);

    if (myArray[index] > prev)
        include = 1 + lisREC(index + 1, myArray[index]);

    return std::max(include, exclude);
}
