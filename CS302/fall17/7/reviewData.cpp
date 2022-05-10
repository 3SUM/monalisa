#include "reviewData.h"

reviewData ::reviewData() {
    totalReviews = 0;
    uniqueProducts = 0;
}

reviewData ::~reviewData() {
    totalReviews = 0;
    uniqueProducts = 0;
}

bool reviewData ::readMasterReviewData(const std::string fname) {
    double score;
    std::string temp;
    std::string product;
    std::ifstream input;

    input.open(fname.c_str());

    if (input.is_open()) {
        input >> temp;
        input >> temp;

        while (input) {
            product = temp;

            for (int i = 0; i < 4; i++)
                input.ignore(90000, '\n');

            input >> temp;
            input >> temp;

            score = stod(temp);

            insert(product, score);
            totalReviews++;

            for (int i = 0; i < 4; i++)
                input.ignore(90000, '\n');

            input >> temp;
            input >> temp;
        }

        input.close();
        return true;
    }

    return false;
}

bool reviewData ::getReviews(const std::string fname) {
    std::string product;
    double score;
    unsigned int count;
    std::ifstream input;
    std::string stars, bars;

    stars.append(47, '*');
    bars.append(13, '-');

    input.open(fname.c_str());

    if (input.is_open()) {
        std::cout << stars << std::endl
                  << std::endl;
        std::cout << "Reviews List:" << std::endl;
        std::cout << bars << std::endl;

        input >> product;
        while (input) {
            if (search(product, score, count)) {
                std::cout << "prod: " << product << std::endl;
                printProduct(product, score, count);

            } else
                std::cout << "Product: " << product << " not found." << std::endl;

            input >> product;
        }
        std::cout << std::endl;
        input.close();
        return true;
    }
    return false;
}

void reviewData ::showStats() const {
    std::string bars;
    bars.append(38, '-');

    std::cout << bars << std::endl;
    std::cout << "Review Data Statistics:" << std::endl
              << std::endl;
    std::cout << "Review Hash Stats:" << std::endl;

    showHashStats();

    std::cout << std::endl;
    std::cout << "Review Data Stats:" << std::endl;
    std::cout << "   Total Reviews: " << totalReviews << std::endl;
    std::cout << std::endl;
}

void reviewData ::showMaxReview() {
    std::string product;
    double score;
    unsigned int count = 0;

    std::string bars;
    bars.append(20, '-');

    if (findMaxReview(product, score, count)) {
        std::cout << std::endl;
        std::cout << bars << std::endl;
        printProduct(product, score, count);
    }
}

void reviewData ::printAllReviews() const {
    printHash();
}

void reviewData ::printProduct(const std::string product, const double score, const unsigned int count) {
    double avg = score / count;

    std::cout << std::fixed << std::showpoint << std::setprecision(2);

    std::cout << "Product: " << product << std::endl;
    std::cout << "  Avg Score: " << avg << std::endl;
    std::cout << "  Reviews:   " << count << std::endl
              << std::endl;
}
