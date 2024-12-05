%{
    #include <stdio.h>
    #include <stdlib.h>
    /*#include "TS.h"*/

    int yylex();
    void yyerror(const char *s); 
%}

%union{
    int ival;
    float fval;
    char *sval;
}

%token VAR_GLOBAL DECLARATION INSTRUCTION
%token FLOAT_KWD INTEGER_KWD CHAR_KWD CONST
%token LBRACE RBRACE LPAREN RPAREN LSQUARE RSQUARE SEMICOLON VIRGULE
%token READ WRITE ASSIGN_OP
%token <fval> FLOAT
%token <ival> INTEGER
%token <sval> ID MESSAGE CHAR
%left PLUS MINUS MULT DIV

%%

program:
    var_global_section declaration_section instruction_section   { printf("VALID program\n"); }      
    | /* epsilon */
    ;

var_global_section:
    VAR_GLOBAL LBRACE liste_var RBRACE                           { printf("VALID VARIABLE GLOBAL section\n");}  
    ;

declaration_section:
    DECLARATION LBRACE liste_var RBRACE                          { printf("VALID DECLARATION section\n"); }
    ;

liste_var:
    type liste_idf SEMICOLON liste_var                     
    | CONST type ID SEMICOLON                                    { printf("VALID constant\n"); }
    | /* epsilon */
    ;

liste_idf:
    ID VIRGULE liste_idf                                         { printf("VALID list of identifiers\n");}
    |ID                                                          { printf("VALID identifier\n"); }
    |ID assignment                                               { printf("VALID assignment\n"); }
    |ID LSQUARE INTEGER RSQUARE                                  { printf("VALID array\n"); }
    ;

assignment:
     ASSIGN_OP arithmetic_expression                             { printf("VALID arithmetic operation assignment\n"); }
    |ASSIGN_OP CHAR                                              { printf("VALID assignment\n"); }
    ;

arithmetic_expression:
    arithmetic_expression PLUS term                             { printf("VALID arithmetic expression\n"); }
    | arithmetic_expression MINUS term                          { printf("VALID arithmetic expression\n"); }
    | term
    ;

term:
    term MULT factor                                            { printf("VALID arithmetic expression\n");}
    | term DIV factor                                           { printf("VALID arithmetic expression\n"); }
    | factor
    ;

factor:
    INTEGER 
    | FLOAT
    | ID
    ;

instruction_section:
    INSTRUCTION LBRACE instruction_liste RBRACE                  { printf("VALID INSTRUCTION section\n");  }
    | /* epsilon */
    ;
  
instruction_liste:
    read_instruction
    | write_instruction
    | /* epsilon */
    ;

read_instruction:
    READ LPAREN ID RPAREN SEMICOLON                              { printf("VALID READ instruction\n"); }
    ;

write_instruction:
    WRITE LPAREN contenu_msg RPAREN SEMICOLON                    { printf("VALID WRITE instruction\n"); }
    ;

contenu_msg:
    MESSAGE VIRGULE ID VIRGULE MESSAGE                           { printf("VALID message content with continuation\n"); }
    | MESSAGE                                                    { printf("VALID message content\n"); }
    ;

type:
    INTEGER_KWD                                                  { printf("VALID integer type\n"); }
    | FLOAT_KWD                                                  { printf("VALID float type\n"); }
    | CHAR_KWD                                                   { printf("VALID char type\n"); }
    ;

%%
int main() {
    printf("Parsing starts\n");
    if (yyparse() == 0) {
        printf("Parsing completed successfully\n");
    } else {
        printf("Parsing failed\n");
    }
    return 0;
}

 
 void yyerror(const char *s) {
    fprintf(stderr, "Erreur syntaxique: %s\n", s);
    exit(1);
}

