#include "disjointSets.h"

disjointSets::disjointSets() {
    totalSize = 0;
    setsCount = 0;
    links = NULL;
    sizes = NULL;
}

disjointSets::~disjointSets() {
    totalSize = 0;
    setsCount = 0;
    delete[] links;
    delete[] sizes;
}

bool disjointSets::createSets(int size) {
    if (size >= MIN_SIZE && size <= MAX_SIZE) {
        totalSize = size;
        setsCount = size;
        links = new int[size];
        sizes = new int[size];
        for (int i = 0; i < size; i++) {
            links[i] = -1;
            sizes[i] = 1;
        }
        return true;
    }
    return false;
}

int disjointSets::getTotalSets() const {
    return totalSize;
}

int disjointSets::getSetCount() const {
    return setsCount;
}

int disjointSets::getSetSize(const int set) const {
    return sizes[set];
}

void disjointSets::printSets() const {
    std::cout << "  index:" << std::setw(3);
    for (int i = 0; i < totalSize; i++)
        std::cout << i << std::setw(3);
    std::cout << std::endl;

    std::cout << "  links:" << std::setw(3);
    for (int i = 0; i < totalSize; i++)
        std::cout << links[i] << std::setw(3);
    std::cout << std::endl;

    std::cout << "  sizes:" << std::setw(3);
    for (int i = 0; i < totalSize; i++)
        std::cout << sizes[i] << std::setw(3);
    std::cout << std::endl;
}

int disjointSets::setUnion(int a, int b) {
    int x = setFind(a);
    int y = setFind(b);

    if (x != y) {
        if (sizes[x] >= sizes[y]) {
            setsCount--;
            links[y] = x;
            sizes[x] += sizes[y];
            sizes[y] = 0;
            return x;
        } else {
            setsCount--;
            links[x] = y;
            sizes[y] += sizes[x];
            sizes[x] = 0;
            return y;
        }
    }
    return x;
}

int disjointSets::setFind(int set) {
    if (links[set] != -1)
        return links[set] = setFind(links[set]);
    return set;
}
