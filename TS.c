#include <string.h>
#include <ctype.h>
#include <stdio.h>
#include "TS.h"

int symbolCount = 0;

// Initialize the symbol table to all zeros
void initializeSymbolTable() {
    for (int i = 0; i < MAX_SYMBOLS; i++) {
        symbolTable[i].stat = 0;
        symbolTable[i].name[0] = '\0';
        symbolTable[i].scoop = 0;
        symbolTable[i].nature = 0;
        symbolTable[i].type = 0;
        symbolTable[i].val[0] = '\0';
        symbolTable[i].taille = 0;
    }
}

int searchVariable(const char *name, int statCriteria) {
    for (int i = 0; i < MAX_SYMBOLS; i++) {
        Symbol *sym = &symbolTable[i];
        if (sym->stat != 0 && sym->stat == statCriteria && strcmp(sym->name, name) == 0) {
            return i; // Return index if match found
        }
    }
    return -1; // Return -1 if no match found
}

void addOrUpdateVariable(int stat, const char *name, int scoop, int nature, int type, const char *val, int taille) {
    int index = searchVariable(name, stat);

    if (index != -1) {
        Symbol *existingVar = &symbolTable[index];

        if (existingVar->nature == 2) { // Check if it's a constant
            printf("Erreur : Impossible de modifier la constante '%s'.\n", name);
            return;
        }
        existingVar->scoop = scoop;
        existingVar->type = type; // Direct assignment of int type
        strncpy(existingVar->val, val, sizeof(existingVar->val) - 1);
        existingVar->taille = taille;

        printf("Variable '%s' mise à jour avec succès.\n", name);
        return;
    }

    if (symbolCount >= MAX_SYMBOLS) {
        printf("Erreur : La table des symboles est pleine.\n");
        return;
    }

    Symbol *newSym = &symbolTable[symbolCount++];
    newSym->stat = stat;
    strncpy(newSym->name, name, sizeof(newSym->name) - 1);
    newSym->scoop = scoop;
    newSym->nature = nature;
    newSym->type = type; // Direct assignment of int type
    strncpy(newSym->val, val, sizeof(newSym->val) - 1);
    newSym->taille = taille;

    printf("Variable '%s' ajoutée avec succès.\n", name);
}

void displaySymbolTable() {
    printf("Table des symboles :\n");
    for (int i = 0; i < symbolCount; i++) {
        Symbol *sym = &symbolTable[i];
        if (sym->stat != 0) {
            printf("State: %d | Name: %s | Scoop: %d | Nature: %d | Type: %d | Value: %s | Size: %d\n",
                   sym->stat, sym->name, sym->scoop, sym->nature, sym->type, sym->val, sym->taille);
        }
    }
}
