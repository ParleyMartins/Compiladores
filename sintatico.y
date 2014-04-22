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

%start Input

%%

Input:
	/* Empty Line */
	| Input Line
	;

Line:
	END_LINE
	| Expression { 
	}
	| IfExpression
	| END { 
		exit(EXIT_SUCCESS); 
	}
	;

Expression:
	PRINT STRING_VALUE {
		printf("\tprint %s\n", $2);	
	}
	;


IfExpression:
	IF OPEN_PARENTHESIS BoolExpression CLOSE_PARENTHESIS {
		printf("\tif %s\n", $3);
	}
	;

BoolExpression:
	/*Empty Line*/ {
		$$ = "";	
	}
	| IDENTIFIER LogicalComparer IDENTIFIER BoolExpression {
		$$ = $1;
		strcat($$, " ");
		strcat($$, $2);
		strcat($$, " ");
		strcat($$, $3);
		strcat($$, $4);
	}
	| BinaryOperator BoolExpression {
		$$ = $1;
		strcat($$, $2);
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
		$$ = " and ";	
	}
	| OR {
		$$ = " or ";	
	}
	;

%%

int yyerror(char *s) {
	printf("%s\n",s);
}

int main(int argc, char* argv[]) {
	printf("Codigo em python:\n");
	yyparse();
}

