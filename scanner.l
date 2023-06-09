%{
#include<stdio.h>
#include"symbolTable.hpp"

#define LIST     strcat(buf,yytext)
#define token(t) {LIST; printf("<%s>\n",#t);}
#define tokenInteger(t,i) {LIST; printf("<%s:%d>\n",#t,i);}
#define tokenString(t,s) {LIST; printf("<%s:%s>\n",#t,s);}
#define yyDebug(s) printf("%s",s);

#define MAX_LINE_LENG 256

int linenum = 1;
char buf[MAX_LINE_LENG];
char strTemp[MAX_LINE_LENG];
symbolTable s_table;
%}

digit [0-9]
digits {digit}+
numerical {digits}+("."{digits}+)?

alphaBat [a-zA-Z]
ID {alphaBat}+({digits}|{alphaBat})*

%x STRING
%x COMMENT
%x COMMENT_LINES

%%
        /*==========Delimiters==========*/
"."     {token('.');}
","     {token(',');}
":"     {token(':');}
";"     {token(';');}

"("     {token('(');}
")"     {token(')');}

"["     {token('[');}
"]"     {token(']');}

"{"     {token('{');}
"}"     {token('}');}

        /*==========Arithmetic, Relational, and Logical Operators==========*/
"+"     {token('+');}
"-"     {token('-');}
"*"     {token('*');}
"/"     {token('/');}
"mod"   {token('mod');}
":="    {token(':=');}
"<"     {token('<');}
"<="    {token('<=');}
">"     {token('>');}
">="    {token('>=');}
"="     {token('=');}
"not="  {token('not=');}
"and"   {token('and');}
"or"    {token('or');}
"not"   {token('not');}


        /*==========KeyWord==========*/
array           {token(ARRAY);}
begin           {token(BEGIN);}
bool            {token(BOOL);}
char            {token(CHAR);}
const           {token(CONST);}
decreasing      {token(DECREASING);}
default         {token(DEFAULT);}
do              {token(DO);}
else            {token(ELSE);}
end             {token(END);}
exit            {token(EXIT);}
false           {token(FALSE);}
for             {token(FOR);}
function        {token(FUNCTION);}
get             {token(GET);}
if              {token(IF);}
int             {token(INT);}
loop            {token(LOOP);}
of              {token(OF);}
put             {token(PUT);}
procedure       {token(PROCEDURE);}
real            {token(REAL);}
result          {token(RESULT);}
return          {token(RETURN);}
skip            {token(SKIP);}
string          {token(STRING);}
then            {token(THEN);}
true            {token(TRUE);}
var             {token(VAR);}
when            {token(WHEN);}


        /*==========Identity==========*/
{ID}            {
                token("ID");
                printf("id %s\n",yytext);
                s_table.insert(yytext);
                }

{numerical}     {
                float number;
                sscanf(yytext,"%f",&number);
                tokenInteger("NUMBER",number);
                }

        /*==========STRING==========*/

\"              {
                        // LIST;
                        // printf("begin string\n");
                        BEGIN(STRING);
                }

        /* <STRING>\n      {
                // printf("next line\n");
                // strcpy(yytext,strTemp);
                // yytext=strTemp;
                // puts(yytext);
                // LIST;
                strcat(buf,strTemp);
                // strcat(buf,"\"");
                printf("%d: %s", linenum++, buf);
                buf[0] = '\0';
                }  */



<STRING>\"\"    {
                        // // yyless(yyleng-1);
                        // // strcat(yytext,"test");
                        // // puts(yytext);
                        //                         printf("\"\"TEST:%d\n",yyleng);

                        // puts(yytext);

                        // yytext[--yyleng]='\0';
                        
                        // char c;
                        // for(int i=0;i<5;i++)
                        // {
                        //         c=yyinput();
                        // }


                        // printf("\"\"TEST:%d\n",yyleng);
                        // for(int i=0;i<=yyleng;i++)
                        // {
                        // if(yytext[i]!='\0')
                        //         putchar(yytext[i]);
                        // else
                        //         printf("|NULL|");
                        // }
                        // puts("");

                        // // char c = yyinput();
                        // // c=yyinput();
                        // // c=yyinput();

                        // // putchar(c);
                        // // puts("");
                        
                        // yymore();

                        strcat(strTemp,"\"");

                }


<STRING>\"      {
                // yytext[yyleng-1]='\0';
                // strcpy(yytext,strTemp);
                // yytext=strTemp;
                tokenString(STR,strTemp);
                // strTemp[0]='\0';
                yytext=strTemp;
                LIST;
                strcat(buf,"\"");
                // puts(yytext);
                BEGIN(INITIAL);
                }

<STRING>[^\"]*          {
                        // printf("TEST:%d\n",yyleng);
                        // for(int i=0;i<=yyleng;i++)
                        // {
                        // if(yytext[i]!='\0')
                        //         putchar(yytext[i]);
                        // else
                        //         printf("|NULL|");
                        // }
                        // puts("");
                        // yymore();
                        
                        strcat(strTemp,yytext);
                        // puts(strTemp);
                        }


        /*==========COMMENT==========*/
%               {
                LIST;
                BEGIN(COMMENT);
                }
<COMMENT>\n     {
                LIST;
                printf("%d: %s", linenum++, buf);
                buf[0] = '\0';
                BEGIN(INITIAL);
                }
<COMMENT>.      {LIST;}

        /*/*==========COMMENT_LINE/*==========*/
"{%"    {
        LIST;
        BEGIN(COMMENT_LINES);
        }

<COMMENT_LINES>"%}"        {
                        LIST;
                        BEGIN(INITIAL);
                        }

<COMMENT_LINES>\n       {
                        LIST;
                        printf("%d: %s", linenum++, buf);
                        buf[0] = '\0';
                        }    
<COMMENT_LINES>.        {LIST;}



        /*==========next line==========*/
\n      {
        LIST;
        printf("%d: %s", linenum++, buf);
        buf[0] = '\0';
        }
        /*==========white space==========*/
[ \t]*  {LIST;}

.       {
        LIST;
        printf("%d:%s\n", linenum+1, buf);
        printf("bad character:'%s'\n",yytext);
        exit(-1);
        }
%%



int main(int argc, char *argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s filename\n", argv[0]);
        return 1;
    }

    FILE *file = fopen(argv[1], "r");
    if (!file) {
        perror("Error opening file");
        return 1;
    }
        s_table.creat();        
    yyin = file; 
    yylex(); 

    fclose(file); 
    s_table.dump();
    return 0;
}
