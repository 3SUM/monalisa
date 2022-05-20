#pragma once

#include <cmath>
#include <iostream>
#include <string>

struct hashNode {
    std::string location;
    int source;
};

class hashTable {
   public:
    hashTable();
    ~hashTable();
    bool insert(const std::string, const int);
    bool search(const std::string, int &) const;

   private:
    unsigned int hashSize;
    unsigned int reSizeCount;
    unsigned int collisionCount;
    unsigned int entries;
    hashNode *hash_Table;
    static constexpr double loadFactor = 0.65;
    static constexpr unsigned int initialHashSize = 1013;
    static constexpr unsigned int hashSizes[12] = {30011, 60013, 120017, 240089, 480043, 960017, 1920013, 3840037, 7680103, 15360161, 30720299, 61440629};
    bool pinsert(const std::string, const int);
    unsigned int hash(std::string) const;
    void rehash();
};
