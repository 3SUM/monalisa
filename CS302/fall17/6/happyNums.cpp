#include <chrono>
#include <iostream>
#include <mutex>
#include <sstream>
#include <string>
#include <thread>

std::mutex myMutex;

int threadCount = 0;
int limitValue = 0;
int numCounter = 0;
int happyCounter = 0;

void setHappy() {
    std::lock_guard<std::mutex> guard(myMutex);
    happyCounter++;
}

int getNext() {
    std::lock_guard<std::mutex> guard(myMutex);
    return numCounter += 100;
}

bool isHappy(int num) {
    int squareSum = 0;

    while (1) {
        squareSum = 0;

        while (num != 0) {
            squareSum += (num % 10) * (num % 10);
            num -= (num % 10);
            num /= 10;
        }

        num = squareSum;

        if (squareSum == 1) {
            return true;
        } else if (squareSum == 4) {
            return false;
        }
    }
}

void happyCount() {
    int end = 0;
    while ((end = getNext()) <= limitValue) {
        for (int i = end - 99; i <= end; i++) {
            if (isHappy(i))
                setHappy();
        }
    }
}

int main(int argc, char *argv[]) {
    std::string stars;
    stars.append(65, '*');
    std::stringstream mySS;

    if (argc == 1) {
        std::cout << "Usage: ./happyNums -t <threadCount> -l <limitValue>" << std::endl;
        exit(1);
    }

    if (argc != 5) {
        std::cout << "Error, invalid command line options." << std::endl;
        exit(1);
    }

    if (std::string(argv[1]) != "-t") {
        std::cout << "Error, invalid thread count specifier." << std::endl;
        exit(1);
    }

    if (std::string(argv[3]) != "-l") {
        std::cout << "Error, invalid limit value specifier." << std::endl;
        exit(1);
    }

    mySS << argv[2];
    mySS >> threadCount;
    mySS.clear();

    mySS << argv[4];
    mySS >> limitValue;

    if (threadCount <= 0) {
        std::cout << "Error, invalid thread count." << std::endl;
        exit(1);
    }

    if (limitValue <= 0) {
        std::cout << "Error, invalid limit value." << std::endl;
        exit(1);
    }

    std::cout << stars << std::endl;
    std::cout << "Luis Maya - CS 302 - Assignment #6" << std::endl;
    std::cout << "Happy Numbers Program" << std::endl
              << std::endl;

    auto t1 = std::chrono::high_resolution_clock::now();

    std::thread *t = new std::thread[threadCount];

    for (int i = 0; i < threadCount; i++)
        t[i] = std::thread(happyCount);

    for (int i = 0; i < threadCount; i++)
        t[i].join();

    auto t2 = std::chrono::high_resolution_clock::now();

    std::cout << stars << std::endl;
    std::cout << "Program Statistics: " << std::endl
              << std::endl;
    std::cout << "   Thread Count: " << threadCount << std::endl;
    std::cout << "   Limit Value: " << limitValue << std::endl;
    std::cout << "   Happy Numbers Count: " << happyCounter << std::endl;
    std::cout << "   Unhappy Numbers Count: " << (limitValue - happyCounter) << std::endl
              << std::endl;

    std::cout << "Program took: " << std::chrono::duration_cast<std::chrono::milliseconds>(t2 - t1).count()
              << " milliseconds" << std::endl;

    std::cout << stars << std::endl
              << "Game Over, thank you for playing." << std::endl;

    delete[] t;

    return 0;
}
