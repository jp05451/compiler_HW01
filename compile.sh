lex scanner.l
mv lex.yy.c lex.yy.cpp
g++ lex.yy.cpp -ll 
