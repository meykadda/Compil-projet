#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

#define MAX_SYMBOLS 100

typedef struct {
    int stat;        // 1: idf, 2: constant, 0: none
    char name[50];   // Variable name
    int scoop;       // 1: global, 2: local
    int type;        // 1: INTEGER, 2: FLOAT, 3: CHAR
    char val[50];    // Variable value, NULL if none '/0'
    int taille;      // Size of the variable (length of value)
} Symbol;

Symbol symbolTable[MAX_SYMBOLS];

void initializeSymbolTable();
int findSymbol(const char *name);
void addVariable(int stat, const char *name, int scoop, int type, const char *val, int taille);
int  updateVariable(const char *name, const char *newVal, int newTaille);
void displaySymbolTable();
int isLogical(const char *expr);
int isFloat(char *val) ;
int findSymbol(const char *name);
void enterScope();
void exitScope();
#endif     