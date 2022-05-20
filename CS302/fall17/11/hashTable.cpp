#include "hashTable.h"

constexpr unsigned int hashTable::hashSizes[];

hashTable::hashTable() {
    entries = 0;
    reSizeCount = 0;
    collisionCount = 0;
    hashSize = initialHashSize;

    hash_Table = new hashNode[initialHashSize];
    for (unsigned int i = 0; i < hashSize; i++) {
        hash_Table[i].location = "";
        hash_Table[i].source = -1;
    }
}

hashTable::~hashTable() {
    delete[] hash_Table;
}

bool hashTable::insert(const std::string key, const int src) {
    unsigned int index = 0;
    unsigned int quadProbe = 0;

    if ((double(entries) / (double(hashSize))) > loadFactor) {
        reSizeCount++;
        rehash();
    }

    if (key == "")
        return false;

    index = hash(key);

    if (hash_Table[index].location == key)
        return true;
    else if (hash_Table[index].location == "") {
        entries++;
        hash_Table[index].location = key;
        hash_Table[index].source = src;
        return true;
    } else if (hash_Table[index].location != "") {
        collisionCount++;

        for (unsigned int i = 1; i < hashSize; i++) {
            quadProbe = index + pow(i, 2);
            quadProbe = quadProbe % hashSize;
            if (hash_Table[quadProbe].location == "") {
                entries++;

                hash_Table[quadProbe].location = key;

                hash_Table[quadProbe].source = src;
                return true;
            }

            else if (hash_Table[quadProbe].location == key)
                return true;

            collisionCount++;
        }

        return false;
    }
    return false;
}

bool hashTable::search(const std::string key, int &src) const {
    unsigned int index = 0;
    unsigned int quadProbe = 0;

    index = hash(key);

    if (hash_Table[index].location == key) {
        src = hash_Table[index].source;
        return true;
    } else if (hash_Table[index].location == "")
        return false;
    else if (hash_Table[index].location != "") {
        for (unsigned int i = 1; i < hashSize; i++) {
            quadProbe = index + pow(i, 2);
            quadProbe = quadProbe % hashSize;
            if (hash_Table[quadProbe].location == key) {
                src = hash_Table[quadProbe].source;
                return true;
            }

            else if (hash_Table[quadProbe].location == "")
                return false;
        }
        return false;
    }
    return false;
}

bool hashTable::pinsert(const std::string key, const int src) {
    unsigned int index = 0;
    unsigned int quadProbe = 0;

    if (key == "")
        return false;

    index = hash(key);

    if (hash_Table[index].location == key) {
        return true;
    }

    if (hash_Table[index].location == "") {
        entries++;
        hash_Table[index].location = key;
        hash_Table[index].source = src;
        return true;
    } else if (hash_Table[index].location != "") {
        collisionCount++;
        for (unsigned int i = 1; i < hashSize; i++) {
            quadProbe = index + pow(i, 2);
            quadProbe = quadProbe % hashSize;
            if (hash_Table[quadProbe].location == "") {
                entries++;
                hash_Table[quadProbe].location = key;
                hash_Table[quadProbe].source = src;
                return true;
            } else if (hash_Table[quadProbe].location == key) {
                return true;
            }
            collisionCount++;
        }
        return false;
    }
    return false;
}

unsigned int hashTable::hash(std::string key) const {
    unsigned int FNV_offset_basis = 2166136261;
    unsigned int FNV_prime = 16777619;

    unsigned int hash = FNV_offset_basis;

    for (unsigned int i = 0; i < key.length(); i++) {
        hash ^= key[i];
        hash *= FNV_prime;
    }
    return (hash % hashSize);
}

void hashTable::rehash() {
    unsigned int prevSize = hashSize;
    for (unsigned int i = 0; i < 12; i++) {
        if (hashSizes[i] > hashSize) {
            hashSize = hashSizes[i];
            break;
        }
    }

    hashNode *newTable = new hashNode[hashSize];
    hashNode *tempTable = hash_Table;

    entries = 0;

    for (unsigned int i = 0; i < hashSize; i++) {
        newTable[i].location = "";
        newTable[i].source = -1;
    }

    hash_Table = newTable;

    for (unsigned int i = 0; i < prevSize; i++) {
        if (tempTable[i].location != "")
            pinsert(tempTable[i].location, tempTable[i].source);
    }
    delete[] tempTable;
}
