#ifndef QUAD_H
#define QUAD_H

#include <stdio.h>
#include <string.h>

// Structure pour un quadruplet
typedef struct {
    char op[10];      // Opérateur (par exemple, "=", "+", "-", "*", "/", "<", ">", etc.)
    char arg1[50];    // Premier argument
    char arg2[50];    // Deuxième argument (si applicable)
    char result[50];  // Résultat
} Quadruplet;

// Taille maximale pour la liste des quadruplets
#define MAX_QUADS 100

// Tableau global pour stocker les quadruplets
Quadruplet quads[MAX_QUADS];
int quadCount = 0; // Compteur du nombre de quadruplets générés

// Fonction pour ajouter un quadruplet
void addQuadruplet(const char *op, const char *arg1, const char *arg2, const char *result) {
    if (quadCount >= MAX_QUADS) {
        printf("Erreur : Nombre maximum de quadruplets atteint.\n");
        return;
    }
    // Remplir les champs du quadruplet
    snprintf(quads[quadCount].op, sizeof(quads[quadCount].op), "%s", op);
    snprintf(quads[quadCount].arg1, sizeof(quads[quadCount].arg1), "%s", arg1);
    snprintf(quads[quadCount].arg2, sizeof(quads[quadCount].arg2), "%s", arg2);
    snprintf(quads[quadCount].result, sizeof(quads[quadCount].result), "%s", result);
    quadCount++; // Incrémenter le compteur
}

// Fonction pour afficher tous les quadruplets
void displayQuadruplets() {
    printf("\nListe des quadruplets générés :\n");
    for (int i = 0; i < quadCount; i++) {
        printf("Quadruplet %d: (%s, %s, %s, %s)\n",
               i,
               quads[i].op,
               quads[i].arg1,
               quads[i].arg2,
               quads[i].result);
    }
}

#endif // QUAD_H
