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
array           {token("ARRAY");}
begin           {token("BEGIN");}
bool            {token("BOOL");}
char            {token("CHAR");}
const           {token("CONST");}
decreasing      {token("DECREASING");}
default         {token("DEFAULT");}
do              {token("DO");}
else            {token("ELSE");}
end             {token("END");}
exit            {token("EXIT");}
false           {token("FALSE");}
for             {token("FOR");}
function        {token("FUNCTION");}
get             {token("GET");}
if              {token("IF");}
int             {token("INT");}
loop            {token("LOOP");}
of              {token("OF");}
put             {token("PUT");}
procedure       {token("PROCEDURE");}
real            {token("REAL");}
result          {token("RESULT");}
return          {token("RETURN");}
skip            {token("SKIP");}
string          {token("STRING");}
then            {token("THEN");}
true            {token("TRUE");}
var             {token("VAR");}
when            {token("WHEN");}


{ID}            {token("ID");}

{numerical}     {
                float number;
                sscanf(yytext,"%f",&number);
                tokenInteger("NUMBER",number);
                }

        /*==========STRING==========*/

\"              {
                        LIST;
                        BEGIN(STRING);
                }
<STRING>\n      {
                LIST;
                printf("%d: %s", linenum++, buf);
                buf[0] = '\0';
                } 



<STRING>\"\"    {strcat(buf,"\"");}

<STRING>\"      {
                tokenString(string,yytext);
                // tokenString("STR","yytext");
                BEGIN(INITIAL);
                }

<STRING>[^\"\n] {
                yymore();
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

    yyin = file; 
    yylex(); 

    fclose(file); 
    return 0;
}
