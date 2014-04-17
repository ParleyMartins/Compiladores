%{
	#include "global.h"
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
%}

%token PLUS
%token MINUS
%token TIMES
%token DIVIDE
%token POWER

%token LESS_THAN
%token GREATER_THAN
%token LESS_OR_EQUAL
%token GREATER_OR_EQUAL 

%token OPEN_PARENTHESIS
%token CLOSE_PARENTHESIS

%token DIFFERENT
%token EQUAL
%token RECEIVE 

%token AND
%token OR
%token NOT

%token END_LINE
%token START
%token END

%token IF
%token THEN
%token ELSE
%token FOR
%token WHILE
%token FUNCTION

%token PRINT
%token SCAN

%token INT
%token FLOAT
%token CHAR
%token STRING_TYPE
%token BOOL

%token IDENTIFIER
%token NUMBER
%token STRING_VALUE

%token END_FOR
%token END_WHILE
%token END_FUNCTION

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
	| IfExpression
	;

Expression:
	PRINT QUOTES WordExpression QUOTES {
		printf("codigo em python:\n");
		printf("\tprint \"%s\"", $3);	
	}
	;


WordExpression:
	STRING_VALUE {
		$$ = $1;
	}
	| NUMBER {
		$$ = $1;
	}
	|IDENTIFIER {
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
	| IDENTIFIER LogicalComparer IDENTIFIER BoolExpression {
		printf("%s %s %s \n", $1, $2, $3);
	}
	| BinaryOperator BoolExpression {
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

int main(int argc, char* argv[]) {
	yyparse();
}

