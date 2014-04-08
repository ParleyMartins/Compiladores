%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
%}

%token PLUS MINUS TIMES DIVIDE POWER
%token LESS_THAN GREATER_THAN LESS_OR_EQUAL GREATER_OR_EQUAL 
%token OPEN_PARENTHESIS CLOSE_PARENTHESIS
%token DIFFERENT EQUAL RECEIVE 
%token END_LINE START END
%token IF THEN ELSE FOR WHILE FUNCTION
%token PRINT SCAN
%token INT FLOAT CHAR STRING_TYPE BOOL
%token WORD NUMBER STRING_VALUE
%token END_FOR END_WHILE END_FUNCTION
%token QUOTES

%start Input

%%

Input:
	/* Empty Line */
	| Input Line
	;

Line:
	END_LINE
	| Expression { 
		printf("\n");
	}
	;

Expression:
	PRINT QUOTES WORD QUOTES {
		printf("print \"%s\"", $3);
	}
	| PRINT {
		printf("print alone");
	}
	| QUOTES WORD QUOTES {
		printf("string");	
	}
	| NUMBER {
		printf("Numero: %f", (float) $1);	
	}
	;


%%

int yyerror(char *s) {
   printf("%s\n",s);
}

int main(void) {
   yyparse();
}
