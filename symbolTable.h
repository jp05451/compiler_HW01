#include <vector>
#include <string>
#include <unordered_map>
#include<algorithm>
#include<iostream>

using namespace std;

enum symbolType
{
    ID
};

class symbolTable
{
public:
    symbolTable() {}
    ~symbolTable() {}
    // void creat();
    int lookup(string &symbol);
    void insert(string &symbol);
    void dump();

private:
    vector<vector<string>> table;
};

// void symbolTable::creat(){}

int symbolTable::lookup(string &symbol)
{
    vector<string>::iterator iter = find(table[ID].begin(), table[ID].end(), symbol);
    return distance(table[ID].begin(), iter);
}

void symbolTable::insert(string &symbol)
{
    table[ID].push_back(symbol);
    cout << symbol << " is inserted" << endl;
}

void symbolTable::dump()
{
    cout << "Symbol Table:" << endl;
    cout << "ID" << endl;
    for (auto &a : table[ID])
    {
        cout << a << endl;
    }
}