#include <fstream>
#include <iostream>
#include <string>

#include "priorityQ.hpp"

int main(int argc, char* argv[]) {
    std::string filename = "";
    std::ifstream ifs;
    int k_th = 0;

    std::cout << "Enter filename: ";
    std::cin >> filename;

    ifs.open(filename);
    if(!ifs.is_open()) {
        std::cout << "Error opening file " << filename << std::endl;
        return -1;
    }

    ifs >> k_th;
    std::cout << "Initial " << k_th << "-th largest number:" << std::endl;
    return 0;
}