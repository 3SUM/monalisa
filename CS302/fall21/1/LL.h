template <typename T>
class LL {
    struct Node {
        T data;
        Node* prev;
        Node* next;
    };

   public:
    class Iterator {
       public:
        friend class LL;
        Iterator();
        Iterator(Node*);
        T operator*() const;
        const Iterator& operator++(int);
        const Iterator& operator--(int);
        bool operator==(const Iterator&) const;
        bool operator!=(const Iterator&) const;

       private:
        Node* current;
    };
    LL();
    LL(const LL<T>&);
    const LL<T>& operator=(const LL<T>&);
    ~LL();
    void headInsert(const T&);
    void tailInsert(const T&);
    Iterator begin() const;
    Iterator end() const;
    void swapNodes(Iterator&, Iterator&);

   private:
    Node* head;
    Node* tail;
};

template <typename T>
LL<T>::Iterator::Iterator() {
    current = nullptr;
}

template <typename T>
LL<T>::Iterator::Iterator(Node* ptr) {
    current = ptr;
}

template <typename T>
T LL<T>::Iterator::operator*() const {
    return current->data;
}

template <typename T>
const typename LL<T>::Iterator& LL<T>::Iterator::operator++(int) {
    current = current->next;
    return *this;
}

template <typename T>
const typename LL<T>::Iterator& LL<T>::Iterator::operator--(int) {
    current = current->prev;
    return *this;
}

template <typename T>
bool LL<T>::Iterator::operator==(const Iterator& rhs) const {
    return current == rhs.current;
}

template <typename T>
bool LL<T>::Iterator::operator!=(const Iterator& rhs) const {
    return current != rhs.current;
}

template <typename T>
LL<T>::LL() {
    head = nullptr;
    tail = nullptr;
}

template <typename T>
LL<T>::LL(const LL<T>& copy) {
    this->head = nullptr;
    this->tail = nullptr;

    if (copy.head) {
        Node* temp = copy.head;
        while (temp) {
            Node* myNode = new Node;
            myNode->data = temp->data;
            myNode->prev = nullptr;
            myNode->next = nullptr;

            if (this->head == nullptr) {
                this->head = myNode;
                this->tail = myNode;
            } else {
                this->tail->next = myNode;
                myNode->prev = tail;
                this->tail = myNode;
            }
            temp = temp->next;
        }
    }
}

template <typename T>
const LL<T>& LL<T>::operator=(const LL<T>& rhs) {
    if (this->head) {
        Node* temp = this->head;
        while (temp) {
            this->head = this->head->next;
            delete temp;
            temp = this->head;
        }
        this->head = nullptr;
        this->tail = nullptr;
    }

    if (rhs.head) {
        Node* temp = rhs.head;
        while (temp) {
            Node* myNode = new Node;
            myNode->data = temp->data;
            myNode->prev = nullptr;
            myNode->next = nullptr;

            if (this->head == nullptr) {
                this->head = myNode;
                this->tail = myNode;
            } else {
                this->tail->next = myNode;
                myNode->prev = tail;
                this->tail = myNode;
            }
            temp = temp->next;
        }
    }

    return *this;
}

template <typename T>
LL<T>::~LL() {
    Node* temp = head;
    while (temp) {
        head = head->next;
        delete temp;
        temp = head;
    }

    head = nullptr;
    tail = nullptr;
}

template <typename T>
void LL<T>::headInsert(const T& item) {
    Node* myNode = new Node;
    myNode->data = item;
    myNode->prev = nullptr;
    myNode->next = nullptr;

    if (head == nullptr) {
        head = myNode;
        tail = myNode;
    } else {
        head->prev = myNode;
        myNode->next = head;
        head = myNode;
    }
}

template <typename T>
void LL<T>::tailInsert(const T& item) {
    Node* myNode = new Node;
    myNode->data = item;
    myNode->prev = nullptr;
    myNode->next = nullptr;

    if (head == nullptr) {
        head = myNode;
        tail = myNode;
    } else {
        tail->next = myNode;
        myNode->prev = tail;
        tail = myNode;
    }
}

template <typename T>
typename LL<T>::Iterator LL<T>::begin() const {
    return Iterator(head);
}

template <typename T>
typename LL<T>::Iterator LL<T>::end() const {
    return Iterator(tail);
}

template <typename type>
void LL<type>::swapNodes(Iterator& it1, Iterator& it2) {
    Node* A = it1.current;
    Node* B = it2.current;

    if (A->next == B || B->next == A) {
        if (A->next == B) {
            Node* A_L = A->prev;
            Node* B_R = B->next;

            if (B_R != nullptr)
                B_R->prev = A;
            A->next = B_R;

            B->next = A;
            A->prev = B;

            if (A_L != nullptr)
                A_L->next = B;
            B->prev = A_L;

            if (A == head && B == tail) {
                head = B;
                tail = A;
            } else if (A == head) {
                head = B;
            }

        } else {
            Node* B_L = B->prev;
            Node* A_R = A->next;

            if (A_R != nullptr)
                A_R->prev = B;
            B->next = A_R;

            A->next = B;
            B->prev = A;

            if (B_L != nullptr)
                B_L->next = A;
            A->prev = B_L;

            if (B == head && A == tail) {
                head = A;
                tail = B;
            } else if (B == head) {
                head = A;
            }
        }
    } else {
        Node* A_L = A->prev;
        Node* A_R = A->next;
        Node* B_L = B->prev;
        Node* B_R = B->next;

        //A could be head
        if (A_L != nullptr)
            A_L->next = B;
        B->prev = A_L;

        //A could be tail
        if (A_R != nullptr)
            A_R->prev = B;
        B->next = A_R;

        //B could be head
        if (B_L != nullptr)
            B_L->next = A;
        A->prev = B_L;

        //B could be tail
        if (B_R != nullptr)
            B_R->prev = A;
        A->next = B_R;

        if (A == head && B == tail) {
            head = B;
            tail = A;
        } else if (B == head && A == tail) {
            head = A;
            tail = B;
        } else if (A == head) {
            head = B;
        } else if (B == head) {
            head = A;
        } else if (A == tail) {
            tail = B;
        } else if (B == tail) {
            tail = A;
        }
    }

    //swap addresses of Nodes
    Node* temp = it1.current;
    it1.current = it2.current;
    it2.current = temp;
}