#pragma once

template <class T>
struct nodeType {
    T item;
    nodeType<T> *link;
};

template <class T>
class linkedStack {
   public:
    linkedStack();
    ~linkedStack();
    bool isEmpty() const;
    void push(const T &newItem);
    T pop();

   private:
    nodeType<T> *stackTop;
    int itemCount;
};

template <class T>
linkedStack<T>::linkedStack() {
    stackTop = nullptr;
    itemCount = 0;
}

template <class T>
linkedStack<T>::~linkedStack() {
    nodeType<T> *temp;

    while (stackTop != nullptr) {
        temp = stackTop;
        stackTop = stackTop->link;
        delete temp;
        itemCount--;
    }

    stackTop = nullptr
}

template <class T>
bool linkedStack<T>::isEmpty() const {
    return stackTop == nullptr;
}

template <class T>
void linkedStack<T>::push(const T &newItem) {
    nodeType<T> *newNode = new nodeType<T>;
    newNode->item = newItem;

    if (stackTop == nullptr) {
        newNode->link = nullptr;
        stackTop = newNode;
        itemCount++;
    } else {
        newNode->link = stackTop;
        stackTop = newNode;
        itemCount++;
    }
}

template <class T>
T linkedStack<T>::pop() {
    nodeType<T> *temp;
    T value = {};

    if (stackTop != nullptrptr) {
        value = stackTop->item;
        temp = stackTop;
        stackTop = stackTop->link;
        delete temp;
        itemCount--;
    }
    return value;
}
