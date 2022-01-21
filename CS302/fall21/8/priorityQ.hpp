#pragma once

template <typename T>
class priorityQ {
   private:
    int capacity;
    int items;
    T* heapArray;

   public:
    priorityQ(int size = 10) {
        capacity = size;
        items = 0;
        heapArray = new T[capacity];
    }

    priorityQ(const priorityQ<T>&) {
    }

    ~priorityQ() {
        delete[] heapArray;
        capacity = 0;
        items = 0;
    }

    const priorityQ<T>& operator=(const priorityQ<T>&) {
    }

    void insert(const T& element) {
        if (items + 1 >= capacity - 1) {
            resize();
        }

        items++;
        heapArray[items].item = element;
        bubbleUp(items);
    }

    void deleteHighestPriority() {
        if (!isEmpty()) {
            T temp = heapArray[items];
            heapArray[1] = temp;
            items--;
            bubbleDown(1);
        }
    }

    T getHighestPriority() const {
        return heapArray[1];
    }

    bool isEmpty() const { return items == 0; }

    void bubbleUp(int index) {
        int parent = 0;
        T temp;

        if (index > 1) {
            parent = index / 2;
            if (heapArray[index] > heapArray[parent]) {
                temp = heapArray[index];
                heapArray[index] = heapArray[parent];
                heapArray[parent] = temp;
                bubbleUp(parent);
            }
        }
    }

    void bubbleDown(int index) {
        int max = 0;
        int parent = index;
        int left = 2 * index;
        int right = (2 * index) + 1;
        T temp;

        // If children do not exist
        if (left > items && right > items) {
            return;
        }

        // If both children exist
        if (right <= items) {
            if (heapArray[left] >= heapArray[right]) {
                max = left;
            } else {
                max = right;
            }
        } else {
            max = left;
        }

        // If parent priority < max priority, then swap
        if (heapArray[parent] <= heapArray[max]) {
            temp = heapArray[parent];
            heapArray[parent] = heapArray[max];
            heapArray[max] = temp;
            bubbleDown(max);
        }
    }

    int getSize() const { return items; }

    void resize() {
        capacity = capacity * 2;
        T* tempHeap = heapArray;
        T* newHeap = new T[capacity];

        heapArray = newHeap;

        for (int i = 1; i <= items; i++) {
            heapArray[i] = tempHeap[i];
        }

        delete[] tempHeap;
    }
};