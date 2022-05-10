#pragma once

#include <iomanip>
#include <iostream>

class disjointSets {
   public:
    disjointSets();
    ~disjointSets();
    bool createSets(int);
    int getTotalSets() const;
    int getSetCount() const;
    int getSetSize(const int) const;
    void printSets() const;
    int setUnion(int, int);
    int setFind(int);

   private:
    int totalSize;
    int setsCount;
    int *links;
    int *sizes;
    static constexpr int MIN_SIZE = 10;
    static constexpr int MAX_SIZE = 3500000;
};
