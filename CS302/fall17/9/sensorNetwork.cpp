#include "sensorNetwork.h"

sensorNetwork ::sensorNetwork() {
    maxSensors = 0;
}

sensorNetwork ::~sensorNetwork() {
    maxSensors = 0;
}

bool sensorNetwork ::readFile(const std::string fname) {
    int a;
    int b;
    std::string temp;
    std::ifstream input;

    input.open(fname.c_str());

    if (input.is_open()) {
        input.ignore(100, '\n');

        input >> temp;
        maxSensors = stoi(temp);
        if (!createSets(maxSensors)) {
            std::cout << "readFile: Error, invalid data file range." << std::endl;
            input.close();
            return false;
        }

        input >> temp;

        input >> temp;
        while (input) {
            a = stoi(temp);

            input >> temp;
            b = stoi(temp);

            setUnion(a, b);

            input.ignore(100, '\n');

            input >> temp;
        }
        input.close();
        return true;
    }
    return false;
}

void sensorNetwork ::findLimits(int &firstCount, int &firstParent, int &secondCount, int &secondParent, int &smallCount, int &smallParent) {
    int firstMax = 0;
    int secondMax = getSetSize(0);
    int currSize = 0;
    int min = INT_MAX;

    secondParent = 0;
    secondCount = getSetSize(0);

    if (getSetCount() == 1) {
        firstCount = getSetSize(0);
        firstParent = 0;
        secondCount = getSetSize(0);
        secondParent = 0;
        smallCount = getSetSize(0);
        smallParent = 0;
    } else {
        for (int i = 0; i < maxSensors; i++) {
            currSize = getSetSize(i);

            if (currSize > firstMax) {
                firstMax = currSize;
                firstCount = currSize;
                firstParent = i;
            }

            if (currSize > secondMax && currSize < firstMax) {
                secondMax = currSize;
                secondCount = currSize;
                secondParent = i;
            }

            if (currSize < min && currSize != 0) {
                min = currSize;
                smallCount = currSize;
                smallParent = i;
            }
        }
    }
}

void sensorNetwork ::showStats() {
    int firstC, firstP, secondC, secondP, smallC, smallP;

    std::cout << "  Total Sensors in Network:      " << maxSensors << std::endl;
    std::cout << "  Total Connected Sub-Groups:    " << getSetCount() << std::endl
              << std::endl;

    findLimits(firstC, firstP, secondC, secondP, smallC, smallP);

    std::cout << std::fixed << std::showpoint << std::setprecision(2);

    std::cout << "  Largest Connected Group:       " << firstC << std::endl;
    std::cout << "  Parent Node (largest group):   " << firstP << std::endl;
    std::cout << "  Connectivity (largest group):  " << (double(firstC) / double(maxSensors)) * 100 << std::endl
              << std::endl;
    std::cout << "  2nd Largest Connected Group:   " << secondC << std::endl;
    std::cout << "  Parent Node (2nd group):       " << secondP << std::endl;
    std::cout << "  Connectivity (2nd group):      " << (double(secondC) / double(maxSensors)) * 100 << std::endl
              << std::endl;
    std::cout << "  Smallest Connected Group:      " << smallC << std::endl;
    std::cout << "  Parent Node (smallest group):  " << smallP << std::endl;
    std::cout << "  Connectivity (smallest group): " << (double(smallC) / double(maxSensors)) * 100 << std::endl;
}

bool sensorNetwork ::createReport(const std::string outFile) {
    std::string bars_1, bars_2, bars_3;
    bars_1.append(34, '-');
    bars_2.append(8, '-');
    bars_3.append(6, '-');

    int temp = 0;
    int index = 0;
    int parent = 0;
    bool check = true;

    std::ofstream output;

    output.open(outFile.c_str());

    if (output.is_open()) {
        output << "Sensor Network Connectivity Report" << std::endl;
        output << bars_1 << std::endl
               << std::endl;

        output << "Total Unique Groups: " << getSetCount() << std::endl
               << std::endl;

        output << std::setw(8) << "Group" << std::setw(12) << "Parent" << std::setw(12) << "Group" << std::setw(12) << "Connect" << std::endl;
        output << std::setw(8) << "Number" << std::setw(12) << "Node" << std::setw(12) << "Size" << std::setw(12) << "Percent" << std::endl;
        output << std::setw(8) << bars_3 << std::setw(12) << bars_2 << std::setw(12) << bars_2 << std::setw(12) << bars_2 << std::endl;

        output << std::fixed << std::showpoint << std::setprecision(2);

        while (index < getSetCount()) {
            check = true;
            while (check) {
                temp = getSetSize(parent);
                if (temp > 0) {
                    check = false;

                    output << std::setw(8) << index << std::setw(12) << parent << std::setw(12) << getSetSize(parent);
                    output << std::setw(12) << (double(temp) / double(maxSensors)) * 100 << std::endl;
                }
                parent++;
            }
            index++;
        }
        output << std::endl;
        output.close();
        return true;
    }
    return false;
}
