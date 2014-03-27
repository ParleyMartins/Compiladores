%{
#include "global.h"
#include "sintatic.h"
#include <stdlib.h>
%}

blank [ \t]+
digit [0-9]
int {digit}+
float {int}"."{int}

%%

{blank}		{ /* Do nothing */ }
{int}		{ yylval = atof(yytext); return(INT); }
{float}		{ yylval = atof(yytext); return(FLOAT); }	
"\n"		{ return(END); }	
"="		{ return(OPEQU); }
"+"		{ return(OPSUM); }
"-"		{ return(OPSUB); }

%%

yywrap() {
return 0;
}
