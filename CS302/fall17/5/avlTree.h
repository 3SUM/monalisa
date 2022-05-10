#pragma once

#include <iomanip>
#include <iostream>
#include <string>

template <class T>
struct Node {
    T keyValue;
    double score;
    unsigned int count;
    Node<T> *left;
    Node<T> *right;
};

template <class T>
class avlTree {
   public:
    avlTree();
    ~avlTree();
    void destroyTree();
    int countNodes() const;
    int height() const;
    void printTree() const;
    bool search(T, double &, unsigned int &) const;
    void insert(T, double);
    bool findMaxReview(std::string &, double &, unsigned int &);

   private:
    Node<T> *root;
    void destroyTree(Node<T> *);
    int countNodes(Node<T> *) const;
    int height(Node<T> *) const;
    void printTree(Node<T> *) const;
    Node<T> *search(T, Node<T> *) const;
    void findMaxReview(Node<T> *, std::string &, double &, unsigned int &);
    Node<T> *insert(T, double, Node<T> *);
    Node<T> *rightRotate(Node<T> *);
    Node<T> *leftRotate(Node<T> *);
    int getBalance(Node<T> *) const;
};

template <class T>
avlTree<T>::avlTree() {
    root = nullptr;
}

template <class T>
avlTree<T>::~avlTree() {
    if (root != nullptr)
        destroyTree(root);

    root = nullptr;
}

template <class T>
void avlTree<T>::destroyTree() {
    destroyTree(root);

    root = nullptr;
}

template <class T>
int avlTree<T>::countNodes() const {
    return countNodes(root);
}

template <class T>
int avlTree<T>::height() const {
    return height(root);
}

template <class T>
void avlTree<T>::printTree() const {
    std::string bars;
    bars.append(22, '-');

    std::cout << "Complete Tree: (debug)" << std::endl;
    std::cout << bars << std::endl;

    printTree(root);

    std::cout << endl;
}

template <class T>
bool avlTree<T>::search(T key, double &score, unsigned int &count) const {
    Node<T> *temp = new Node<T>;
    temp = search(key, root);

    if (temp != nullptr) {
        score = temp->score;
        count = temp->count;
        return true;
    }
    return false;
}

template <class T>
void avlTree<T>::insert(T key, double score) {
    root = insert(key, score, root);
}

template <class T>
bool avlTree<T>::findMaxReview(std::string &key, double &score, unsigned int &reviews) {
    if (root == nullptr)
        return false;
    else {
        findMaxReview(root, key, score, reviews);
        return true;
    }
}

template <class T>
void avlTree<T>::destroyTree(Node<T> *node) {
    if (node != nullptr) {
        destroyTree(node->left);
        destroyTree(node->right);
        node->left = nullptr;
        node->right = nullptr;
        node = nullptr;
        delete node;
    }
}

template <class T>
int avlTree<T>::countNodes(Node<T> *node) const {
    if (node == nullptr)
        return 0;

    return 1 + countNodes(node->left) + countNodes(node->right);
}

template <class T>
int avlTree<T>::height(Node<T> *node) const {
    if (node == nullptr)
        return 0;

    return 1 + max(height(node->left), height(node->right));
}

template <class T>
void avlTree<T>::printTree(Node<T> *node) const {
    if (node != nullptr) {
        printTree(node->left);
        printTree(node->right);
        std::cout << std::fixed << std::showpoint << std::setprecision(2);
        std::cout << node->keyValue << "  " << node->score << "  " << node->count << std::endl;
    }
}

template <class T>
Node<T> *avlTree<T>::search(T key, Node<T> *node) const {
    if (node == nullptr)
        return nullptr;
    else {
        if (key == node->keyValue)
            return node;
        else {
            if (key < node->keyValue)
                return search(key, node->left);
            else if (key > node->keyValue)
                return search(key, node->right);
        }
    }

    return nullptr;
}

template <class T>
void avlTree<T>::findMaxReview(Node<T> *node, std::string &key, double &score, unsigned int &reviews) {
    if (node != nullptr) {
        if (node->count > reviews) {
            key = node->keyValue;
            score = node->score;
            reviews = node->count;
        }
        findMaxReview(node->left, key, score, reviews);
        findMaxReview(node->right, key, score, reviews);
    }
}

template <class T>
Node<T> *avlTree<T>::insert(T key, double score, Node<T> *node) {
    int balance;

    if (node == nullptr) {
        node = new Node<T>;
        node->keyValue = key;
        node->score = score;
        node->count = 1;
        node->left = nullptr;
        node->right = nullptr;
        return node;
    } else if (key < node->keyValue)
        node->left = insert(key, score, node->left);
    else if (key > node->keyValue)
        node->right = insert(key, score, node->right);
    else if (key == node->keyValue) {
        node->score += score;
        node->count += 1;
    }

    balance = getBalance(node);

    if (balance > 1 && key < node->left->keyValue)
        return rightRotate(node);
    if (balance < -1 && key > node->right->keyValue)
        return leftRotate(node);
    if (balance > 1 && key > node->left->keyValue) {
        node->left = leftRotate(node->left);
        return rightRotate(node);
    }
    if (balance < -1 && key < node->right->keyValue) {
        node->right = rightRotate(node->right);
        return leftRotate(node);
    }

    return node;
}

template <class T>
int avlTree<T>::getBalance(Node<T> *node) const {
    return height(node->left) - height(node->right);
}

template <class T>
Node<T> *avlTree<T>::rightRotate(Node<T> *y) {
    Node<T> *x = y->left;

    y->left = x->right;
    x->right = y;

    return x;
}

template <class T>
Node<T> *avlTree<T>::leftRotate(Node<T> *x) {
    Node<T> *y = x->right;

    x->right = y->left;
    y->left = x;

    return y;
}
