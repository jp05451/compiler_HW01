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


%%
        /*Delimiters*/
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

        /* Arithmetic, Relational, and Logical Operators */
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


        /*KeyWord*/
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

        /*      STRING  */

"\""            {
                        BEGIN(STRING);
                }
<STRING>"\n"    {
                LIST;
                printf("%d: %s", linenum++, buf);
                buf[0] = '\0';
                } 

<STRING>.       {LIST;}

<STRING>"\"\""  {strcat(buf,"\"");}

<STRING> "\""   ;{
                LIST;
                tokenString("STR",buf);
                BEGIN(INITIAL);
                }

        /*      COMMENT*/
"%"     {}




\n      {
        LIST;
        printf("%d: %s", linenum++, buf);
        buf[0] = '\0';
        }

[ \t]*  {LIST;}
.       {
        LIST;
        printf("%d:%s\n", linenum+1, buf);
        printf("bad character:'%s'\n",yytext);
        exit(-1);
        }
%%