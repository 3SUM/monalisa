#pragma once

#include <fstream>
#include <iomanip>
#include <iostream>
#include <limits>
#include <sstream>
#include <string>

#include "priorityQueue.h"

class undirectedGraph : public priorityQueue<int> {
   public:
    undirectedGraph(int = 0);
    ~undirectedGraph();
    void setGraphSize(int);
    void addEdge(int, int, double);
    bool readGraph(const std::string);
    int getGraphSize() const;
    void printMatrix() const;
    void prims(int);
    bool readLocationNames(const std::string);
    std::string getTitle() const;
    void setTitle(const std::string);

   private:
    int vertexCount;
    std::string title;
    double **graphMatrix;
    double *dist;
    int *pred;
    std::string *locationNames;
    static constexpr int MIN_SIZE = 4;
    void printMST() const;
    void destroyGraph();
};
