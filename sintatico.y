%{
	#include "global.h"
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
%}

%token PLUS MINUS TIMES DIVIDE POWER
%token LESS_THAN GREATER_THAN LESS_OR_EQUAL GREATER_OR_EQUAL 
%token OPEN_PARENTHESIS CLOSE_PARENTHESIS
%token DIFFERENT EQUAL RECEIVE 
%token AND OR NOT
%token END_LINE START END
%token IF THEN ELSE FOR WHILE FUNCTION
%token PRINT SCAN
%token INT FLOAT CHAR STRING_TYPE BOOL
%token IDENTIFIER NUMBER STRING_VALUE
%token END_FOR END_WHILE END_FUNCTION
%token QUOTES WORD

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
	| IfExpression
	;

Expression:
	PRINT QUOTES WordExpression QUOTES{
		printf("codigo em python:\n");
		printf("\tprint %s", $3);	
	}
	;


WordExpression:
	STRING_VALUE{
		$$ = $1;
	}
	| WORD{
		$$ = $1;
	}
	|IDENTIFIER{
		$$ = $1;
	}
	;

IfExpression:
	IF OPEN_PARENTHESIS {
		printf("codigo em python:\n");
		printf("\tif ");
	}
	| BoolExpression CLOSE_PARENTHESIS
	;

BoolExpression:
	/*Empty Line*/
	| IDENTIFIER LogicalComparer IDENTIFIER BoolExpression{
		printf("%s %s %s \n", $1, $2, $3);
	}
	| BinaryOperator BoolExpression{
		printf(" %s ", $1);
	}
	;

LogicalComparer:
	LESS_THAN {
		$$ = "<";
	}
	| GREATER_THAN {
		$$ = ">";
	}
	| LESS_OR_EQUAL {
		$$ = "<=";
	}
	| GREATER_OR_EQUAL {
		$$ = ">=";
	}
	| DIFFERENT {
		$$ = "!=";
	}
	| EQUAL {
		$$ = "==";
	}
	;

BinaryOperator:
	AND {
		$$ = "and";	
	}
	| OR {
		$$ = "or";	
	}
	;

%%

int yyerror(char *s) {
	printf("%s\n",s);
}

int main(int argc, char* argv[]){
	yyparse();
}

