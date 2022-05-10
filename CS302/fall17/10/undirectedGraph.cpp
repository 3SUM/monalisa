#include "undirectedGraph.h"

undirectedGraph::undirectedGraph(int size) {
    vertexCount = 0;
    title = "";
    graphMatrix = NULL;
    dist = NULL;
    pred = NULL;
    locationNames = NULL;

    if (size == 0)
        return;
    else if (size >= MIN_SIZE)
        setGraphSize(size);
    else
        std::cout << "undirectedGraph: Error, invalid graph size." << std::endl;
}

undirectedGraph::~undirectedGraph() {
    destroyGraph();
    title = "";
    vertexCount = 0;
}

void undirectedGraph::setGraphSize(int size) {
    if (size < MIN_SIZE) {
        std::cout << "setGraphSize: Error, invalid graph size." << std::endl;
        return;
    }

    if (graphMatrix != NULL)
        destroyGraph();

    vertexCount = size;

    graphMatrix = new double *[vertexCount];

    for (int i = 0; i < vertexCount; i++)
        graphMatrix[i] = new double[vertexCount];

    for (int i = 0; i < vertexCount; i++)
        for (int j = 0; j < vertexCount; j++)
            graphMatrix[i][j] = 0;
}

void undirectedGraph::addEdge(int from, int to, double edgeWeight) {
    if (graphMatrix == NULL) {
        std::cout << "addEdge: error, no graph, can not add edge." << std::endl;
        return;
    }

    if (from < 0 || from > vertexCount || to < 0 || to > vertexCount) {
        std::cout << "addEdge: error, invalid vertex." << std::endl;
        return;
    }

    if (from == to) {
        std::cout << "addEdge: error, vertex to and from can not be the same." << std::endl;
        return;
    }

    graphMatrix[from][to] = edgeWeight;
    graphMatrix[to][from] = edgeWeight;
}

bool undirectedGraph::readGraph(const std::string fname) {
    int size;
    int to, from;
    double edgeWeight;
    std::string temp;
    std::ifstream input;

    input.open(fname.c_str());

    if (input.is_open()) {
        getline(input, temp);
        title = temp;

        input >> temp;
        size = stoi(temp);
        if (size >= 5)
            setGraphSize(size);
        else {
            std::cout << "readGraph: Error, invalid graph size." << std::endl;
            return false;
        }

        input >> temp;
        input >> temp;

        while (input) {
            from = stoi(temp);

            input >> temp;
            to = stoi(temp);

            input >> temp;
            edgeWeight = stod(temp);

            addEdge(from, to, edgeWeight);

            input >> temp;
        }
        input.close();
        return true;
    }
    return false;
}

int undirectedGraph::getGraphSize() const {
    return vertexCount;
}

void undirectedGraph::printMatrix() const {
    std::string bars, spaces, empty;
    bars.append(8, '-');
    spaces.append(6, ' ');
    empty.append(2, '-');

    if (graphMatrix != NULL) {
        std::cout << "Graph Adjacency Matrix:" << std::endl;
        std::cout << "   Title: " << title << std::endl
                  << std::endl;

        std::cout << spaces;
        for (int i = 0; i < vertexCount; i++)
            std::cout << std::setw(8) << i;
        std::cout << std::endl;

        std::cout << spaces;
        for (int i = 0; i < vertexCount; i++)
            std::cout << bars;
        std::cout << std::endl;

        std::cout << std::fixed << std::showpoint << std::setprecision(2);

        for (int row = 0; row < vertexCount; row++) {
            std::cout << std::setw(6) << row << "|";
            for (int col = 0; col < vertexCount; col++) {
                if (row == col)
                    std::cout << std::setw(8) << "*";
                else if (graphMatrix[row][col] == 0)
                    std::cout << std::setw(8) << empty;
                else if (graphMatrix[row][col] > 0)
                    std::cout << std::setw(8) << graphMatrix[row][col];
            }
            std::cout << std::endl;
        }
        std::cout << std::endl;
    } else {
        std::cout << "printMatrix: Error, no graph data." << std::endl;
    }
}

void undirectedGraph::prims(int source) {
    int u;
    double p;
    double INF = std::numeric_limits<double>::max();

    if (source >= 0 && source < vertexCount) {
        insert(source, 0);
        for (int i = 1; i < vertexCount; i++)
            insert(i, INF);

        pred = new int[vertexCount];
        pred[source] = 0;
        for (int i = 1; i < vertexCount; i++)
            pred[i] = -1;

        dist = new double[vertexCount];
        dist[source] = 0.0;
        for (int i = 1; i < vertexCount; i++)
            dist[i] = INF;

        while (!isEmpty()) {
            deleteMin(u, p);
            for (int v = 0; v < vertexCount; v++) {
                if (graphMatrix[u][v] > 0) {
                    if (isIn(v) && graphMatrix[u][v] < dist[v]) {
                        pred[v] = u;
                        dist[v] = graphMatrix[u][v];
                        changePriority(v, graphMatrix[u][v]);
                    }
                }
            }
        }
        printMST();
    } else {
        std::cout << "prims: Error, invalid source node." << std::endl;
    }
}

bool undirectedGraph::readLocationNames(const std::string fname) {
    std::string location;
    std::ifstream input;

    if (graphMatrix == NULL) {
        std::cout << "readLocationNames: Error, no graph defined." << std::endl;
        return false;
    }

    input.open(fname.c_str());

    if (input.is_open()) {
        locationNames = new std::string[vertexCount];

        for (int i = 0; i < vertexCount; i++) {
            getline(input, location);
            locationNames[i] = location;
        }
        input.close();
        return true;
    }
    return false;
}

std::string undirectedGraph::getTitle() const {
    return title;
}

void undirectedGraph::setTitle(const std::string name) {
    title = name;
}

void undirectedGraph::printMST() const {
    std::string bars_1, bars_2, bars_3, stars;
    bars_1.append(32, '-');
    bars_2.append(12, '-');
    bars_3.append(25, '-');
    stars.append(65, '*');

    double cost = 0.0;

    if (pred != NULL && dist != NULL) {
        std::cout << std::endl;
        std::cout << stars << std::endl;
        std::cout << "Springfield Fiber Configuration:" << std::endl;
        std::cout << bars_1 << std::endl
                  << std::endl;

        std::cout << "By Vertex's:" << std::endl;
        std::cout << bars_2 << std::endl;

        for (int i = 1; i < vertexCount; i++)
            std::cout << i << " - " << pred[i] << "  " << dist[i] << std::endl;
        std::cout << std::endl;

        if (locationNames != NULL) {
            std::cout << "By Springfield Locations:" << std::endl;
            std::cout << bars_3 << std::endl;

            for (int i = 1; i < vertexCount; i++)
                std::cout << locationNames[i] << " - " << locationNames[pred[i]] << "  " << dist[i] << std::endl;
            std::cout << std::endl;
        }

        for (int i = 1; i < vertexCount; i++)
            cost += dist[i];

        std::cout << "Total Cost:  $" << cost << "k" << std::endl;
    }
}

void undirectedGraph::destroyGraph() {
    if (graphMatrix != NULL) {
        for (int i = 0; i < vertexCount; i++)
            delete[] graphMatrix[i];

        delete[] graphMatrix;
        graphMatrix = NULL;
        vertexCount = 0;
        title = "";
    }

    if (dist != NULL) {
        delete[] dist;
        dist = NULL;
    }

    if (pred != NULL) {
        delete[] pred;
        pred = NULL;
    }

    if (locationNames != NULL) {
        delete[] locationNames;
        locationNames = NULL;
    }
}
