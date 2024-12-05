# Compil-projet
HOW TO RUN IT (for win_flex&bison):
win_bison -d parser.y
win_flex lex.l
gcc parser.tab.c lex.yy.c -o compiler
compiler.exe < input.txt
-----------------------------------------------------------------------
remark:
You can modify the input.txt file as desired to test it.