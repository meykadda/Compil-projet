%{
    #include <stdio.h>
    #include <stdlib.h> 
    #include "TS.h"
    #include "quad.h" // Inclure l'entête pour la gestion des quadruplets

    int yylex();
    void yyerror(const char *s); 
	int labelCount = 0;
%}

%union {
    int ival;
    char *sval;  
     float fval;	
}
%token VAR_GLOBAL DECLARATION WRITE READ
%token LBRACE RBRACE LPAREN RPAREN LSQUARE RSQUARE SEMICOLON VIRGULE FOR COLON 
%token ASSIGN_OP INSTRUCTION IF ELSE
%token FLOAT_KWD INTEGER_KWD CHAR_KWD CONST
%token <fval> FLOAT
%token <ival> INTEGER
%token <sval> ID CHAR
%left PLUS MINUS
%left MULT DIV
%left OR
%left AND
%right NOT
%left LT LE GT GE EQ NE


%type <sval> expr term factor comparison_expression if_else_instruction
%type <sval> read_instruction assignment logical_expression condition
%%

program:
   var_global_section declaration_section instruction_section
  | /* epsilon */
;


var_global_section:
    VAR_GLOBAL LBRACE liste_var RBRACE 
;
declaration_section:
    DECLARATION LBRACE liste_var RBRACE
;

liste_var:
    type liste_idf SEMICOLON liste_var
	|CONST type ID SEMICOLON                                    { printf("VALID constant\n"); }
    | /* epsilon */
;
liste_idf:
    ID VIRGULE liste_idf
    | ID
    | ID ASSIGN_OP expr
    | ID LSQUARE INTEGER RSQUARE
;

type:
    INTEGER_KWD
    | FLOAT_KWD
    | CHAR_KWD
;

instruction_section:
    INSTRUCTION LBRACE instruction_liste RBRACE
;

instruction_liste:
    for_instruction
    | read_instruction
    | write_instruction
	|if_else_instruction
    | /* epsilon */
;

read_instruction:
    READ LPAREN ID RPAREN SEMICOLON
	{
	if (findSymbol($3) == -1) {
        printf("Erreur : Variable '%s' non déclarée.\n", $3);
        free($3);	
        }

        // Générer le quadruplet pour la lecture
        addQuadruplet("READ", "", "", $3);  // L'instruction READ lit la valeur et la stocke dans la variable $2
        free($3);
   }
;

write_instruction:
    WRITE LPAREN expr RPAREN SEMICOLON
expr:
    expr PLUS term
    {
        char tempVar[50];
        snprintf(tempVar, sizeof(tempVar), "t%d", quadCount);
        addQuadruplet("+", $1, $3, tempVar); // Générer le quadruplet pour l'addition
        $$ = strdup(tempVar); // Associer le résultat temporaire à l'expression
        free($1);
        free($3);
    }
    | expr MINUS term
    {
        char tempVar[50];
        snprintf(tempVar, sizeof(tempVar), "t%d", quadCount);
        addQuadruplet("-", $1, $3, tempVar); // Générer le quadruplet pour la soustraction
        $$ = strdup(tempVar);
        free($1);
        free($3);
    }
    | comparison_expression
    {
        $$ = $1; // Si c'est une comparaison, passer directement la valeur
    }
    | term
    {
        $$ = $1; // Passer la valeur directement
    }
;

term:
    term MULT factor
    {
        char tempVar[50];
        snprintf(tempVar, sizeof(tempVar), "t%d", quadCount);
        // Vérification du type de facteur et génération du quadruplet pour multiplication
        if (isFloat($1) || isFloat($3)) {
            addQuadruplet("*", $1, $3, tempVar); // Générer le quadruplet pour la multiplication avec float
        } else {
            addQuadruplet("*", $1, $3, tempVar); // Générer le quadruplet pour la multiplication avec int
        }
        $$ = strdup(tempVar);
        free($1);
        free($3);
    }
    | term DIV factor
    {
        char tempVar[50];
        snprintf(tempVar, sizeof(tempVar), "t%d", quadCount);
        // Vérification du type de facteur et génération du quadruplet pour la division
        if (isFloat($1) || isFloat($3)) {
            addQuadruplet("/", $1, $3, tempVar); // Générer le quadruplet pour la division avec float
        } else {
            addQuadruplet("/", $1, $3, tempVar); // Générer le quadruplet pour la division avec int
        }
        $$ = strdup(tempVar);
        free($1);
        free($3);
    }
    | factor
    {
        $$ = $1; // Passer la valeur directement
    }
;


factor:
    INTEGER
    {
        char tempVar[50];
        snprintf(tempVar, sizeof(tempVar), "%d", $1); // Convertir la valeur entière en chaîne
        $$ = strdup(tempVar); // Associer à un résultat temporaire
    }
    | ID
    {
        // Vérifier si la variable existe dans la table des symboles
       if (findSymbol($1) == -1)  {
            printf("Erreur : Variable '%s' non déclarée.\n", $1);
        }
        $$ = $1; // Passer l'identifiant directement
    }
	| FLOAT
    {
        char tempVar[50];
        snprintf(tempVar, sizeof(tempVar), "%f", $1); // Convertir la valeur flottante en chaîne
        $$ = strdup(tempVar); // Associer à un résultat temporaire
    }
;

comparison_expression:
    expr LT expr
    {
        char tempVar[50];
        snprintf(tempVar, sizeof(tempVar), "t%d", quadCount);
        addQuadruplet("<", $1, $3, tempVar); // Générer le quadruplet pour la comparaison '<'
        $$ = strdup(tempVar);
        free($1);
        free($3);
    }
    | expr LE expr
    {
        char tempVar[50];
        snprintf(tempVar, sizeof(tempVar), "t%d", quadCount);
        addQuadruplet("<=", $1, $3, tempVar); // Générer le quadruplet pour la comparaison '<='
        $$ = strdup(tempVar);
        free($1);
        free($3);
    }
    | expr GT expr
    {
        char tempVar[50];
        snprintf(tempVar, sizeof(tempVar), "t%d", quadCount);
        addQuadruplet(">", $1, $3, tempVar); // Générer le quadruplet pour la comparaison '>'
        $$ = strdup(tempVar);
        free($1);
        free($3);
    }
    | expr GE expr
    {
        char tempVar[50];
        snprintf(tempVar, sizeof(tempVar), "t%d", quadCount);
        addQuadruplet(">=", $1, $3, tempVar); // Générer le quadruplet pour la comparaison '>='
        $$ = strdup(tempVar);
        free($1);
        free($3);
    }
    | expr EQ expr
    {
        char tempVar[50];
        snprintf(tempVar, sizeof(tempVar), "t%d", quadCount);
        addQuadruplet("==", $1, $3, tempVar); // Générer le quadruplet pour la comparaison '=='
        $$ = strdup(tempVar);
        free($1);
        free($3);
    }
    | expr NE expr
    {
        char tempVar[50];
        snprintf(tempVar, sizeof(tempVar), "t%d", quadCount);
        addQuadruplet("!=", $1, $3, tempVar); // Générer le quadruplet pour la comparaison '!='
        $$ = strdup(tempVar);
        free($1);
        free($3);
    }
;
logical_expression:
    expr OR expr
    {
        char tempVar[50];
        snprintf(tempVar, sizeof(tempVar), "t%d", quadCount);
        addQuadruplet("||", $1, $3, tempVar); // Generate quadruplet for '||'
        $$ = strdup(tempVar);
        free($1);
        free($3);
    }
    | expr AND expr
    {
        char tempVar[50];
        snprintf(tempVar, sizeof(tempVar), "t%d", quadCount);
        addQuadruplet("&&", $1, $3, tempVar); // Generate quadruplet for '&&'
        $$ = strdup(tempVar);
        free($1);
        free($3);
    }
    | NOT expr
    {
        char tempVar[50];
        snprintf(tempVar, sizeof(tempVar), "t%d", quadCount);
        addQuadruplet("!", $2, NULL, tempVar); // Generate quadruplet for '!'
        $$ = strdup(tempVar);
        free($2);
    }
;

for_instruction:
    FOR LPAREN assignment COLON expr COLON expr RPAREN LBRACE instruction_liste RBRACE SEMICOLON
    {
        printf("VALID FOR loop\n");

        // Générer des quadruplets pour l'initialisation
        addQuadruplet("=", $3, "", "LoopVar");  // Utilisez $3, qui est l'initialisation de la boucle.

        // Générer un quadruplet pour calculer la condition d'arrêt
        char conditionResult[50];
        snprintf(conditionResult, sizeof(conditionResult), "t%d", quadCount);
        addQuadruplet("<", "LoopVar", $5, conditionResult);  // Condition de boucle

        // Générer l'étiquette pour début de boucle
        char startLabel[50], endLabel[50];
        snprintf(startLabel, sizeof(startLabel), "StartLoop%d", quadCount);
        snprintf(endLabel, sizeof(endLabel), "EndLoop%d", quadCount);
        addQuadruplet("label", startLabel, "", "");

        // Condition d'arrêt de la boucle
        addQuadruplet("ifFalse", conditionResult, "", endLabel);

        // Instructions à l'intérieur de la boucle
        // ...

        // Incrémentation de la variable de boucle
        char incrementResult[50];
        snprintf(incrementResult, sizeof(incrementResult), "t%d", quadCount);
        addQuadruplet("+", "LoopVar", $7, "LoopVar");  // Incrément de la boucle

        // Saut vers le début de la boucle
        addQuadruplet("jump", "", "", startLabel);

        // Étiquette pour la fin de la boucle
        addQuadruplet("label", endLabel, "", "");
    }
;

if_else_instruction:
    IF LPAREN condition RPAREN LBRACE instruction_liste RBRACE
    {
        if (!isLogical($3)) {
            yyerror("Condition in IF must evaluate to a logical expression");
            free($3);
        }

        char trueLabel[50], endLabel[50];
        snprintf(trueLabel, sizeof(trueLabel), "L%d", labelCount++);
        snprintf(endLabel, sizeof(endLabel), "L%d", labelCount++);

        // Générer quadruplet : IF condition GOTO trueLabel
        addQuadruplet("IF", $3, "", trueLabel);

        // Générer quadruplet : GOTO endLabel (cas où la condition est fausse)
        addQuadruplet("GOTO", "", "", endLabel);

        // Etiquette pour la branche TRUE
        addQuadruplet("LABEL", "", "", trueLabel);

        // Ajouter les instructions de la branche IF
        // ...

        // Saut vers la fin après la branche TRUE
        addQuadruplet("GOTO", "", "", endLabel);

        // Etiquette pour la fin du bloc
        addQuadruplet("LABEL", "", "", endLabel);
        free($3);
    }
    | IF LPAREN condition RPAREN LBRACE instruction_liste RBRACE ELSE LBRACE instruction_liste RBRACE
    {
        if (!isLogical($3)) {
            yyerror("Condition in IF must evaluate to a logical expression");
            free($3);
        }

        char trueLabel[50], falseLabel[50], endLabel[50];
        snprintf(trueLabel, sizeof(trueLabel), "L%d", labelCount++);
        snprintf(falseLabel, sizeof(falseLabel), "L%d", labelCount++);
        snprintf(endLabel, sizeof(endLabel), "L%d", labelCount++);

        // Générer quadruplet: IF condition GOTO trueLabel
        addQuadruplet("IF", $3, NULL, trueLabel);

        // Générer quadruplet: GOTO falseLabel (si la condition est fausse)
        addQuadruplet("GOTO", NULL, NULL, falseLabel);

        // Label pour la branche TRUE (IF)
        addQuadruplet("LABEL", NULL, NULL, trueLabel);

        // Ajouter les instructions de la branche IF ici

        // Saut vers la fin après la branche TRUE
        addQuadruplet("GOTO", NULL, NULL, endLabel);

        // Label pour la branche FALSE (ELSE)
        addQuadruplet("LABEL", NULL, NULL, falseLabel);

        // Ajouter les instructions de la branche ELSE ici

        // Label pour la fin du bloc IF-ELSE
        addQuadruplet("LABEL", NULL, NULL, endLabel);
        free($3);
    }


condition:
    logical_expression     { printf("VALID condition\n"); }
  | comparison_expression  { printf("VALID condition\n"); }
  ;
  
assignment:
    ID ASSIGN_OP expr
    {
        // Vérification de l'existence de la variable
        if (findSymbol($1) == -1) {
            printf("Erreur : Variable '%s' non déclarée.\n", $1);
        }

        // Générer le quadruplet pour l'affectation
        char tempVar[50];
        snprintf(tempVar, sizeof(tempVar), "t%d", quadCount); // Créer un temporaire pour l'assignation

        // Ajouter le quadruplet d'affectation : ID = expr
        addQuadruplet("=", $3, "", $1);  // L'expression ($3) est assignée à la variable ($1)

        $$ = strdup($1); // Résultat de l'affectation est la variable elle-même
        free($3); // Libérer la mémoire de l'expression
    }
;


%%

int main() {
    // Initialisation de la table des symboles
    initializeSymbolTable();

    printf("Parsing starts\n");
    if (yyparse() == 0) {
        printf("Parsing completed successfully\n");
    } else {
        printf("Parsing failed\n");
    }

    // Afficher la table des symboles à la fin
    displaySymbolTable();

    // Afficher les quadruplets générés
    displayQuadruplets();

    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Erreur de syntaxe : %s\n", s);
}
