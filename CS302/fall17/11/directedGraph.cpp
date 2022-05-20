#include "directedGraph.h"

directedGraph::directedGraph() {
    deepCopy = false;
    index = 1;
    source = 0;
    sink = 0;
    vertexCount = 0;
    edgeCount = 0;
    title = "";
    pred = NULL;
    flowGraph = NULL;
    adjacencyList = NULL;
}

directedGraph::~directedGraph() {
    destroyGraph();
}

void directedGraph::makeGraph(int size) {
    if (adjacencyList != NULL)
        destroyGraph();

    vertexCount = size;

    adjacencyList = new listHead[vertexCount];

    for (int i = 0; i < vertexCount; i++) {
        adjacencyList[i].front = NULL;
        adjacencyList[i].location = "";
    }

    if (vertexCount < 100) {
        flowGraph = new listHead[vertexCount];
        deepCopy = true;
        for (int i = 0; i < vertexCount; i++) {
            flowGraph[i].front = NULL;
            flowGraph[i].location = "";
        }
    }
}

void directedGraph::addEdge(int src, int dest, double edgeWeight) {
    if (adjacencyList == NULL) {
        std::cout << "addEdge: Error, no graph, can not add edge." << std::endl;
        return;
    }

    if (src < 0 || src > vertexCount || dest < 0 || dest > vertexCount) {
        std::cout << "addEdge: Error, invalid vertex." << std::endl;
        return;
    }

    if (src == dest) {
        std::cout << "addEdge: Error, vertex to and from can not be the same." << std::endl;
        return;
    }

    listNode *newNode1;
    newNode1 = new listNode;

    newNode1->weight = edgeWeight;
    newNode1->dest = dest;
    newNode1->link = NULL;

    if (adjacencyList[src].front == NULL) {
        adjacencyList[src].front = newNode1;
        if (deepCopy == true) {
            listNode *newNode2;
            newNode2 = new listNode;

            newNode2->weight = edgeWeight;
            newNode2->dest = dest;
            newNode2->link = NULL;

            flowGraph[src].front = newNode2;
        }
        edgeCount++;
        return;
    } else {
        newNode1->link = adjacencyList[src].front;
        adjacencyList[src].front = newNode1;

        if (deepCopy == true) {
            listNode *newNode2;
            newNode2 = new listNode;

            newNode2->weight = edgeWeight;
            newNode2->dest = dest;
            newNode2->link = NULL;

            newNode2->link = flowGraph[src].front;
            flowGraph[src].front = newNode2;
        }

        edgeCount++;
        return;
    }
}

bool directedGraph::readGraph(const std::string fname) {
    int size;
    int from, to;
    double edgeWeight;
    std::string temp;
    std::ifstream input;
    std::stringstream mySS;

    input.open(fname.c_str());

    if (input.is_open()) {
        getline(input, title);

        getline(input, temp);
        size = stoi(temp.substr(8));
        if (size >= 5)
            makeGraph(size);
        else {
            std::cout << "readGraph: Error, invalid graph size." << std::endl;
            return false;
        }

        input.ignore(256, '\n');

        getline(input, temp);
        temp = temp.substr(10);
        source = 0;
        adjacencyList[source].location = temp;
        insert(temp, source);

        getline(input, temp);
        temp = temp.substr(8);
        sink = vertexCount - 1;
        adjacencyList[sink].location = temp;
        insert(temp, sink);

        getline(input, temp, ';');
        while (input) {
            if (!search(temp, from)) {
                insert(temp, index);
                from = index;
                adjacencyList[from].location = temp;
                if (index != sink - 1)
                    index++;
            }

            getline(input, temp, ';');
            if (!search(temp, to)) {
                insert(temp, index);
                to = index;
                adjacencyList[to].location = temp;
                if (index != sink - 1)
                    index++;
            }

            input >> temp;
            edgeWeight = stod(temp);

            addEdge(from, to, edgeWeight);

            input.ignore(1000, '\n');
            getline(input, temp, ';');
        }
        input.close();
        return true;
    }
    return false;
}

int directedGraph::getVertexCount() const {
    return vertexCount;
}

double directedGraph::findMaxFlow() {
    return edmonds_karp();
}

double directedGraph::edmonds_karp() {
    int u, v;
    int sinkStatus;
    double maxFlow = 0;
    double currFlow = 0;
    double weightFG = 0;

    if (deepCopy == false)
        flowGraph = adjacencyList;

    pred = new int[vertexCount];
    for (int i = 0; i < vertexCount; i++)
        pred[i] = -1;

    while (true) {
        sinkStatus = BFS();
        if (sinkStatus == -1)
            break;

        currFlow = std::numeric_limits<double>::max();

        v = sink;
        while (v != source) {
            u = pred[v];
            weightFG = getWeight(u, v);
            currFlow = std::min(currFlow, weightFG);
            v = pred[v];
        }

        v = sink;
        while (v != source) {
            u = pred[v];
            changeWeight(u, v, currFlow, false);
            changeWeight(v, u, currFlow, true);
            v = pred[v];
        }

        maxFlow += currFlow;
    }

    return maxFlow;
}

int directedGraph ::BFS() {
    int u;
    int sinkStatus = 0;

    int *visited = new int[vertexCount];
    for (int i = 0; i < vertexCount; i++)
        visited[i] = -1;

    visited[source] = 1;
    enqueue(source);
    pred[source] = -1;

    while (!isEmptyQueue()) {
        u = dequeue();
        for (int v = 0; v < vertexCount; v++) {
            if (visited[v] == -1 && getWeight(u, v) > 0.0) {
                enqueue(v);
                pred[v] = u;
                visited[v] = 1;
            }
        }
    }
    sinkStatus = visited[sink];
    delete[] visited;
    return sinkStatus;
}

double directedGraph ::getWeight(int u, int v) {
    listNode *temp = flowGraph[u].front;
    while (temp != NULL) {
        if (temp->dest == v)
            return temp->weight;
        else
            temp = temp->link;
    }

    return 0.0;
}

void directedGraph ::changeWeight(int u, int v, double flow, bool opCode) {
    listNode *temp = flowGraph[u].front;
    while (temp != NULL) {
        if (temp->dest == v) {
            if (opCode == true) {
                temp->weight += flow;
                return;
            } else {
                temp->weight -= flow;
                return;
            }
        } else
            temp = temp->link;
    }
}

void directedGraph ::printGraph() {
    std::string bars_1, bars_2, bars_3, spaces_1, spaces_2;
    bars_1.append(65, '-');
    bars_2.append(6, '-');
    bars_3.append(46, '-');
    spaces_1.append(10, ' ');
    spaces_2.append(4, ' ');

    listNode *temp;

    std::cout << bars_1 << std::endl;
    std::cout << "Graph Adjacency List:" << std::endl;
    std::cout << "   Title: " << title << std::endl
              << std::endl;
    std::cout << "Vertex" << spaces_2 << "Verextes..." << std::endl;
    std::cout << bars_2 << spaces_2 << bars_3 << std::endl;

    for (int i = 0; i < vertexCount - 1; i++) {
        temp = adjacencyList[i].front;
        std::cout << adjacencyList[i].location << std::endl;
        while (temp != NULL) {
            std::cout << spaces_1 << adjacencyList[temp->dest].location;
            std::cout << " (" << temp->weight << ")" << std::endl;

            temp = temp->link;
        }
        std::cout << std::endl;
    }
    std::cout << std::endl;
    std::cout << bars_1 << std::endl;

    temp = NULL;
}

void directedGraph ::showGraphStats() const {
    std::cout << "Graph Statistics:" << std::endl;
    std::cout << "   Title:  " << title << std::endl;
    std::cout << "   Nodes:  " << vertexCount << std::endl;
    std::cout << "   Edges:  " << edgeCount << std::endl;
    std::cout << "   Source: " << adjacencyList[source].location << std::endl;
    std::cout << "   Sink:   " << adjacencyList[sink].location << std::endl;
    std::cout << std::endl;
}

void directedGraph ::printFlowGraph() {
    std::string bars_1, bars_2, bars_3, spaces_1, spaces_2;
    bars_1.append(65, '-');
    bars_2.append(6, '-');
    bars_3.append(46, '-');
    spaces_1.append(10, ' ');
    spaces_2.append(4, ' ');

    listNode *temp;
    listNode *tempFlow;

    double flow;

    std::cout << bars_1 << std::endl;
    std::cout << "Flow Graph Adjacency List:" << std::endl;
    std::cout << "   Title: " << title << std::endl
              << std::endl;
    std::cout << "Vertex" << spaces_2 << "Verextes..." << std::endl;
    std::cout << bars_2 << spaces_2 << bars_3 << std::endl;

    for (int i = 0; i < vertexCount - 1; i++) {
        temp = adjacencyList[i].front;
        tempFlow = flowGraph[i].front;
        std::cout << adjacencyList[i].location << std::endl;
        while (temp != NULL) {
            std::cout << spaces_1 << adjacencyList[temp->dest].location;

            flow = temp->weight - tempFlow->weight;
            if (flow > 0.0)
                std::cout << " (" << flow << ")" << std::endl;
            else
                std::cout << " (0.00)" << std::endl;

            temp = temp->link;
            tempFlow = tempFlow->link;
        }
        std::cout << std::endl;
    }
    std::cout << std::endl;
    std::cout << bars_1 << std::endl;

    temp = NULL;
}

void directedGraph ::destroyGraph() {
    source = 0;
    sink = 0;
    vertexCount = 0;
    edgeCount = 0;
    title = "";

    if (adjacencyList != NULL) {
        delete[] adjacencyList;
        adjacencyList = NULL;
    }

    if (flowGraph != NULL && deepCopy == true) {
        delete[] flowGraph;
        flowGraph = NULL;
        deepCopy = false;
    }

    if (pred != NULL) {
        delete[] pred;
        pred = NULL;
    }
}
