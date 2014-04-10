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
	QUOTES STRING_VALUE QUOTES {
		printf("string REGRA nova: \n %s", $2);	
	}
	| NUMBER {
		printf("Numero: %f", atof($1));	
	}
	| IfExpression{
		printf("If: ");
	}
	| OPEN_PARENTHESIS {
		printf("teste ");
	}
	;


IfExpression:
	IF OPEN_PARENTHESIS BoolExpression CLOSE_PARENTHESIS{
		printf("codigo em python:\n");
		printf("\tif ");
	}
	;

BoolExpression:
	/*Empty Line*/
	| IDENTIFIER LogicalComparer IDENTIFIER BoolExpression{
		printf("%s %s %s", $1, $2, $3);
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

