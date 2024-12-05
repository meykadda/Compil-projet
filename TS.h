#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

#define MAX_SYMBOLS 100

typedef struct {
    int stat;        // 0: empty, 1: idf & const, 2: keywords, 3: separators
    char name[50];   // Variable name
    int scoop;       // 0: global, 1: local, Null if none 
    int nature;      // 0: idf, 1: constant, 2 if none
    char type[10];   // char, integer, float, Null if none
    char val[50];    // Variable value
    int taille;      // Size of the variable (length of value)
} Symbol;

Symbol symbolTable[MAX_SYMBOLS];

void initializeSymbolTable();
int isCompatibleType(const char *type, const char *value);
int searchVariable(const char *name, int statCriteria);
void addOrUpdateVariable(int stat, const char *name, int scoop, int nature, const char *type, const char *val, int taille);
void displaySymbolTable();

#endif