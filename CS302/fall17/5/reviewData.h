#pragma once

#include <fstream>
#include <iomanip>
#include <sstream>
#include <string>

#include "avlTree.h"

class reviewData : public avlTree<std::string> {
   public:
    reviewData();
    ~reviewData();
    bool readMasterReviewData(const std::string);
    bool getReviews(const std::string);
    void showStats() const;
    void showMaxReviews();
    void printAllReviews() const;
    void printProduct(const std::string, const double, const unsigned int);

   private:
    int totalReviews;
};
