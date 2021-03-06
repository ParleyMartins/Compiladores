%{
	#include "global.h"
	#include "sintatico.h"
%}

white [ \t]+
letter [a-zA-Z]
digit [0-9]
number {digit}+
symbol ["+"]
string "\""[a-zA-Z0-9\?\+\!\@\#\$\%\^\&\*\(\)\{\}\[\]\' ]*"\""
identifier {letter}(_|{letter}|{digit})*

%%

{white} 		{}

"escreva"		return (PRINT);
"leia"			return (SCAN);

"+"			return (PLUS);
"-"			return (MINUS);
"*"			return (TIMES);
"/"			return (DIVIDE);
"<"			return (LESS_THAN);
">"			return (GREATER_THAN);
"<="			return (LESS_OR_EQUAL);
">="			return (GREATER_OR_EQUAL);
"("			return (OPEN_PARENTHESIS);
")"			return (CLOSE_PARENTHESIS);
"=/="			return (DIFFERENT);
"="			return (EQUAL);
"<-"			return (RECEIVES);
"\n"	 		return (END_LINE);

"," 			return(COMMA);
"e"   			return(AND); 
"ou"   			return(OR);

"inicio"		return (START);
"fim"			return (END);

"se"			return (IF);
"para"			return (FOR);
"entao"			return (THEN);
"senao"			return (ELSE);
"funcao"		return (FUNCTION);
"enquanto"		return (WHILE);

"de"			return (FROM);
"ate"			return (TO);
"passo"			return (STEP);

"fim_se"		return (END_IF);
"fim_para"		return (END_FOR);
"fim_enquanto"		return (END_WHILE);
"fim_funcao"		return (END_FUNCTION);

"numero"		return (NUMBER_TYPE);
"texto"			return (STRING_TYPE);

{identifier}	{
			yylval = (char*) malloc( sizeof(char) ); 
			strcpy(yylval, yytext);
			return (IDENTIFIER);
		}
		

{number}	{ 
			yylval = (char*) malloc( sizeof(char) ); 
			strcpy(yylval, yytext);
			return (NUMBER_VALUE);
		}	


{string}	{ 
			yylval = (char*) malloc( 100 * sizeof(char) ); 
			strcpy(yylval, yytext);
			return (STRING_VALUE);
		}

%%


