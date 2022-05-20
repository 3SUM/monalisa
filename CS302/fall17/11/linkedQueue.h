#pragma once

#include <cstdlib>
#include <iostream>
#include <string>

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
    head = NULL;
    tail = NULL;
    count = 0;
}

template <class T>
linkedQueue<T>::~linkedQueue() {
    queueNode<T> *temp;

    while (head != NULL) {
        temp = head;
        head = head->next;
        delete temp;
    }

    head = tail = NULL;
}

template <class T>
bool linkedQueue<T>::isEmptyQueue() const {
    return (head == NULL);
}

template <class T>
void linkedQueue<T>::enqueue(const T &key) {
    queueNode<T> *newNode = new queueNode<T>;

    newNode->key = key;
    newNode->next = NULL;

    if (head == NULL) {
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

    if (head != NULL) {
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

    while (temp != NULL) {
        cout << temp->key << " ";
        temp = temp->next;
    }

    delete temp;
}
