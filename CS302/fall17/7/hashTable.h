#pragma once

#include <cmath>
#include <iostream>
#include <string>

class hashTable {
   public:
    hashTable();
    ~hashTable();
    bool insert(const std::string, const double);
    bool search(const std::string, double &, unsigned int &) const;
    bool remove(const std::string);
    void printHash() const;
    void showHashStats() const;
    bool findMaxReview(std::string &, double &, unsigned int &);

   private:
    unsigned int hashSize;
    unsigned int reSizeCount;
    unsigned int collisionCount;
    unsigned int entries;
    std::string *hashReviews;
    double *hashScores;
    unsigned int *hashCounts;
    static constexpr double loadFactor = 0.65;
    static constexpr unsigned int initialHashSize = 1013;
    static constexpr unsigned int hashSizes[12] = {30011, 60013, 120017, 240089, 480043, 960017, 1920013, 3840037, 7680103, 15360161, 30720299, 61440629};
    bool insert(const std::string, const double, const unsigned int);
    unsigned int hash(std::string) const;
    void rehash();
};
