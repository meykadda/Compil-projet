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
    | ID assignment                                              { printf("VALID assignment\n"); }
    | ID LSQUARE INTEGER RSQUARE                                 { printf("VALID array\n"); }
    ;

assignment:
    ASSIGN_OP FLOAT                                              { printf("VALID assignment\n"); }
    |ASSIGN_OP INTEGER                                           { printf("VALID assignment\n"); }
    |ASSIGN_OP CHAR                                              { printf("VALID assignment\n"); }
    |ASSIGN_OP ID                                                { printf("VALID assignment\n"); }
    | /* epsilon */
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
    | CHAR_KWD
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

