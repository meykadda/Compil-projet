#include <string.h>
#include <ctype.h>
#include <stdio.h>
#include "TS2.h"

int symbolCount = 0;

void initializeSymbolTable() {
    for (int i = 0; i < MAX_SYMBOLS; i++) {
        symbolTable[i].stat = 0;            // No identifier or constant initially
        symbolTable[i].name[0] = '\0';      // Empty name
        symbolTable[i].scoop = 0;           // No scope assigned
        symbolTable[i].type = 0;            // No type assigned
        symbolTable[i].val[0] = '\0';       // No value assigned
        symbolTable[i].taille = 0;          // No size assigned
    }
}

int findSymbol(const char *name) {
    for (int i = 0; i < MAX_SYMBOLS; i++) {
        if (symbolTable[i].stat != 0 && strcmp(symbolTable[i].name, name) == 0) {
            return i;  // Return index of the found symbol
        }
    }
    return -1;  // Symbol not found
}

void addVariable(int stat, const char *name, int scoop, int type, const char *val, int taille) {
    if (symbolCount >= MAX_SYMBOLS) {
        printf("Erreur : La table des symboles est pleine.\n");
        return; // La table des symboles est pleine, donc on ne peut pas ajouter de nouvelle variable
    }

    int index = findSymbol(name);
    if (index != -1) {
        printf("Erreur : La variable '%s' existe déjà.\n", name);
        return; // La variable existe déjà, donc on ne la rajoute pas
    }

    Symbol *newSym = &symbolTable[symbolCount++];
    newSym->stat = stat;
    strncpy(newSym->name, name, sizeof(newSym->name) - 1);
    newSym->name[sizeof(newSym->name) - 1] = '\0'; // Assurer la terminaison par '\0'

    newSym->scoop = scoop;
    newSym->type = type;

    if (val != NULL) { // Si une valeur est fournie
        strncpy(newSym->val, val, sizeof(newSym->val) - 1);
        newSym->val[sizeof(newSym->val) - 1] = '\0'; // Assurer la terminaison par '\0'
        newSym->taille = taille;
    } else { // Si aucune valeur n'est fournie, on met des valeurs par défaut
        newSym->val[0] = '\0';
        newSym->taille = 0;
    }

    printf("Variable '%s' ajoutée avec succès.\n", name);
}

int updateVariable(const char *name, const char *newVal, int newTaille) {
    if (symbolCount >= MAX_SYMBOLS) {
        printf("Erreur : La table des symboles est pleine.\n");
        return -1;
    }
    int index = findSymbol(name);
    if (index == -1) {
        printf("Erreur : La variable '%s' n'existe pas.\n", name);
        return -1;
    }
    Symbol *variable = &symbolTable[index];
    strncpy(variable->val, newVal, sizeof(variable->val) - 1);
    variable->val[sizeof(variable->val) - 1] = '\0';
    variable->taille = newTaille;
    printf("Variable '%s' mise à jour avec succès : Nouvelle valeur = '%s', Nouvelle taille = %d.\n",
           name, newVal, newTaille);
    return 0;
}

void displaySymbolTable() {
    printf("\nTable des symboles :\n");
    printf("--------------------------------------------------------------------------------------------\n");
    printf("| %-5s | %-20s | %-5s | %-6s | %-20s | %-5s |\n",
           "Stat", "Name", "Scope", "Type", "Value", "Size");
    printf("--------------------------------------------------------------------------------------------\n");
    for (int i = 0; i < symbolCount; i++) {
        Symbol *sym = &symbolTable[i];
        if (sym->stat != 0) { 
            printf("| %-5d | %-20s | %-5d | %-6d | %-20s | %-5d |\n",
                   sym->stat, sym->name, sym->scoop, sym->type,
                   sym->val[0] != '\0' ? sym->val : "NULL", sym->taille);
        }
    }
    printf("--------------------------------------------------------------------------------------------\n");
}