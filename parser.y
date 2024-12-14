 %{#include <stdio.h>
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
%token LBRACE RBRACE LPAREN RPAREN LSQUARE RSQUARE SEMICOLON VIRGULE COLON
%token READ WRITE ASSIGN_OP FOR IF ELSE 
%token <fval> FLOAT
%token <ival> INTEGER
%token <sval> ID MESSAGE CHAR
%token AND OR NOT
%token LE EQ NE
%left PLUS MINUS MULT DIV
%left OR
%left AND
%right NOT
%left LE EQ NE GE GT LT  

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
    | for_instruction 
	|if_else_instruction
    | /* epsilon */
    ;

for_instruction:
    FOR LPAREN factor assignment COLON factor COLON condition RPAREN LBRACE instruction_liste RBRACE 
    {
        printf("VALID FOR loop with initial assignment, step, and condition\n");
    }
    ;
	
	
if_else_instruction:
    IF LPAREN condition RPAREN LBRACE instruction_liste RBRACE
        { printf("VALID IF block\n"); }
    | IF LPAREN condition RPAREN LBRACE instruction_liste RBRACE ELSE LBRACE instruction_liste RBRACE
        { printf("VALID IF-ELSE block\n"); }
    | IF LPAREN condition RPAREN LBRACE instruction_liste RBRACE ELSE if_else_instruction
        { printf("VALID nested IF-ELSE block\n"); }
    ;

condition:
    arithmetic_expression  	{ printf("VALID condition\n"); }
	|logical_expression     { printf("VALID condition\n"); }
	|comparison_expression   { printf("VALID condition\n"); }
	
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

logical_expression:
    factor OR factor { printf("Logical OR\n"); }
  | factor  AND factor  { printf("Logical AND\n"); }
  | NOT factor  { printf("Logical NOT\n"); }
  ;

comparison_expression:
    factor LE factor { printf("<= comparison\n"); }
  | factor EQ factor { printf("== comparison\n"); }
  | factor NE factor { printf("!= comparison\n"); }
  | factor GE factor { printf(">= comparison\n"); }
  | factor GT factor { printf("> comparison\n"); }
  | factor LT factor { printf("< comparison\n"); }
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

