#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>  // Inclusion pour isdigit

#define MAX_SYMBOLS 100

typedef struct {
    char *name;
    char *value;
    char *type;    
    char *scope;   
    int isConstant;
} Symbol;

Symbol symbolTable[MAX_SYMBOLS];
int symbolCount = 0;

// Recherche de symbole
Symbol* searchSymbol(char *name) {
    for (int i = 0; i < symbolCount; i++) {
        if (strcmp(symbolTable[i].name, name) == 0) {
            return &symbolTable[i];
        }
    }
    return NULL;
}

// Insertion de symbole
void insertSymbol(char *name, char *value, char *type, char *scope, int isConstant) {
    if (symbolCount < MAX_SYMBOLS) {
        if (searchSymbol(name) != NULL) {
            printf("Erreur : Le symbole '%s' existe déjà.\n", name);
        } else {
            symbolTable[symbolCount].name = strdup(name);
            symbolTable[symbolCount].value = strdup(value);
            symbolTable[symbolCount].type = strdup(type);
            symbolTable[symbolCount].scope = strdup(scope);
            symbolTable[symbolCount].isConstant = isConstant;
            symbolCount++;
        }
    } else {
        printf("Erreur : La table des symboles est pleine.\n");
    }
}

// Compatibilité des types
int isCompatibleType(char *type, char *value) {
    if (strcmp(type, "INTEGER") == 0) {
        for (int i = 0; i < (int)strlen(value); i++) {
            if (!isdigit((unsigned char)value[i]) && !(i == 0 && value[i] == '-')) {
                return 0;
            }
        }
        return 1;
    } else if (strcmp(type, "FLOAT") == 0) {
        int hasDot = 0;
        for (int i = 0; i < (int)strlen(value); i++) {
            if (value[i] == '.') {
                if (hasDot) return 0;
                hasDot = 1;
            } else if (!isdigit((unsigned char)value[i]) && !(i == 0 && value[i] == '-')) {
                return 0;
            }
        }
        return 1;
    } else if (strcmp(type, "CHAR") == 0) {
        return strlen(value) == 1;
    }
    return 0;
}

// Mise à jour de valeur
void updateSymbolValue(char *name, char *newValue) {
    Symbol *symbol = searchSymbol(name);
    if (symbol != NULL) {
        if (symbol->isConstant) {
            printf("Erreur : Impossible de modifier la constante '%s'.\n", name);
            return;
        }
        if (!isCompatibleType(symbol->type, newValue)) {
            printf("Erreur : Type incompatible pour '%s'.\n", name);
            return;
        }
        free(symbol->value);
        symbol->value = strdup(newValue);
        printf("Valeur mise à jour pour '%s' : %s\n", name, newValue);
    } else {
        printf("Erreur : Symbole '%s' non trouvé dans la table.\n", name);
    }
}

// Affichage de la table
void displaySymbolTable() {
    printf("Table des symboles :\n");
    for (int i = 0; i < symbolCount; i++) {
        printf("Nom : %s, Valeur : %s, Type : %s, Portée : %s, Constante : %d\n",
               symbolTable[i].name, symbolTable[i].value, symbolTable[i].type,
               symbolTable[i].scope, symbolTable[i].isConstant);
    }
}

// Libération de la mémoire
void freeSymbolTable() {
    for (int i = 0; i < symbolCount; i++) {
        free(symbolTable[i].name);
        free(symbolTable[i].value);
        free(symbolTable[i].type);
        free(symbolTable[i].scope);
    }
}

int main() {
    insertSymbol("x", "12", "INTEGER", "global", 1);
    insertSymbol("y", "A", "CHAR", "local", 0);
    insertSymbol("z", "3.14", "FLOAT", "global", 0);

    displaySymbolTable();

    updateSymbolValue("y", "B");
    updateSymbolValue("x", "15");
    updateSymbolValue("z", "abc");

    displaySymbolTable();

    freeSymbolTable();

    return 0;
}
