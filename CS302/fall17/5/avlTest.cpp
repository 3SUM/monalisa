//  Main program for testing

#include <cstdlib>
#include <iostream>
#include <string>

#include "avlTree.h"

using namespace std;

int main() {
    // *****************************************************************
    //  Headers...

    string bars, stars;
    bars.append(30, '-');
    stars.append(65, '*');

    cout << stars << endl
         << "CS 302 - AVL Tree Test Program" << endl;
    cout << endl;

    // *****************************************************************
    //  Test Trie

    avlTree<string> myTree0;
    string words0[10] = {"the", "a", "there", "answer", "any",
                         "by", "bye", "their", "ball", "balloon"};
    int len0 = 10;
    unsigned int cnt0;
    double scr0;

    cout << bars << endl
         << "Test Set #0  (" << len0 << ")"
         << endl
         << endl;

    for (int i = 0; i < len0; i++)
        myTree0.insert(words0[i], static_cast<double>(i));

    for (int i = 0; i < len0; i++)
        if (!myTree0.search(words0[i], scr0, cnt0))
            cout << "main: Error, word "
                    " "
                 << words0[i]
                 << " "
                    " is lost."
                 << endl;

    cout << "Max Height: " << myTree0.height() << endl;
    cout << "Node Count: " << myTree0.countNodes() << endl;

    cout << "Tree: " << endl;
    myTree0.printTree();

    myTree0.destroyTree();
    if (myTree0.height() != 0 || myTree0.countNodes() != 0)
        cout << "Error, invalid tree." << endl;
    cout << endl;

    // *****************************************************************

    avlTree<string> myTree1;
    string words1[50] = {"aah", "aahed", "aahing", "aahs", "aal",
                         "aalii", "aaliis", "aals", "aardvark",
                         "aardwolf", "aargh", "aarrgh", "aarrghh", "aas",
                         "aasvogel", "ab", "aba", "abaca", "abacas",
                         "abaci", "aback", "abacus", "abacuses", "abaft",
                         "abaka", "abakas", "abalone", "abalones", "abamp",
                         "abampere", "abamps", "abandon", "abandons",
                         "abapical", "abas", "abase", "abased", "abasedly",
                         "abaser", "abasers", "abases", "abash", "abashed",
                         "abashes", "abashing", "abasia", "abasias",
                         "abasing", "abatable", "abate"};
    int len1 = 50;
    unsigned int cnt1;
    double scr1;

    cout << bars << endl
         << "Test Set #1  (" << len1 << ")"
         << endl
         << endl;

    for (int i = 0; i < len1; i++)
        myTree1.insert(words1[i], static_cast<double>(i));

    for (int i = 0; i < len1; i++)
        if (!myTree1.search(words1[i], scr1, cnt1))
            cout << "main: Error, word "
                    " "
                 << words1[i]
                 << " "
                    " is lost."
                 << endl;

    cout << "Max Height: " << myTree1.height() << endl;
    cout << "Node Count: " << myTree1.countNodes() << endl;

    cout << "Tree: " << endl;
    myTree1.printTree();
    cout << endl;

    // *****************************************************************
    //  Duplicates should be ignored...

    avlTree<string> myTree2;
    string words2[25] = {"a", "ab", "ac", "ad", "ae",
                         "af", "aba", "abb", "abc", "abd",
                         "abe", "abf", "abaa", "abab", "abac",
                         "abad", "abae", "abaf", "abaa", "abab",
                         "a", "ab", "ac", "ad", "ae"};
    int len2 = 25;
    unsigned int cnt2;
    double scr2;

    cout << bars << endl
         << "Test Set #2  (" << len2 << ")"
         << endl
         << endl;

    for (int i = 0; i < len2; i++)
        myTree2.insert(words2[i], static_cast<double>(i));

    for (int i = 0; i < len2; i++)
        if (!myTree2.search(words2[i], scr2, cnt2))
            cout << "main: Error, word "
                    " "
                 << words2[i]
                 << " "
                    " is lost."
                 << endl;

    cout << "Max Height: " << myTree2.height() << endl;
    cout << "Node Count: " << myTree2.countNodes() << endl;

    cout << "Tree: " << endl;
    myTree2.printTree();
    cout << endl;

    // *****************************************************************
    //  Test for height...

    avlTree<string> myTree3;
    string words3[30] = {"a", "aa", "aaa", "aaaa", "aaaaa",
                         "aaaaaa",
                         "aaaaaaa",
                         "aaaaaaaa",
                         "aaaaaaaaa",
                         "aaaaaaaaaa",
                         "aaaaaaaaaaa",
                         "aaaaaaaaaaaa",
                         "aaaaaaaaaaaaa",
                         "aaaaaaaaaaaaaa",
                         "aaaaaaaaaaaaaaa",
                         "aaaaaaaaaaaaaaaa",
                         "aaaaaaaaaaaaaaaaa",
                         "aaaaaaaaaaaaaaaaaa",
                         "aaaaaaaaaaaaaaaaaaa",
                         "aaaaaaaaaaaaaaaaaaaa",
                         "aaaaaaaaaaaaaaaaaaaaa",
                         "aaaaaaaaaaaaaaaaaaaaaa",
                         "aaaaaaaaaaaaaaaaaaaaaaa",
                         "aaaaaaaaaaaaaaaaaaaaaaaa",
                         "aaaaaaaaaaaaaaaaaaaaaaaaa",
                         "aaaaaaaaaaaaaaaaaaaaaaaaaa",
                         "aaaaaaaaaaaaaaaaaaaaaaaaaaa",
                         "aaaaaaaaaaaaaaaaaaaaaaaaaaaa",
                         "aaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
                         "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"};
    int len3 = 30;
    unsigned int cnt3;
    double scr3;

    cout << bars << endl
         << "Test Set #3  (" << len3 << ")"
         << endl
         << endl;

    for (int i = 0; i < len3; i++)
        myTree3.insert(words3[i], static_cast<double>(i));

    for (int i = 0; i < len3; i++)
        if (!myTree3.search(words3[i], scr3, cnt3))
            cout << "main: Error, word "
                    " "
                 << words3[i]
                 << " "
                    " is lost."
                 << endl;

    cout << "Max Height: " << myTree3.height() << endl;
    cout << "Node Count: " << myTree3.countNodes() << endl;

    cout << "Tree: " << endl;
    myTree3.printTree();
    cout << endl;

    // *****************************************************************
    //  All done.

    cout << bars << endl
         << "Game Over, thank you for playing." << endl;

    return 0;
}
