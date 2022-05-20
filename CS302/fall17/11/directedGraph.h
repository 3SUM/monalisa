#pragma once

#include <fstream>
#include <iomanip>
#include <iostream>
#include <limits>
#include <sstream>
#include <string>

#include "hashTable.h"
#include "linkedQueue.h"

struct listNode {
    int dest;
    double weight;
    listNode *link;
};

struct listHead {
    listNode *front;
    std::string location;
};

class directedGraph : public linkedQueue<int>, public hashTable {
   public:
    directedGraph();
    ~directedGraph();
    void makeGraph(int);
    void addEdge(int, int, double);
    bool readGraph(const std::string);
    int getVertexCount() const;
    double findMaxFlow();
    double edmonds_karp();
    int BFS();
    double getWeight(int, int);
    void changeWeight(int, int, double, bool);
    void printGraph();
    void showGraphStats() const;
    void printFlowGraph();

   private:
    bool deepCopy;
    int source;
    int sink;
    int vertexCount;
    int edgeCount;
    int index;
    std::string title;
    int *pred;
    listHead *flowGraph;
    listHead *adjacencyList;
    void destroyGraph();
};
