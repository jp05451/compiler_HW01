%{
#define LIST     strcat(buf,yytext)
#define token(t) {LIST; printf("<%s>\n",#t);}
#define tokenInteger(t,i) {LIST; printf("<%s:%d>\n",#t,i);}
#define tokenString(t,s) {LIST; printf("<%s:%s>\n",#t,s);}

#define MAX_LINE_LENG 256

int linenum = 1;
char buf[MAX_LINE_LENG];
%}

digit [0-9]
digits {digit}+

%%
        /*Delimiters*/
"."     {token('.')}
","     {token(',')}
":"     {token(':')}
";"     {token(';')}

"("     {token('(');}
")"     {token(')');}

"["     {token('[')}
"]"     {token(']')}

"{"     {token('{');}
"}"     {token('}');}

        /* Arithmetic, Relational, and Logical Operators */
"+"     {token('+')}
"-"     {token('-')}
"*"     {token('*')}
"/"     {token('/')}
"mod"   {token('mod')}
":="    {token(':=')}
"<"     {token('<')}
"<="    {token('<=')}
">"     {token('>')}
">="    {token('>=')}
"="     {token('=')}
"not="  {token('not=')}
"and"   {token('and')}
"or"    {token('or')}
"not"   {token('not')}


ID      {token("ID");}

{}
\n      {
        LIST;
        printf("%d: %s", linenum++, buf);
        buf[0] = '\0';
        }

[ \t]*  {LIST;}
    /*hjkhkh*/
.       {
        LIST;
        printf("%d:%s\n", linenum+1, buf);
        printf("bad character:'%s'\n",yytext);
        exit(-1);
        }
%%