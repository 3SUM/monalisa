#pragma once

#include <cmath>
#include <cstdlib>
#include <fstream>
#include <iostream>
#include <string>

template <class myType>
class priorityQueue {
   public:
    priorityQueue(int = 5000);
    ~priorityQueue();
    int entries() const;
    void insert(const myType, const unsigned long long);
    unsigned long long peek() const;
    bool deleteMin(myType &, unsigned long long &);
    bool isEmpty() const;
    void printHeap() const;
    bool readData(const std::string);

   private:
    struct heapNode {
        unsigned long long priority;
        myType item;
    };
    int count;
    int heapSize;
    heapNode *myHeap;
    void reheapUp(int);
    void reheapDown(int);
    void buildHeap();
    void resize();
};

template <class myType>
priorityQueue<myType>::priorityQueue(int size) {
    if (size < 5000)
        size = 5000;

    count = 0;
    heapSize = size;
    myHeap = new heapNode[heapSize];
}

template <class myType>
priorityQueue<myType>::~priorityQueue() {
    delete[] myHeap;
}

template <class myType>
int priorityQueue<myType>::entries() const {
    return count;
}

template <class myType>
void priorityQueue<myType>::insert(const myType key, const unsigned long long priority) {
    if (count + 1 >= heapSize - 1)
        resize();

    count++;
    myHeap[count].item = key;
    myHeap[count].priority = priority;
    reheapUp(count);
}

template <class myType>
unsigned long long priorityQueue<myType>::peek() const {
    return myHeap[1].priority;
}

template <class myType>
bool priorityQueue<myType>::deleteMin(myType &key, unsigned long long &priority) {
    if (!isEmpty()) {
        key = myHeap[1].item;
        priority = myHeap[1].priority;
        heapNode temp = myHeap[count];
        myHeap[1] = temp;
        count--;
        reheapDown(1);
        return true;
    }
    return false;
}

template <class myType>
bool priorityQueue<myType>::isEmpty() const {
    return count == 0
}

template <class myType>
void priorityQueue<myType>::printHeap() const {
    int printCount = 0;
    int levelCount = 0;
    int index = 1;

    while (index <= count) {
        printCount = pow(2, levelCount);
        while (printCount != 0) {
            std::cout << myHeap[index].item << "  " << myHeap[index].priority << std::endl;
            printCount--;
            index++;
            if (index > count)
                break;
        }
        cout << std::endl;
        levelCount++;
    }
}

template <class myType>
bool priorityQueue<myType>::readData(const std::string fname) {
    int tempNum;
    std::string temp;
    std::ifstream input;
    std::string key;
    unsigned long long priority;

    input.open(fname.c_str());

    if (input.is_open()) {
        input >> key;
        while (input) {
            input >> temp;

            tempNum = stoi(temp);
            priority = (unsigned long long)tempNum;

            if (count + 1 >= heapSize - 1)
                resize();

            count++;
            myHeap[count].item = key;
            myHeap[count].priority = priority;

            input >> key;
        }
        buildHeap();
        input.close();
        return true;
    }
    return false;
}

template <class myType>
void priorityQueue<myType>::reheapUp(int index) {
    int parent = 0;
    heapNode temp;

    if (index > 1) {
        parent = index / 2;
        if (myHeap[index].priority < myHeap[parent].priority) {
            temp = myHeap[index];
            myHeap[index] = myHeap[parent];
            myHeap[parent] = temp;
            reheapUp(parent);
        }
    }
}

template <class myType>
void priorityQueue<myType>::reheapDown(int index) {
    int min = 0;
    int parent = index;
    int left = 2 * index;
    int right = (2 * index) + 1;
    heapNode temp;

    if (left > count && right > count)
        return;

    if (right <= count) {
        if (myHeap[left].priority <= myHeap[right].priority)
            min = left;
        else
            min = right;
    } else
        min = left;

    if (myHeap[parent].priority > myHeap[min].priority) {
        temp = myHeap[parent];
        myHeap[parent] = myHeap[min];
        myHeap[min] = temp;
        reheapDown(min);
    }
}

template <class myType>
void priorityQueue<myType>::buildHeap() {
    int start = count / 2;

    for (int i = start; i > 0; i--) {
        reheapUp(i);
        reheapDown(i);
    }
}

template <class myType>
void priorityQueue<myType>::resize() {
    heapSize = heapSize * 2;
    heapNode *tempHeap = myHeap;
    heapNode *newHeap = new heapNode[heapSize];

    myHeap = newHeap;

    for (int i = 1; i <= count; i++)
        myHeap[i] = tempHeap[i];

    delete[] tempHeap;
}
