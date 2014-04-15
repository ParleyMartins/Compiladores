%{
	#include "global.h"
	#include "sintatico.h"
	#include <stdlib.h>
	#include <stdio.h>
	#include "string.h"
%}

white [ \t]+
letter [a-zA-Z]
word [a-zA-Z0-9]+
digit [0-9]
number {digit}+
string [a-zA-Z0-9 ]+
identifier {letter}(_|{letter}|{digit})*

%%


{white} 	{}


"escreva "	return (PRINT);
"leia "		return (SCAN);

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

" e "   		return(AND); 
" ou "   		return(OR);
" nao " 		return(NOT);

"inicio"	return (START);
"fim"		return (END);

"se "		return (IF);
"para "		return (FOR);
"entao "		return (THEN);
"senao "		return (ELSE);
"funcao "	return (FUNCTION);
"enquanto "	return (WHILE);

"fim_se"	return (END_FOR);
"fim_para"	return (END_FOR);
"fim_enquanto"	return (END_WHILE);
"fim_funcao"	return (END_FUNCTION);

"inteiro "	return (INT);
"real "		return (FLOAT);
"caractere "	return (CHAR);
"texto "		return (STRING_TYPE);
"booleano "	return (BOOL);



{identifier}	{
			yylval = (char*) malloc( sizeof(char) ); 
			strcpy(yylval, yytext);
			return (IDENTIFIER);
		}
		

{number}	{ 
			yylval = (char*) malloc( sizeof(char) ); 
			strcpy(yylval, yytext);
			return (NUMBER);
		}	

{word} { 
			yylval = (char*) malloc( sizeof(char) ); 
			strcpy(yylval, yytext);
			return (WORD);
		}

{string}	{ 
			yylval = (char*) malloc( sizeof(char) ); 
			strcpy(yylval, yytext);
			return (STRING_VALUE);
		}


%%

yywrap () {
	return 0;
}

