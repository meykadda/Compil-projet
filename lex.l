%{
    #include "parser.tab.h"
    #include <string.h>
%}



VAR_GLOBAL "VAR_GLOBAL"
DECLARATION "DECLARATION"
INSTRUCTION "INSTRUCTION"
ID         [A-Z][a-zA-Z0-9_]{0,7}
INTEGER_KWD "INTEGER"
FLOAT_KWD  "FLOAT"
CHAR_KWD   "CHAR"
INTEGER    ([0-9]+|\([+-][0-9]+\))
FLOAT      ([0-9]+\.[0-9]+|\([+|-][0-9]+\.[0-9]+\))
CHAR       ([a-zA-Z])
MESSAGE    \"[^\"]*\"
CONST "CONST"
FOR        "FOR"
IF         "IF"           
ELSE       "ELSE"

%%
[ \t\r]+               { /* Ignore whitespace */ }
"%%".*                 { printf("comment detected: %s\n", yytext); }
"WRITE"                { printf("keyword detected: WRITE\n"); return WRITE; }
"READ"                 { printf("keyword detected: READ\n"); return READ; }
{INTEGER_KWD}          { printf("integer keyword detected: INTEGER\n"); return INTEGER_KWD; }
{FLOAT_KWD}            { printf("float keyword detected: FLOAT\n"); return FLOAT_KWD; }
{CHAR_KWD}             { printf("char detected: %s\n", yytext); return CHAR_KWD; }
{VAR_GLOBAL}           { printf("global variable section detected\n"); return VAR_GLOBAL; }
{DECLARATION}          { printf("local variable section detected\n"); return DECLARATION; }
{INSTRUCTION}          { printf("instruction section detected\n"); return INSTRUCTION; }
{CONST}                { printf("const detected: %s\n", yytext); return CONST; }
"{"                    { printf("left brace detected\n"); return LBRACE; } 
"}"                    { printf("right brace detected\n"); return RBRACE; } 
"["                    { printf("left bracket detected\n"); return LSQUARE; } 
"]"                    { printf("right bracket detected\n"); return RSQUARE; } 
"("                    { printf("left parenthesis detected\n"); return LPAREN; }
")"                    { printf("right parenthesis detected\n"); return RPAREN; } 
":"                    { printf("colon detected\n"); return COLON; }
"FOR"                  { printf("FOR loop detected\n"); return FOR; }
"IF"                   { printf("IF detected\n"); return IF; }
"ELSE"                 { printf("ELSE detected\n"); return ELSE; }

{ID}                   { 
                            if(strlen(yytext) > 8) {
                                printf("Error: identifier too long: %s\n", yytext);
                            } else {
                                printf("identifier detected: %s\n", yytext); 
                                yylval.sval = strdup(yytext);
                                return ID;
                            }
                       }
{INTEGER}              { printf("integer detected: %s\n", yytext);
                         yylval.ival = atoi(yytext);
                         return INTEGER; 
                       }
{FLOAT}                { printf("float detected: %s\n", yytext);
                         yylval.fval = atof(yytext);
                         return FLOAT; 
                       }
{CHAR}                 { printf("char detected: %s\n", yytext);
                         yylval.sval = strdup(yytext);
                         return CHAR; 
                       }
{MESSAGE}              { printf("message detected: %s\n", yytext);
                         yylval.sval = strdup(yytext + 1);
                         yylval.sval[strlen(yylval.sval) - 1] = '\0';
                         return MESSAGE;
                       }
"+"                    { printf("plus detected\n"); return PLUS;}
"-"                    { printf("minus detected\n"); return MINUS;}
"*"                    { printf("multiplication detected\n"); return MULT;}
"/"                    { printf("division detected\n"); return DIV;}
"="                    { printf("affectation operation detected: %s\n", yytext); return ASSIGN_OP; }
";"                    { printf("semicolon detected\n"); return SEMICOLON;}
","                    { printf("virgule detected\n"); return VIRGULE;}
"&&"                   { printf("and operator detected\n"); return AND; }
"||"                   { printf("or operator detected\n"); return OR; }
"!"                    { printf("not operator detected\n"); return NOT; }
"=="                   { printf("equal operator detected\n"); return EQ; }
"!="                   { printf("not equal operator detected\n"); return NE; }
"<="                   { printf("lower or equal operator detected\n"); return LE; } 
">="                   { printf("greater or equal operator detected\n"); return GE; }
">"                    { printf("greater than operator detected\n"); return GT; }
"<"                    { printf("less than operator detected\n"); return LT; }

.                      { printf("Unknown character: %s\n", yytext); }
[\n]                   { /* Ignore new line */ }
%%
int yywrap(void){
    return 1;
}