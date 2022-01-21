#pragma once

#include <vector>

template <typename T>
class binTree {
    struct binTreeNode {
        T data;
        binTreeNode *left;
        binTreeNode *right;
    };

   public:
    class binTreeIterator {
       public:
        friend class binTree;
        binTreeIterator();
        binTreeIterator(binTreeNode *);
        binTreeIterator leftChild() const;
        binTreeIterator rightChild() const;
        T &operator*() const;
        bool operator==(const binTreeIterator &) const;
        bool operator!=(const binTreeIterator &) const;

       private:
        binTreeNode *binTreeNodePointer;
    };
    binTree();
    binTree(const binTree<T> &);
    const binTree &operator=(const binTree<T> &);
    ~binTree();
    void buildTree(std::vector<T>);
    binTreeIterator rootIterator() const;

   private:
    void destroyTree(binTreeNode *);
    void copyTree(binTreeNode *, binTreeNode *);
    void buildTree(std::vector<T>, binTreeNode *, int);
    binTreeNode *root;
};

template <typename T>
binTree<T>::binTreeIterator::binTreeIterator() {
    binTreeNodePointer = nullptr;
}

template <typename T>
binTree<T>::binTreeIterator::binTreeIterator(binTreeNode *ptr) {
    binTreeNodePointer = ptr;
}

template <typename T>
typename binTree<T>::binTreeIterator binTree<T>::binTreeIterator::leftChild() const {
    return binTreeNodePointer->left;
}

template <typename T>
typename binTree<T>::binTreeIterator binTree<T>::binTreeIterator::rightChild() const {
    return binTreeNodePointer->right;
}

template <typename T>
T &binTree<T>::binTreeIterator::operator*() const {
    return binTreeNodePointer->data;
}

template <typename T>
bool binTree<T>::binTreeIterator::operator==(const binTree<T>::binTreeIterator &rhs) const {
    return binTreeNodePointer == rhs.binTreeNodePointer ? true : false;
}

template <typename T>
bool binTree<T>::binTreeIterator::operator!=(const binTree<T>::binTreeIterator &rhs) const {
    return binTreeNodePointer != rhs.binTreeNodePointer ? true : false;
}

template <typename T>
binTree<T>::binTree() {
    root = nullptr;
}

template <typename T>
binTree<T>::binTree(const binTree<T> &copy) {
    root = new binTreeNode;
    root->data = copy.root->data;
    copyTree(root, copy.root);
}

template <typename T>
const binTree<T> &binTree<T>::operator=(const binTree<T> &rhs) {
    if (root) {
        destroyTree(root);
    }

    root = new binTreeNode;
    root->data = rhs.root->data;
    copyTree(root, rhs.root);
    return *this;
}

template <typename T>
binTree<T>::~binTree() {
    destroyTree(root);
}

template <typename T>
void binTree<T>::buildTree(std::vector<T> treeValues) {
    root = new binTreeNode;
    root->data = treeValues[0];
    root->left = nullptr;
    root->right = nullptr;
    buildTree(treeValues, root, 0);
}

template <typename T>
void binTree<T>::buildTree(std::vector<T> treeValues, binTreeNode *r, int index) {
    int left_index = (index * 2) + 1;
    int right_index = (index + 1) * 2;

    if (treeValues[left_index] != -1 && left_index < treeValues.size()) {
        r->left = new binTreeNode;
        r->left->data = treeValues[left_index];
        r->left->left = nullptr;
        r->left->right = nullptr;
        buildTree(treeValues, r->left, left_index);
    } else {
        r->left = nullptr;
    }

    if (treeValues[right_index] != -1 && right_index < treeValues.size()) {
        r->right = new binTreeNode;
        r->right->data = treeValues[right_index];
        r->right->left = nullptr;
        r->right->right = nullptr;
        buildTree(treeValues, r->right, right_index);
    } else {
        r->right = nullptr;
    }
}

template <typename T>
typename binTree<T>::binTreeIterator binTree<T>::rootIterator() const {
    return binTreeIterator(root);
}

template <typename T>
void binTree<T>::destroyTree(binTreeNode *r) {
    if (r != nullptr) {
        destroyTree(r->left);
        destroyTree(r->right);
        r->left = nullptr;
        r->right = nullptr;
        r = nullptr;
        delete r;
    }
}

template <typename T>
void binTree<T>::copyTree(binTreeNode *i, binTreeNode *j) {
    if (j->left) {
        i->left = new binTreeNode;
        i->left->data = j->left->data;
        i->left->left = nullptr;
        i->left->right = nullptr;
        copyTree(i->left, j->left);
    } else {
        i->left = nullptr;
    }

    if (j->right) {
        i->right = new binTreeNode;
        i->right->data = j->right->data;
        i->right->left = nullptr;
        i->right->right = nullptr;
        copyTree(i->right, j->right);
    } else {
        i->right = nullptr;
    }
}
