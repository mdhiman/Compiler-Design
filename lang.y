%{
#include <stdio.h>
#include <ctype.h>

extern char * yytext;
extern FILE *yyin;
static int t=1;
extern int num_lines;
%}

%start lines
%token  IF
%token  BEGINFUN
%token  BEGINIF
%token  BEGINLOOP
%token INTEGER
%token LOOP
%token PRINT
%token ENDFUN
%token ENDIF
%token ENDLOOP
%token BREAK_LOOP
%token SEMI
%token PLUS
%token MINUS
%token MUL
%token DIV
%token MOD
%token GREATER
%token LESS
%token GREATEREQ
%token LESSEQ
%token EQUAL
%token NOTEQUAL
%token ASSIGN
%token ID
%token NUMBER
%token QUOT
%token  OPBR
%token  CLBR
%token ANY

%%
lines		:	lines stmt
			|	stmt
			;
stmt		:	decl
			|	ID ASSIGN expr 
			|	BEGINIF OPBR logexpr CLBR lines  ENDIF 
			|	BEGINLOOP loopstmt ENDLOOP
			|	PRINT QUOT ANY QUOT SEMI
			;
loopstmt	:	loopstmt loopstmt 
			|	decl
			|	ID ASSIGN expr 
			|	BEGINIF OPBR logexpr CLBR ifloopstmt  ENDIF
			|	BEGINLOOP loopstmt ENDLOOP
			|	PRINT QUOT ANY QUOT SEMI
			|	BREAK_LOOP SEMI
			;
ifloopstmt	:	ifloopstmt ifloopstmt
			|	decl
			|	ID ASSIGN expr { 
								 fprintf(stdout,"%s \n",(char *)$1);
							   }
			|	BEGINIF OPBR logexpr CLBR ifloopstmt  ENDIF
			|	BEGINLOOP loopstmt ENDLOOP
			|	BREAK_LOOP SEMI
			;
decl		:	typedecl
			|	fundecl
			;
typedecl 	:	INTEGER ID ASSIGN arexpr SEMI 
			|	INTEGER ID SEMI {printf("in type declaration %s and %s\n",(char*)$2,yytext);}
			;
fundecl		:	BEGINFUN ID lines ENDFUN 
			;
expr		:	arexpr SEMI | logexpr SEMI
			;
arexpr		:	arexpr PLUS arexpr
			|	arexpr MINUS arexpr { fprintf(stdout,"SUB R1,R2,R3\n");}
			|	arexpr MUL arexpr { fprintf(stdout,"MUL R1,R2,R3\n");}
			|	arexpr DIV arexpr { fprintf(stdout,"DIV R1,R2,R3\n");}
			|	OPBR arexpr CLBR { fprintf(stdout,"open\n");}
			|	ID {printf("Id received \n");}
			|	NUMBER
			;
logexpr		:	arexpr GREATER arexpr
			|	arexpr GREATEREQ arexpr
			|	arexpr LESSEQ arexpr
			|	arexpr LESS arexpr
			|	arexpr EQUAL arexpr
			|	arexpr NOTEQUAL arexpr
			|	ID 
			|	NUMBER
			;



%%

void yywrap()
{
	printf("End of input\n");
}

main(){
do {
yyparse();
} while(!feof(yyin));
}
yyerror(char *s){	
		fprintf(stderr,"unrecognizable token in line num %d",num_lines);
		return 1;
}
