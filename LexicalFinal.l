%{
    #include <stdio.h>
    /* #include "Test6.tab.h"*/
    extern char* strdup(const char*); 
    #include <string.h>
    #define WRITE 1
    #define READ 2
    #define CONST 3
    #define CHAR 4
    #define INTEGER_KWD 5
    #define FLOAT_KWD 6
    #define INSTRUCTION 7
    #define ID 8
    #define VAR_GLOBAL 9
    #define VAR_LOCAL 10
    #define INTEGER 11
    #define FLOAT 12
    #define LBRACE 13
    #define RBRACE 14
    #define LSQUARE 15
    #define RSQUARE 16
    #define COMMENT 17
    #define SEMICOLON 18
    #define ASSIGN_OP 19
    #define IF 20
    #define ELSE 21
    #define LPAREN 22
    #define RPAREN 23
    #define GT 24
    #define GE 25
    #define LT 26
    #define LE 27
    #define EQ 28
    #define NE 29
    #define PLUS 30
    #define MOINS 31
    #define FOIS 32
    #define DIVISE 33
    #define AND_OPPERATOR 34
    #define OR_OPPERATOR 35
    #define NOT_OPPERATOR 36
    #define FOR 37

    extern int yylval;
%}

ID         [A-Z][a-zA-Z0-9_]{0,7}
VAR_GLOBAL "VAR_GLOBAL"
VAR_LOCAL  "VAR_LOCAL"
INSTRUCTION "INSTRUCTION"
INTEGER_KWD "INTEGER"
FLOAT_KWD  "FLOAT"
INTEGER    ([0-9]+|\([+-][0-9]+\))
FLOAT      ([0-9]+\.[0-9]+|\([+|-][0-9]+\.[0-9]+\))

%%

[ \t\r]+               { /* Ignore whitespace */ }
"%%".*                 { printf("comment detected: %s\n", yytext); }
"WRITE"                { printf("keyword detected: WRITE\n"); return WRITE; }
"READ"                 { printf("keyword detected: READ\n"); return READ; }
"CONST"                { printf("keyword detected: CONST\n"); return CONST; }
"CHAR"                 { printf("char detected: %s\n",yytext); return CHAR; }
{INTEGER_KWD}          { printf("integer keyword detected: INTEGER\n"); return INTEGER_KWD; }
{FLOAT_KWD}            { printf("float keyword detected: FLOAT\n"); return FLOAT_KWD; }
{VAR_GLOBAL}           { printf("global variable section detected\n"); return VAR_GLOBAL; }
{VAR_LOCAL}            { printf("local variable section detected\n"); return VAR_LOCAL; }
{INSTRUCTION}          { printf("instructions section detected\n"); return INSTRUCTION; }
"if"                   { printf("IF keyword detected\n"); return IF; }
"else"                 { printf("ELSE keyword detected\n"); return ELSE; }
"FOR"                  { printf("FOR keyword detected\n"); return FOR; }
">="                   { printf("comparison operator detected: >=\n"); return GE; }
"<="                   { printf("comparison operator detected: <=\n"); return LE; }
">"                    { printf("comparison operator detected: >\n"); return GT; }
"<"                    { printf("comparison operator detected: <\n"); return LT; }
"=="                   { printf("comparison operator detected: ==\n"); return EQ; }
"!="                   { printf("comparison operator detected: !=\n"); return NE; }
{ID}                   { 
                            if(strlen(yytext) > 8) {
                                printf("Error: identifier too long: %s\n", yytext);
                            } else {
                                printf("identifier detected: %s\n", yytext); return ID;
                            }
                       }
{INTEGER}              { printf("integer detected: %s\n", yytext); return INTEGER; }
{FLOAT}                { printf("float detected: %s\n", yytext); return FLOAT; }
"+"                    { printf("addition operation detected"); return PLUS; } 
"-"                    { printf("substraction operation detected"); return MOINS; }
"*"                    { printf("multiplication operation detected"); return FOIS; }
"/"                    { printf("division operation detected"); return DIVISE; } 
"&&"                   { printf("logical and operation detected"); return AND_OPPERATOR; }
"||"                   { printf("logical or operation detected"); return OR_OPPERATOR; }
"!"                    { printf("logical not operation detected"); return NOT_OPPERATOR; }
"="                    { printf("affectation operation detected: %s\n", yytext); return ASSIGN_OP; }
"{"                    { printf("left brace detected\n"); return LBRACE; } 
"}"                    { printf("right brace detected\n"); return RBRACE; } 
"["                    { printf("left bracket detected\n"); return LSQUARE; } 
"]"                    { printf("right bracket detected\n"); return RSQUARE; } 
"("                    { printf("left parenthesis detected\n"); return LPAREN; }
")"                    { printf("right parenthesis detected\n"); return RPAREN; }
";"                    { printf("semicolon detected\n"); return SEMICOLON;}
.                      { printf("Unknown character: %s\n", yytext); }
[\n]                   { /* Ignore new line */ }
%%

int main(int argc, char **argv) {
    printf("Start of lexical analysis ...\n");
    while (yylex() != 0) {
        // Continue processing tokens until EOF
    }
    printf("End of lexical analysis ...\n");
    return 0;   
}

int yywrap() {
    return 1;
}
