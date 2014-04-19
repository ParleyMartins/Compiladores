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
%token WORD

%start Input

%%

Input:
	/* Empty Line */
	| Input Line
	;

Line:
	END_LINE
	| Print { 
		printf("\n");
	}
	| IfExpression { 
		printf("\n");
	}
	;

Print:
	PRINT QUOTES WordExpression QUOTES {
		printf("codigo em python\n");
		printf("\tprint '%s'", $3);	
	}
	;


WordExpression:
	STRING_VALUE {
		$$ = $1;
	}
	| WORD {
		$$ = $1;
	}
	| IDENTIFIER {
		$$ = $1;
	}
	;

IfExpression:
	IF BoolComparasion THEN {
		printf("codigo em python\n");
		printf("\tif  %s:", $2);
	}
	;

BoolComparasion:
	 BoolExpression BinaryOperator BoolExpression {
		char *str2 = (char *) malloc (1 + sizeof($1) + sizeof(" ") + sizeof($2) + sizeof(" ") + sizeof($3) );
		strcpy(str2, $1);
		strcat(str2, " ");
		strcat(str2, $2);
		strcat(str2, " ");
		strcat(str2, $3);
		//strcat(str, " ");
		//strcat(str, $4);
		$$ = str2;
		//free(str2);
	}
	| BoolExpression {
		$$ = $1;
	}
	
	;
	

BoolExpression:
	IDENTIFIER LogicalComparer IDENTIFIER{
		char *str = (char *) malloc (1 + sizeof($1) + sizeof(" ") + sizeof($2) + sizeof(" ") + sizeof($3) );
		strcpy(str, $1);
		strcat(str, " ");
		strcat(str, $2);
		strcat(str, " ");
		strcat(str, $3);
		//strcat(str, " ");
		//strcat(str, $4);
		$$ = str;
		//free(str);
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

