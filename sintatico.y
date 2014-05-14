%{
	#include "global.h"
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include "table.h"
	Table* table;
	int debugOption;
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
		table = createTable(main, debugOption);

		printf("#!/usr/bin/env python\n");
	}
	| Expression {
		printTable(table);
		printf("\n");
		indent(scope);
	}
	| END { 
		if(!table){
			deleteTable(table);
		}
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
		printf("print %s\n", $2);	
	}
	| PRINT IDENTIFIER {
		Symbol* variable = findName(table, $2);
		if(variable == NULL){
			printf("Variavel nao declarada");
			return UNDECLARED_VARIABLE;
		}
		printf("print %s", $2);
	}
	;

IfExpression:
	IF BoolComparasion THEN {
		printf("if  %s:", $2);
		scope++; 
	}
	| ELSE {
		printf("else:");			
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
		printf("while  %s:", $2);
		scope++;
	}
	| END_WHILE {
		scope--; 	
	}
	;
	
ForExpression:
	FOR IDENTIFIER FROM NumberOrIdentifier TO NumberOrIdentifier STEP NUMBER {
		printf("for %s in range(%s , %s, %s):", $2, $4, $6, $8);
		scope++;
	}
	| FOR IDENTIFIER FROM NumberOrIdentifier TO NumberOrIdentifier {
		printf("for %s in range(%s , %s):", $2, $4, $6);
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
		printf("%s = %s", $1, $3);
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
	| MathExpression {
		$$ = $1;
	}
	;

DeclarationExpression:
	Type IDENTIFIER {
		insertVariable(table, $1, $2, NULL, NULL, scope);
		//checkError(errorCode, $1);
	}
	| Type IDENTIFIER RECEIVES AttribuitionValue {
		insertVariable(table, $1, $2, $4, NULL, scope);			
		printf("%s = %s", $2, $4);
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

MathExpression:
	MathParam
	| MathExpression Operator MathExpression {
		char *str = (char *) malloc (sizeof(char));
		strcpy(str, $1);
		strcat(str, " ");
		strcat(str, $2);
		strcat(str, " ");
		strcat(str, $3);
		$$ = str;
	}
	| OPEN_PARENTHESIS MathExpression CLOSE_PARENTHESIS {
		char *str = (char *) malloc (sizeof(char));
		strcpy(str, "(");
		strcat(str, " ");
		strcat(str, $2);
		strcat(str, " ");
		strcat(str, ")");
		$$ = str;
	}
	;

MathParam:
	IDENTIFIER {
		Symbol* val = findName(table,$1);
		if(val!=NULL && val->value!=NULL){
			if(strcmp(val->type,"int")==0){
				$$ = $1;
			} else {
				printf("ERROR! TYPE");
			}
		} else {
			printf("ERROR! NULL");
		}
	}
	| NUMBER {
		$$ = $1;
	}
	;

Operator:
	PLUS {
		$$ = "+";
	}
	| MINUS {
		$$ = "-";
	}
	| DIVIDE {
		$$ = "/";
	}
	| TIMES {
		$$ = "*";
	}
	;
%%



int yyerror(char *s) {
	printf("%s Line %d\n", s, lineNumber);
}

int main(int argc, char* argv[]) {
	if(argv[1] != NULL){
		if(strcmp(argv[1], "-debug") == 0){ 
			debugOption = 1;
		} else {
			debugOption = 0;
		}
	}
	yyparse();
}
