#include <fstream>
#include <iostream>
#include <string>
#include <vector>

/* Returns true if word is in ladder */
bool isIn(std::string word, const std::vector<std::string>& ladder) {
    for (int i = 0; i < ladder.size(); i++)
        if (word == ladder[i]) return true;
    return false;
}

int charDiff(const std::string word1, const std::string word2) {
    int len = 0;
    int diff = 0;

    if (word1.length() <= word2.length())
        len = word1.length();
    else
        len = word2.length();

    for (int i = 0; i < len; i++) {
        if (word1[i] != word2[i])
            diff++;
        if (diff > 1)
            break;
    }
    return diff;
}

bool wordLadder(std::string word, std::string finalWord, const std::vector<std::string>& words, std::vector<std::string>& ladder) {
    // Found word, return true
    if (word == finalWord) return true;

    for (int i = 0; i < words.size(); i++) {
        if (charDiff(word, words[i]) == 1) {
            if (!isIn(words[i], ladder)) {
                ladder.push_back(words[i]);
                if (wordLadder(words[i], finalWord, words, ladder)) {
                    return true;
                } else {
                    ladder.pop_back();
                    return false;
                }
            }
        }
    }
    return false;
}

int main(int argc, char* argv[]) {
    std::string input = "";
    std::string firstWord = "";
    std::string lastWord = "";
    std::ifstream infile;
    std::vector<std::string> words;
    std::vector<std::string> ladder;

    if (argc != 1) {
        std::cout << "Usage: ./wordLadder" << std::endl;
        exit(1);
    }

    std::cout << "Enter input file: ";
    std::cin >> input;

    infile.open(input);
    if (!infile.is_open()) {
        std::cout << "Error: Unable to open " << input << std::endl;
        exit(1);
    }

    std::string temp = "";
    infile >> temp;
    while (!infile.eof()) {
        words.push_back(temp);
        infile >> temp;
    }
    infile.close();

    std::cout << "Enter first word: ";
    std::cin >> firstWord;

    std::cout << "Enter last word: ";
    std::cin >> lastWord;

    ladder.push_back(firstWord);
    if (wordLadder(firstWord, lastWord, words, ladder)) {
        std::cout << "\nSuccess: Word Ladder created!\n"
                  << std::endl;
    } else {
        std::cout << "\nFailure: Word Ladder not possible!\n"
                  << std::endl;
    }

    for (int i = 0; i < ladder.size(); i++) {
        std::cout << ladder[i] << "\n";
    }
    std::cout << std::endl;
    return 0;
}