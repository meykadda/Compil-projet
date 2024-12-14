#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

#define MAX_SYMBOLS 100

typedef struct {
    int stat;        // 1: idf & const, 2: keywords, 3: separators,  0: empty
    char name[50];   // Variable name
    int scoop;       // 1: global, 2: local, 0: none 
    int nature;      // 1: idf, 2: constant, 0: none
    int type;        // 1: INTEGER, 2: FLOAT, 3: CHAR, 0: none
    char val[50];    // Variable value, 0 if none
    int taille;      // Size of the variable (length of value)
} Symbol;

Symbol symbolTable[MAX_SYMBOLS];

void initializeSymbolTable();
int isCompatibleType(const char *type, const char *value);
int searchVariable(const char *name, int statCriteria);
void addOrUpdateVariable(int stat, const char *name, int scoop, int nature, int type, const char *val, int taille);
void displaySymbolTable();

#endif
