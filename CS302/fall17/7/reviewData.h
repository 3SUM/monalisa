#pragma once

#include <cstdlib>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <sstream>
#include <string>

#include "hashTable.h"

class reviewData : public hashTable {
   public:
    reviewData();
    ~reviewData();
    bool readMasterReviewData(const std::string);
    bool getReviews(const std::string);
    void showStats() const;
    void showMaxReview();
    void printAllReviews() const;
    void printProduct(const std::string, const double, const unsigned int);

   private:
    unsigned int totalReviews;
    unsigned int uniqueProducts;
};
