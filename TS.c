#include "TS.h"

int symbolCount = 0;

// Initialize the symbol table to all zeros
void initializeSymbolTable() {
    for (int i = 0; i < MAX_SYMBOLS; i++) {
        symbolTable[i].stat = 0;
        symbolTable[i].name[0] = '\0';
        symbolTable[i].scoop = 0;
        symbolTable[i].nature = 0;
        symbolTable[i].type[0] = '\0';
        symbolTable[i].val[0] = '\0';
        symbolTable[i].taille = 0;
    }
}

// Check type compatibility
int isCompatibleType(const char *type, const char *value) {
    if (strcmp(type, "INTEGER") == 0) {
        for (int i = 0; i < (int)strlen(value); i++) {
            if (!isdigit(value[i]) && !(i == 0 && value[i] == '-')) {
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
            } else if (!isdigit(value[i]) && !(i == 0 && value[i] == '-')) {
                return 0;
            }
        }
        return 1;
    } else if (strcmp(type, "CHAR") == 0) {
        return strlen(value) == 1;
    }
    return 0;
}

// Search for a variable in the symbol table
int searchVariable(const char *name, int statCriteria) {
    for (int i = 0; i < MAX_SYMBOLS; i++) {
        Symbol *sym = &symbolTable[i];
        if (sym->stat != 0 && sym->stat == statCriteria && strcmp(sym->name, name) == 0) {
            return i; // Return line number if match found
        }
    }
    return -1; // Return -1 if no match found
}

// Add or update a variable
void addOrUpdateVariable(int stat, const char *name, int scoop, int nature, const char *type, const char *val, int taille) {
    int index = searchVariable(name, stat); // Search for the variable by `stat` and `name`

    if (index != -1) {
        // If the variable exists, update all fields
        Symbol *existingVar = &symbolTable[index];

        if (existingVar->nature == 1) { // Check if the variable is a constant
            printf("Erreur : Impossible de modifier la constante '%s'.\n", name);
            return;
        }

        // Check type compatibility
        if (!isCompatibleType(type, val)) {
            printf("Erreur : Type incompatible pour '%s'.\n", name);
            return;
        }

        // Update all fields
        existingVar->stat = stat;
        strncpy(existingVar->name, name, sizeof(existingVar->name) - 1);
        existingVar->scoop = scoop;
        existingVar->nature = nature;
        strncpy(existingVar->type, type, sizeof(existingVar->type) - 1);
        strncpy(existingVar->val, val, sizeof(existingVar->val) - 1);
        existingVar->taille = taille;

        printf("Variable '%s' mise à jour avec succès.\n", name);
        return;
    }

    // If the variable does not exist, add it
    if (symbolCount >= MAX_SYMBOLS) {
        printf("Erreur : La table des symboles est pleine.\n");
        return;
    }

    Symbol *newSym = &symbolTable[symbolCount];
    newSym->stat = stat;
    strncpy(newSym->name, name, sizeof(newSym->name) - 1);
    newSym->scoop = scoop;
    newSym->nature = nature;
    strncpy(newSym->type, type, sizeof(newSym->type) - 1);
    strncpy(newSym->val, val, sizeof(newSym->val) - 1);
    newSym->taille = taille;

    symbolCount++;
    printf("Variable '%s' ajoutée avec succès.\n", name);
}

// Display the symbol table
void displaySymbolTable() {
    printf("Table des symboles :\n");
    for (int i = 0; i < symbolCount; i++) {
        Symbol *sym = &symbolTable[i];
        if (sym->stat != 0) { // Display only non-empty rows
            printf("Stat: %d   |  Nom: %s     |    Portée: %d    |   Nature: %d     |  Type: %s    |   Valeur: %s     |   Taille: %d\n",
                   sym->stat, sym->name, sym->scoop, sym->nature, sym->type, sym->val, sym->taille);
        }
    }
}