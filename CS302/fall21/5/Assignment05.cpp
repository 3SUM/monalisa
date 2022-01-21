#include <fstream>
#include <iostream>
#include <sstream>
#include <string>
#include <vector>

#include "binTree.hpp"

struct visibilityType {
    int id;
    bool camera;
    bool seen;
    bool operator==(int x) {
        return id == x;
    }
    bool operator!=(int x) {
        return id != x;
    }
};

int camera_count;

int place_cameras(binTree<visibilityType>::binTreeIterator it) {
    binTree<visibilityType>::binTreeIterator nil(NULL);

    if (it == nil) return 1;

    int L = place_cameras(it.leftChild());
    int R = place_cameras(it.rightChild());

    // Both the nodes are monitored
    if (L == 1 && R == 1)
        return 2;

    // If one of the left and the
    // right subtree is not monitored
    else if (L == 2 || R == 2) {
        camera_count++;
        return 3;
    }

    // If the root node is monitored
    return 1;
}

std::vector<visibilityType> parseLine(std::string line) {
    std::stringstream s(line);
    std::vector<visibilityType> parsedLine;
    visibilityType n;

    while (s >> n.id) {
        n.seen = false;
        n.camera = false;

        parsedLine.push_back(n);
    }

    return parsedLine;
}

int main(int argc, char *argv[]) {
    if (argc != 2) {
        std::cout << "Usage: ./Assignment05 infile" << std::endl;
        return -1;
    }

    int t_cases = 0;
    std::string temp = "";
    std::ifstream in(argv[1]);
    std::vector<std::vector<visibilityType> > trees(1, std::vector<visibilityType>(1));
    if (!in.is_open()) {
        std::cout << "Error opening infile" << std::endl;
        return -2;
    }

    getline(in, temp);
    t_cases = stoi(temp);
    for (int i = 0; i < t_cases; i++) {
        getline(in, temp);
        trees.push_back(parseLine(temp));
    }

    trees.erase(trees.begin());
    for (size_t i = 0; i < trees.size(); i++) {
        binTree<visibilityType> t;
        t.buildTree(trees[i]);
        camera_count = 0;
        int value = place_cameras(t.rootIterator());
        std::cout << camera_count + (value == 2 ? 1 : 0) << std::endl;
    }
}