#include <cstdlib>
#include <iostream>
#include <vector>

#include "binTree.hpp"
using namespace std;

void preorder(binTree<int>::binTreeIterator it) {
    binTree<int>::binTreeIterator nil(NULL);

    if (it != nil) {
        cout << *it << endl;
        preorder(it.leftChild());
        preorder(it.rightChild());
    }

    return;
}

void updateNodes(binTree<int>::binTreeIterator it) {
    binTree<int>::binTreeIterator nil(NULL);

    if (it != nil) {
        (*it)++;
        updateNodes(it.leftChild());
        updateNodes(it.rightChild());
    }

    return;
}

int main() {
    binTree<int> t1;
    binTree<int> t2;

    vector<int> v1 = {1, 2, -1, 3, 4};
    vector<int> v2 = {1, 2, -1, 3, -1, -1, -1, 4};

    t1.buildTree(v1);
    t2.buildTree(v2);

    binTree<int> t3(t2);

    updateNodes(t3.rootIterator());

    t1 = t3;

    updateNodes(t1.rootIterator());

    cout << "t1" << endl;
    preorder(t1.rootIterator());
    cout << endl;

    cout << "t2" << endl;
    preorder(t2.rootIterator());
    cout << endl;

    cout << "t3" << endl;
    preorder(t3.rootIterator());
    cout << endl;

    return 0;
}