#pragma once

#include <iostream>

template <typename K, typename V>
class hashMap {
    const double LOAD_FACTOR = 0.5;
    int items;
    int tableSize;
    struct tableItem {
        K key;
        V value;
    };
    tableItem *table1;
    tableItem *table2;

    int h1(char key) const {
        return key >= 'A' ? (key - 50) % tableSize : (key + 20) % tableSize;
    }

    int h2(char key) const {
        return key >= 'a' ? (key - 90) % tableSize : (key + 50) % tableSize;
    }

    void resize() {
        int prev_size = tableSize;
        hashMap<K, V> prev_map(*this);
        tableSize *= 2;

        delete[] table1;
        delete[] table2;

        items = 0;
        table1 = new tableItem[tableSize];
        table2 = new tableItem[tableSize];
        for (int i = 0; i < tableSize; i++) {
            table1[i].key = K();
            table1[i].value = V();
            table2[i].key = K();
            table2[i].value = V();
        }

        for (int i = 0; i < prev_size; i++) {
            if (prev_map.table1[i].key != K()) {
                (*this)[prev_map.table1[i].key] = prev_map.table1[i].value;
            }

            if (prev_map.table2[i].key != K()) {
                (*this)[prev_map.table2[i].key] = prev_map.table2[i].value;
            }
        }
    }

   public:
    hashMap() {
        std::cout << "constructing hash map" << std::endl;
        items = 0;
        tableSize = 10;
        table1 = new tableItem[tableSize];
        table2 = new tableItem[tableSize];
        for (int i = 0; i < tableSize; i++) {
            table1[i].key = K();
            table1[i].value = V();
            table2[i].key = K();
            table2[i].value = V();
        }
    }
    ~hashMap() {
        std::cout << "destroying hash map" << std::endl;
        delete[] table1;
        delete[] table2;
        items = 0;
        tableSize = 0;
    }
    V &operator[](K key) {
        enum turn { X,
                    Y };
        turn my_turn = X;

        int x = h1(key);
        int y = h2(key);

        if (static_cast<double>(items) / static_cast<double>(tableSize) >= LOAD_FACTOR) {
            resize();
        }

        int i = 0;
        for (;;) {
            if (table1[(x + i * y) % tableSize].key == K()) {
                table1[(x + i * y) % tableSize].key = key;
                items++;
                return table1[(x + i * y) % tableSize].value;
            } else if (table1[(x + i * y) % tableSize].key == key) {
                return table1[(x + i * y) % tableSize].value;
            }

            if (table2[(y + i * x) % tableSize].key == K()) {
                table2[(y + i * x) % tableSize].key = key;
                items++;
                return table2[(y + i * x) % tableSize].value;
            } else if (table2[(y + i * x) % tableSize].key == key) {
                return table2[(y + i * x) % tableSize].value;
            }

            if (my_turn == X) {
                i += x;
                my_turn = Y;
            } else {
                i += y;
                my_turn = X;
            }
        }
    }

    hashMap(const hashMap<K, V> &rhs) {
        items = rhs.items;
        tableSize = rhs.tableSize;

        table1 = new tableItem[tableSize];
        table2 = new tableItem[tableSize];

        for (int i = 0; i < tableSize; i++) {
            table1[i].key = rhs.table1[i].key;
            table1[i].value = rhs.table1[i].value;

            table2[i].key = rhs.table2[i].key;
            table2[i].value = rhs.table2[i].value;
        }
    }
};