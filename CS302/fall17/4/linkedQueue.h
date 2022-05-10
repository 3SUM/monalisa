#pragma once

#include <iostream>

template <class T>
struct queueNode {
    T key;
    queueNode<T> *next;
};

template <class T>
class linkedQueue {
   public:
    linkedQueue();
    ~linkedQueue();
    bool isEmptyQueue() const;
    void enqueue(const T &);
    T dequeue();
    void printQueue();

   private:
    queueNode<T> *head;
    queueNode<T> *tail;
    int count;
};

template <class T>
linkedQueue<T>::linkedQueue() {
    head = nullptr;
    tail = nullptr;
    count = 0;
}

template <class T>
linkedQueue<T>::~linkedQueue() {
    queueNode<T> *temp;

    while (head != nullptr) {
        temp = head;
        head = head->next;
        delete temp;
        count--;
    }

    head = tail = nullptr;
}

template <class T>
bool linkedQueue<T>::isEmptyQueue() const {
    return (head == nullptr);
}

template <class T>
void linkedQueue<T>::enqueue(const T &key) {
    queueNode<T> *newNode = new queueNode<T>;

    newNode->key = key;
    newNode->next = nullptr;

    if (head == nullptr) {
        head = tail = newNode;
        count++;
    } else {
        tail->next = newNode;
        tail = newNode;
        count++;
    }
}

template <class T>
T linkedQueue<T>::dequeue() {
    queueNode<T> *temp;
    T value = {};

    if (head != nullptr) {
        value = head->key;
        temp = head;
        head = head->next;
        delete temp;
        count--;
    }
    return value;
}

template <class T>
void linkedQueue<T>::printQueue() {
    queueNode<T> *temp = head;

    while (temp != nullptr) {
        std::cout << temp->key << " ";
        temp = temp->next;
    }
}
