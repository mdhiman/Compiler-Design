%{
#include <stdio.h>
#include "lang.tab.h"
int num_lines=0;
%}

delim		[ \t]
ws			{delim}+
letter		[A-Za-z]
digit		[0-9]
id			{letter}({letter}|{digit})*
number  	{digit}+

%%
"\n"		{++num_lines;}
{ws}		{/* NO ACTION */}
beginfun	{return(BEGINFUN);}
beginif		{return(BEGINIF);}
beginloop	{return(BEGINLOOP);}
integer		{return(INTEGER);}
print		{return(PRINT);}
endfun		{return(ENDFUN);}
endif		{return(ENDIF);}
endloop		{return(ENDLOOP);}
break_loop	{return(BREAK_LOOP);}
";"			{return(SEMI);}
"GT"		{return(GREATER);}
"LT"		{return(LESS);}
"GTE"		{return(GREATEREQ);}
"LTE"		{return(LESSEQ);}
"EQUAL"		{return(EQUAL);}
"NEQ"		{return(NOTEQUAL);}
"+"			{return(PLUS);}
"-"			{return(MINUS);}
"*"			{return(MUL);}
"/"			{return(DIV);}
"="			{return(ASSIGN);}
{id}		{return(ID) ;}
{number}	{return(NUMBER) ; }
"\""		{return(QUOT);}
"("			{return(OPBR);}
")"			{return(CLBR);}
.			{return(ANY);}
%%


