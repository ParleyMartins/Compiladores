%{
	#include "global.h"
	#include "sintatico.h"
	#include <stdlib.h>
	#include <stdio.h>
	#include "string.h"
%}

white [ \t]+
letter [a-zA-Z]
word {letter}+
digit [0-9]
number {digit}+
string [".*"]

%%

{white} 	{}

"+"		return (PLUS);
"-"		return (MINUS);
"*"		return (TIMES);
"/"		return (DIVIDE);
"<"		return (LESS_THAN);
">"		return (GREATER_THAN);
"<="		return (LESS_OR_EQUAL);
">="		return (GREATER_OR_EQUAL);
"("		return (OPEN_PARENTHESIS);
")"		return (CLOSE_PARENTHESIS);
"^"		return (POWER);
"=/="		return (DIFFERENT);
"="		return (EQUAL);
"<-"		return (RECEIVE);
"\n" 		return (END_LINE);
"\"" 		return (QUOTES);

"inicio"	return (START);
"fim"		return (END);

"se"		return (IF);
"para"		return (FOR);
"entao"		return (THEN);
"senao"		return (ELSE);
"funcao"	return (FUNCTION);
"enquanto"	return (WHILE);

"fim_se"	return (END_FOR);
"fim_para"	return (END_FOR);
"fim_enquanto"	return (END_WHILE);
"fim_funcao"	return (END_FUNCTION);

"escreva"	return (PRINT);
"leia"		return (SCAN);

"inteiro"	return (INT);
"real"		return (FLOAT);
"caractere"	return (CHAR);
"texto"		return (STRING_TYPE);
"booleano"	return (BOOL);

{word}		{
			yylval = (char*) malloc( sizeof(char) ); 
			strcpy(yylval, yytext);
			return (WORD);
		}

{number}	{ 
			yylval = (char*) malloc( sizeof(char) ); 
			strcpy(yylval, yytext);
			return (NUMBER);
		}	

%%

yywrap () {
return 0;
}
