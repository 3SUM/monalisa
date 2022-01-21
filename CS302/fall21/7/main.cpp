#include <iostream>
#include <string>
#include <vector>

#include "hashMap.hpp"

int main() {
    hashMap<char, int> testMap;
    std::vector<char> letters;

    for (int i = 0; i < 90; i++)
        letters.push_back('!' + i);

    for (int i = 0; i < letters.size(); i++)
        testMap[letters[i]] = i;

    for (int i = 0; i < letters.size(); i++)
        std::cout << testMap[letters[i]] << std::endl;

    return 0;
}