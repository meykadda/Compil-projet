# Compiler Project

This project implements a simple compiler using Flex and Bison. Follow the instructions below to run the project on a Windows system using `win_flex` and `win_bison`.

## Requirements

- `win_flex` (Windows version of Flex)
- `win_bison` (Windows version of Bison)
- `gcc` (GNU Compiler Collection for compiling C files)
- An input file (`input.txt`) for testing the compiler.

## How to Run It (for `win_flex` & `win_bison`)

1. **Generate the parser and scanner:**
   Open the command prompt and run the following commands:

   ```bash
   win_bison -d parser.y    # Generate the parser from Bison file
   win_flex lex.l           # Generate the scanner from Flex file

2. **Next, you need to compile the generated C files using gcc:**

   ```bash
   gcc parser.tab.c lex.yy.c TS.c -o compiler   # Compile the C files into the executable
   compiler.exe < input.txt   # Execute the compiled program with your input.txt


