#include "hashTable.h"

constexpr unsigned int hashTable ::hashSizes[];

hashTable ::hashTable() {
    entries = 0;
    reSizeCount = 0;
    collisionCount = 0;
    hashSize = initialHashSize;

    hashReviews = new std::string[initialHashSize];
    hashScores = new double[initialHashSize];
    hashCounts = new unsigned int[initialHashSize];

    for (unsigned int i = 0; i < hashSize; i++) {
        hashReviews[i] = "";
        hashScores[i] = 0;
        hashCounts[i] = 0;
    }
}

hashTable ::~hashTable() {
    delete[] hashReviews;
    delete[] hashScores;
    delete[] hashCounts;
}

bool hashTable ::insert(const std::string key, const double score) {
    unsigned int index = 0;
    unsigned int quadProbe = 0;

    if ((double(entries) / (double(hashSize))) > loadFactor) {
        reSizeCount++;
        rehash();
    }

    if (key == "")
        return false;

    index = hash(key);
    if (hashReviews[index] == key) {
        hashScores[index] += score;
        hashCounts[index]++;
        return true;
    } else if (hashReviews[index] == "") {
        entries++;
        hashReviews[index] = key;
        hashScores[index] = score;
        hashCounts[index]++;
        return true;
    } else if (hashReviews[index] != "") {
        collisionCount++;
        for (unsigned int i = 1; i < hashSize; i++) {
            quadProbe = index + pow(i, 2);
            quadProbe = quadProbe % hashSize;
            if (hashReviews[quadProbe] == "") {
                entries++;
                hashReviews[quadProbe] = key;
                hashScores[quadProbe] = score;
                hashCounts[quadProbe]++;
                return true;
            } else if (hashReviews[quadProbe] == key) {
                hashScores[quadProbe] += score;
                hashCounts[quadProbe]++;
                return true;
            }
            collisionCount++;
        }
        return false;
    }
    return false;
}

bool hashTable ::search(const std::string key, double &score, unsigned int &count) const {
    unsigned int index = 0;
    unsigned int quadProbe = 0;

    index = hash(key);
    if (hashReviews[index] == key) {
        score = hashScores[index];
        count = hashCounts[index];
        return true;
    } else {
        for (unsigned int i = 1; i < hashSize; i++) {
            quadProbe = index + pow(i, 2);
            quadProbe = quadProbe % hashSize;
            if (hashReviews[quadProbe] == key) {
                score = hashScores[quadProbe];
                count = hashCounts[quadProbe];
                return true;
            }
        }
        return false;
    }
}

bool hashTable ::remove(const std::string key) {
    unsigned int index = 0;
    unsigned int quadProbe = 0;

    index = hash(key);
    if (hashReviews[index] == key) {
        entries--;
        hashReviews[index] = "*";
        return true;
    } else {
        for (unsigned int i = 1; i < hashSize; i++) {
            quadProbe = index + pow(i, 2);
            quadProbe = quadProbe % hashSize;
            if (hashReviews[quadProbe] == key) {
                entries--;
                hashReviews[quadProbe] = "*";
                return true;
            }
        }
        return false;
    }
}

void hashTable ::printHash() const {
    for (unsigned int i = 0; i < hashSize; i++) {
        if (hashReviews[i] != "" && hashReviews[i] != "*") {
            std::cout << hashReviews[i] << " : ";
            std::cout << hashScores[i] << " : ";
            std::cout << hashCounts[i] << " : " << std::endl;
        }
    }
}

void hashTable ::showHashStats() const {
    std::cout << "Hash Stats" << std::endl;
    std::cout << "   Current Entries Count: " << entries << std::endl;
    std::cout << "   Current Hash Size: " << hashSize << std::endl;
    std::cout << "   Hash Resize Operations: " << reSizeCount << std::endl;
    std::cout << "   Hash Collisions: " << collisionCount << std::endl;
}

bool hashTable ::findMaxReview(std::string &key, double &score, unsigned int &count) {
    unsigned int max = 0;

    if (hashReviews != nullptr) {
        for (unsigned int i = 0; i < hashSize; i++) {
            if (hashCounts[i] > max) {
                max = hashCounts[i];
                key = hashReviews[i];
                score = hashScores[i];
                count = hashCounts[i];
            }
        }
        return true;
    }

    return false;
}

bool hashTable ::insert(const std::string key, const double score, const unsigned int count) {
    unsigned int index = 0;
    unsigned int quadProbe = 0;

    if (key == "")
        return false;

    index = hash(key);
    if (hashReviews[index] == key) {
        hashScores[index] += score;
        hashCounts[index] += count;
        return true;
    }
    if (hashReviews[index] == "") {
        entries++;
        hashReviews[index] = key;
        hashScores[index] = score;
        hashCounts[index] = count;
        return true;
    } else if (hashReviews[index] != "") {
        collisionCount++;
        for (unsigned int i = 1; i < hashSize; i++) {
            quadProbe = index + pow(i, 2);
            quadProbe = quadProbe % hashSize;
            if (hashReviews[quadProbe] == "") {
                entries++;
                hashReviews[quadProbe] = key;
                hashScores[quadProbe] = score;
                hashCounts[quadProbe] = count;
                return true;
            } else if (hashReviews[quadProbe] == key) {
                hashScores[quadProbe] += score;
                hashCounts[quadProbe] += count;
                return true;
            }
            collisionCount++;
        }
        return false;
    }

    return false;
}

unsigned int hashTable ::hash(std::string key) const {
    unsigned int FNV_offset_basis = 2166136261;
    unsigned int FNV_prime = 16777619;

    unsigned int hash = FNV_offset_basis;
    for (unsigned int i = 0; i < key.length(); i++) {
        hash ^= key[i];
        hash *= FNV_prime;
    }

    return (hash % hashSize);
}

void hashTable ::rehash() {
    unsigned int prevSize = hashSize;
    for (unsigned int i = 0; i < 12; i++) {
        if (hashSizes[i] > hashSize) {
            hashSize = hashSizes[i];
            break;
        }
    }

    std::string *newHashReviews = new std::string[hashSize];
    double *newHashScores = new double[hashSize];
    unsigned int *newHashCounts = new unsigned int[hashSize];

    std::string *tempReviews = hashReviews;
    double *tempScores = hashScores;
    unsigned int *tempCounts = hashCounts;

    entries = 0;

    for (unsigned int i = 0; i < hashSize; i++) {
        newHashReviews[i] = "";
        newHashScores[i] = 0;
        newHashCounts[i] = 0;
    }

    hashReviews = newHashReviews;
    hashScores = newHashScores;
    hashCounts = newHashCounts;

    for (unsigned int i = 0; i < prevSize; i++) {
        if (tempReviews[i] != "")
            insert(tempReviews[i], tempScores[i], tempCounts[i]);
    }

    delete[] tempReviews;
    delete[] tempScores;
    delete[] tempCounts;
}
