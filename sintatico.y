%{
	#include "global.h"
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include "table.h"
	Table* table;
	int lineNumber = 1;
	int scope = 0;
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
%token RECEIVES 

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

%token FROM
%token TO
%token STEP

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

%token TRUE
%token FALSE

%start Input

%%

Input:
	/* Empty Line */
	| Input Line
	;

Line:
	END_LINE {
		lineNumber++;
	}
	| START {
		Symbol* main = createSymbol(NULL, "void",
				"main", "", "int", scope);
		table = createTable(main);
		//printTable(table);
		printf("start\n");
		scope++;
		//free(main);
	}
	| Expression {
		printTable(table);
	}
	| END { 
		printf("end");
		if(!table){
			deleteTable(table);
		}
		scope = scope - 1;
		exit(EXIT_SUCCESS); 
	}
	;

Expression:
	PrintExpression
	| IfExpression
	| WhileExpression
	| ForExpression
	| AttribuitionExpression
	| DeclarationExpression 
	;

PrintExpression:
	PRINT STRING_VALUE {
		printf("\tprint %s\n", $2);	
	}
	;

IfExpression:
	IF BoolComparasion THEN {
		printf("\tif  %s:\n", $2);
		scope++; 
	}
	| ELSE {
		printf("\telse:\n");			
	}
	| END_IF {
		scope--;
	}
	;

BoolComparasion:
	 BoolExpression BinaryOperator BoolComparasion {
		char *str2 = (char *) malloc (sizeof(char));
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
		char *str = (char *) malloc (sizeof(char));
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
		scope++;
	}
	| END_WHILE {
		scope--; 	
	}
	;
	
ForExpression:
	FOR IDENTIFIER FROM NumberOrIdentifier TO NumberOrIdentifier STEP NUMBER {
		printf("\tfor %s in range(%s , %s, %s):\n", $2, $4, $6, $8);
		scope++;
	}
	| FOR IDENTIFIER FROM NumberOrIdentifier TO NumberOrIdentifier {
		printf("\tfor %s in range(%s , %s):\n", $2, $4, $6);
		scope++;
	}
	| END_FOR {
		scope--;
	}
	;

NumberOrIdentifier:
	IDENTIFIER {
		$$ = $1;
	}
	| NUMBER {
		$$ = $1;
	}
	;

AttribuitionExpression:
	IDENTIFIER RECEIVES AttribuitionValue {
		setVariable(table, $1, $3);
	}
	;

AttribuitionValue:
	NUMBER {
		$$ = $1;
	}
	| STRING_VALUE {
		$$ = $1;
	}
	| TRUE {
		$$ = "true";
	}
	| FALSE {
		$$ = "false";
	}
	;

DeclarationExpression:
	Type IDENTIFIER {
		int	errorCode = insertVariable(table, $1, $2, NULL, NULL, scope);
		//checkError(errorCode, $1);
	}
	| Type IDENTIFIER RECEIVES AttribuitionValue {
		int	errorCode = insertVariable(table, $1, $2, $4, NULL, scope);			
		//checkError(errorCode, $1);
	}
	;

Type:
	INT {
		$$ = "int";
	}
	| FLOAT {
		$$ = "float";
	}
	| CHAR {
		$$ = "char";
	}
	| STRING_TYPE {
		$$ = "string";
	}
	| BOOL {
		$$ = "bool";
	}
	;

%%



int yyerror(char *s) {
	printf("%s Line %d\n", s, lineNumber);
}

int main(int argc, char* argv[]) {
	//printf("Codigo em python:\n");
	yyparse();
}
