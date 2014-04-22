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

%token END_IF
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
	| Expression
	| END { 
		exit(EXIT_SUCCESS); 
	}
	;

Expression:
	PrintExpression
	| IfExpression
	| WhileExpression
	;

PrintExpression:
	PRINT STRING_VALUE {
		printf("\tprint %s\n", $2);	
	}
	;

IfExpression:
	IF BoolComparasion THEN {
		printf("\tif  %s:\n", $2);
	}
	| ELSE {
		printf("\telse:\n");			
	}
	| END_IF {
		// End if. Do nothing.	
	}
	;

BoolComparasion:
	 BoolExpression BinaryOperator BoolComparasion {
		char *str2 = (char *) malloc (1 + sizeof($1) + sizeof(" ") + sizeof($2) + sizeof(" ") + sizeof($3) );
		strcpy(str2, $1);
		strcat(str2, " ");
		strcat(str2, $2);
		strcat(str2, " ");
		strcat(str2, $3);
		$$ = str2;
	}
	| BoolExpression {
		$$ = $1;
	}
	;
	

BoolExpression:
	IDENTIFIER LogicalComparer IDENTIFIER {
		char *str = (char *) malloc (1 + sizeof($1) + sizeof(" ") + sizeof($2) + sizeof(" ") + sizeof($3) );
		strcpy(str, $1);
		strcat(str, " ");
		strcat(str, $2);
		strcat(str, " ");
		strcat(str, $3);
		$$ = str;
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

WhileExpression:
	WHILE BoolComparasion {
		printf("\twhile  %s:\n", $2);
	}
	| END_WHILE {
		// While end, do nothing. 	
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

