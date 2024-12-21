%{
    #include <stdio.h>
    #include "parser4.tab.h"
    #include <string.h>
    int ligne=1;
    int colonne=1;
%}



SPACE " "+
chiffre0 [0-9]
chiffre1 [1-9]
majuscule [A-Z]
miniscule [a-z]



VAR_GLOBAL "VAR_GLOBAL"
DECLARATION "DECLARATION"
INSTRUCTION "INSTRUCTION"
INTEGER_KWD "INTEGER"
FLOAT_KWD  "FLOAT"
CHAR_KWD   "CHAR"
CONST "CONST"



INTEGER    ((LPAREN[+-]({chiffre1}{chiffre0}*|0)RPAREN)|({chiffre1}{chiffre0}*))
FLOAT      ((LPAREN[+-]({chiffre1}{chiffre0}*|0)"\."{chiffre0}*{chiffre1}RPAREN)|(({chiffre1}{chiffre0}*|0)"\."{chiffre0}*{chiffre1}))
CHAR       ({majuscule}|{miniscule}|{chiffre0})
STRING     \".*\"
ID         {majuscule}({majuscule}|{miniscule}|{chiffre0}|_)*{0,7}


ADD "+"
SUB "-"
MUL "*"
DIV "/"



SEMICOLON ";"
VIRGULE ","
LBRACE "{"
RBRACE "}"
LPAREN "("
RPAREN ")"
LSQUARE "["
RSQUARE "]"
COMMENT "%%".*



WRITE "WRITE"
READ "READ"
ASSIGN_OP "="



%%
{SPACE}                  { colonne=colonne+yyleng;/* Ignore whitespace */ }
{COMMENT}                { printf("comment detected: %s\n", yytext); }
{VAR_GLOBAL}             { colonne=colonne+yyleng; return VAR_GLOBAL; }
{DECLARATION}            { colonne=colonne+yyleng; return DECLARATION; }
{INSTRUCTION}            { colonne=colonne+yyleng; return INSTRUCTION; }
{INTEGER_KWD}            { colonne=colonne+yyleng; return INTEGER_KWD; }
{FLOAT_KWD}              { colonne=colonne+yyleng; return FLOAT_KWD; }
{CHAR_KWD}               { colonne=colonne+yyleng; return CHAR_KWD; }
{CONST}                  { colonne=colonne+yyleng; return CONST; }
{INTEGER}                { colonne=colonne+yyleng; yylval.ival = atoi(yytext);
                            return INTEGER;}
{FLOAT}                  { colonne=colonne+yyleng; yylval.fval = atof(yytext);
                         return FLOAT; }

{STRING}                 { colonne=colonne+yyleng; yylval.sval = strdup(yytext);
                         return STRING;}
{ADD}                    { colonne=colonne+yyleng; return PLUS; }
{SUB}                    { colonne=colonne+yyleng; return MINUS; }
{MUL}                    { colonne=colonne+yyleng; return MUL; }
{DIV}                    { colonne=colonne+yyleng; return DIV; }
{SEMICOLON}              { colonne=colonne+yyleng; return SEMICOLON;}
{VIRGULE}                { colonne=colonne+yyleng; return VIRGULE; }
{LBRACE}                 { colonne=colonne+yyleng; return LBRACE; }
{RBRACE}                 { colonne=colonne+yyleng; return RBRACE; }
{LPAREN}                 { colonne=colonne+yyleng; return LPAREN; }
{RPAREN}                 { colonne=colonne+yyleng; return RPAREN; }
{LSQUARE}                { colonne=colonne+yyleng; return LSQUARE; }
{RSQUARE}                { colonne=colonne+yyleng; return RSQUARE; }
{WRITE}                  { colonne=colonne+yyleng; return WRITE; }
{READ}                   { colonne=colonne+yyleng; return READ; }
{ID}                     { colonne=colonne+yyleng; 
                            if(strlen(yytext) > 8) {
                                printf("Erreur Lexicale: identifiant trop long: '%s'\n", yytext);
                            } else { 
                                colonne=colonne+yyleng; yylval.sval = strdup(yytext);
                                return ID;
                            } }
{CHAR}                   { colonne=colonne+yyleng; yylval.sval = strdup(yytext);
                            return CHAR; }
{ASSIGN_OP}              { colonne=colonne+yyleng; return ASSIGN_OP; }
.                        { printf("Erreur Lexicale: caractere unconnue'%s' a la ligne: %d, colonne: %d\n", yytext,ligne,colonne); }
[\n]                     { ligne++; colonne=1; /* Ignore new line */ }
%%
int yywrap(void){
    return 1;
}