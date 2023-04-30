#include <vector>
#include <set>
#include <string>
#include <unordered_map>
#include <algorithm>
#include <iostream>

using namespace std;

enum symbolType
{
    ID = 0
};

class symbolTable
{
public:
    symbolTable()
    {
        table.resize(1);
    }
    ~symbolTable() {}
    void creat();
    int lookup(string &symbol);
    void insert(const string &symbol);
    void dump();

private:
    vector<vector<string>> table;
    
};

void symbolTable::creat()
{
    table.resize(1);
}

int symbolTable::lookup(string &symbol)
{
    vector<string>::iterator iter = find(table[ID].begin(), table[ID].end(), symbol);
    return distance(table[ID].begin(), iter);
}

void symbolTable::insert(const string &symbol)
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