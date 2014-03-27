%{
#include "global.h"
#include <stdlib.h>
#include <stdio.h>
%}

%token INT
%token FLOAT
%token OPEQU OPSUM OPSUB 
%token END

%start Input

%%

Input:
    /* Nothing to do */
    | Input Line
    ; 

Line: 
    END
    | Expression END 	{ printf("Result: %f\n", $1); }
    ;

Expression:
    INT				  { printf("An integer!\n"); $$ = $1; }
    | FLOAT			  { printf("A float!\n"); $$ = $1; }
    | Expression OPSUM Expression { printf("That's a sum!\n"); $$ = $1+$3; }
    | Expression OPSUB Expression { printf("That's a sub!\n"); $$ = $1-$3; }
    ;

%%

int yyerror(char *s) {
printf("Erro!\n");
}

int main(void) {
yyparse();
} 
