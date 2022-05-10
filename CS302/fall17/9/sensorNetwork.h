#pragma once

#include <climits>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <string>

#include "disjointSets.h"

class sensorNetwork : public disjointSets {
   public:
    sensorNetwork();
    ~sensorNetwork();
    bool readFile(const std::string);
    void findLimits(int &, int &, int &, int &, int &, int &);
    void showStats();
    bool createReport(const std::string);

   private:
    int maxSensors;
};
