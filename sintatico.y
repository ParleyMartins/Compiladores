%{
	#include "global.h"
	#include "code.h"

	Table* table;
	Table* functionsTable;
	int debugOption;
	int lineNumber = 1;
	int scope = 0;
	int has_error = 0;
	int second_parse = 0;
	int allow_comments = 0;
	char* argumentList;
	char* callingList;
%}

%token PLUS
%token MINUS
%token TIMES
%token DIVIDE

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

%token IDENTIFIER
%token NUMBER
%token STRING_VALUE

%token END_IF
%token END_FOR
%token END_WHILE
%token END_FUNCTION

%token COMMA

%start StartExpression

%%

StartExpression:
	START {
		Symbol* main = createSymbol(NULL, "void",
				"main", "", "int", scope);
		table = createTable(main, debugOption);

		printCode("#!/usr/bin/env python\n\n", second_parse);
		printComment("#Ola, bem-vindo ao Python!\n", second_parse, allow_comments);
		printComment("#O Símbolo '#' inicia um comentário. O identificador Python ignora tudo que vem depois do '#'\n", second_parse, allow_comments);
		printComment("#Apesar do computador ignorar o comentário, use-o para clarear pontos 'obscuros' do código.\n", second_parse, allow_comments);

		printComment("\n#Observe os finais das linhas.\n\n", second_parse, allow_comments);

		argumentList = calloc(100, sizeof(char));
		callingList = calloc(100, sizeof(char));
	} Input
	;

Input:
	/* Empty Line */
	| Input Line
	;

Line:
	END_LINE {
		lineNumber++;
	}
	| Expression {
		printTable(table);
		printCode("\n", second_parse);
		indent(scope, second_parse);
	}
	| END { 
		if(table != NULL){
			deleteTable(table, scope);
			printTable(table);
		} else {
			printTable(table);
		}

		if (functionsTable != NULL){
			deleteTable(functionsTable, scope);
			printTable(functionsTable);
		} else {
			printTable(functionsTable);
		}

		if (table->head != NULL){
			printf("Error: Finalize uma das estruturas\n");
			scope--;
			deleteTable(table, scope);
			printTable(table);
			has_error = 1;
		}


		if (functionsTable->head != NULL){
			printf("Error: Finalize uma das estruturas\n");
			scope--;
			deleteTable(functionsTable, scope);
			printTable(functionsTable);
			has_error = 1;
		}
		printComment("\n#Se voce chegou aqui se perguntando onde estao as malditas chaves, \n", second_parse, allow_comments);
		printComment("#enquanto estiver no Python nao se preocupe com isso. O que essa linguagem usa \n", second_parse, allow_comments);
		printComment("#é a identacao do codigo. Assim o controle do escopo é mais fácil e o seu codigo fica muito mais legivel. =) \n", second_parse, allow_comments);
	
		printComment("\n#Um outro detalhe que voce deve ter percebido (se ja usou alguma outra linguagem), \n", second_parse, allow_comments);
		printComment("#é que o ';' também nao apareceu no codigo. \n", second_parse, allow_comments);
		printComment("#O Python nao precisa disso para saber que o seu comando acabou. Um comando por linha é o suficiente. \n", second_parse, allow_comments);
	}
	;

Expression:
	PrintExpression
	| IfExpression
	| WhileExpression
	| ForExpression
	| AttribuitionExpression
	| DeclarationExpression
	| ScanExpression
	| FunctionExpression
	| CallingFunctionExpression
	| error END_LINE {
		lineNumber++;
		yyerrok;
	}
	;

PrintExpression:
	PRINT STRING_VALUE {
		char *buffer = (char*) malloc(100 * sizeof(char));
		sprintf(buffer,"print %s",$2);
		printCode(buffer, second_parse);
		printComment("\t#Observe que para imprimir basta colocar a palavra reservada 'print' e a frase desejada entre aspas (simples ou duplas).", second_parse, allow_comments);
	}
	| PRINT IDENTIFIER {
    if(!is_variable_declared(table, $2)){
      has_error = 1;
    }

    char *buffer = (char*) malloc(sizeof(char));
		sprintf(buffer,"print %s", $2);
		printCode(buffer, second_parse);
		printComment("\t#Para imprimir uma variavel coloque a palavra reservada 'print' e o nome da variavel.", second_parse, allow_comments);
	}
	;

ScanExpression:
	SCAN IDENTIFIER {
    if(!is_variable_declared(table, $2)){
      has_error = 1;
    }
    
    char *buffer = (char*) malloc(sizeof(char));
		sprintf(buffer,"%s = raw_input()",$2);
		printCode(buffer, second_parse);
		printComment(" \t#A funcao raw_input aceita como argumento a mensagem para o usuario\n", second_parse, allow_comments);			
		indent(scope, second_parse);
		printComment("\t#Essa funcao le o que o usuario digitar ate o 'enter'", second_parse, allow_comments);
	}
	;

FunctionExpression:
	FUNCTION IDENTIFIER OPEN_PARENTHESIS Parameter CLOSE_PARENTHESIS {
		if(!function_is_declared(functionsTable, $2)){
      has_error = 1;
    }
		
    char *buffer = (char*)malloc(sizeof(char));
		sprintf(buffer, "def %s( %s ):", $2, $4);
		printCode(buffer,second_parse);

		scope++;
		insertVariable(functionsTable, "function", $2, argumentList, NULL, scope);
		argumentList = calloc(100, sizeof(char));

	}
	| FUNCTION IDENTIFIER OPEN_PARENTHESIS CLOSE_PARENTHESIS {
		if(!function_is_declared(functionsTable, $2)){
      has_error = 1;
    }

		char *buffer = (char*)malloc(sizeof(char));
		sprintf(buffer, "def %s():", $2);
		printCode(buffer,second_parse);
		
		scope++;
		insertVariable(functionsTable, "function", $2, "", NULL, scope);
	}
	| END_FUNCTION {
		deleteTable(table,scope);
		scope--;
		printTable(table);
		printComment("#Observe a identaçao da proxima linha. \n", second_parse, allow_comments);
	}
	;

CallingFunctionExpression:
	IDENTIFIER OPEN_PARENTHESIS CallingParameter CLOSE_PARENTHESIS {
	  Symbol* function = findName(functionsTable, $2);
	  if (function == NULL) {
  		has_error = 1;				
      printf("Error: Funcao %s nao declarada\n", $2);
    } else {
      char *arguments = (char*) malloc(sizeof(char));
        strcat(arguments, function->value);
			
			if (strcmp(arguments, callingList) == 0) {
				char *buffer = (char*) malloc(sizeof(char));
				sprintf(buffer,"%s( %s )",$1, $3);
				printCode(buffer, second_parse);
			} else {
				printf("Error: A funcao %s espera argumentos dos tipos [ %s]. Obtidos [ %s]\n", $1, arguments, callingList);
				has_error = 1;
			}

			callingList = calloc(100, sizeof(char));
		}
	}
	| IDENTIFIER OPEN_PARENTHESIS CLOSE_PARENTHESIS {
	  Symbol* function = findName(functionsTable, $2);
	  if (function == NULL) {
  		has_error = 1;				
      printf("Error: Funcao %s nao declarada\n", $2);
    } else {
      char *arguments = (char*) malloc(sizeof(char));
        strcat(arguments, function->value);

			if (strcmp(arguments, "") == 0) {
				char *buffer = (char*) malloc(sizeof(char));
				sprintf(buffer,"%s()",$1);
				printCode(buffer, second_parse);		
			} else {
				printf("Error: A funcao %s espera argumentos dos tipos [ %s]. Obtidos [ %s]\n", $1, arguments, callingList);
				has_error = 1;
			}
			
			callingList = calloc(100, sizeof(char));
		}
	}
	;

Parameter:
	DeclarationExpression COMMA Parameter {	
		if($1 != NULL) {
			char *str = (char*) malloc (sizeof(char));
			strcpy(str,$1);
			
			Symbol* variable = findName(table, $1);
			if (variable != NULL) {
				variable->value = "10";
			}

			strcat(str, ", ");
			strcat(str, $3);

			$$ = str;
		}
	}
	| DeclarationExpression {
		if($1 != NULL){
			Symbol* variable = findName(table, $1);			
			if (variable != NULL) {
				variable->value = "10";
			}

			$$ = $1;
		}
	}
	;

CallingParameter:
	Argument COMMA CallingParameter {	
		if ($1 != NULL) {
			char *str = (char*) malloc (sizeof(char));
			strcpy(str,$1);
			
			strcat(str, ", ");
			strcat(str, $3);
		
			$$ = str;
		}
	}
	| Argument {
		if ($1 != NULL) {
			char *str = (char*) malloc (sizeof(char));
			strcpy(str,$1);

			$$ = str;
		}
	}
	;

Argument:
	IDENTIFIER {
		Symbol* variable = findName(table, $1);
		if (variable != NULL) {
			strcat(callingList, variable->type);
			strcat(callingList, " ");
		}
	}
	| NUMBER {
		strcat(callingList, "int");
		strcat(callingList, " ");
	}
	| STRING_VALUE {
		strcat(callingList, "string");
		strcat(callingList, " ");
	}
	;

IfExpression:
	IF BoolComparasion THEN {
		char *buffer = (char*) malloc(sizeof(char));
		sprintf(buffer,"if  %s:", $2);
		printCode(buffer, second_parse);
		scope++; 
		insertVariable(table, "function", "if", NULL, NULL, scope);
		printComment("\t#Uma estrutura condicional usa o 'if' e a condicao (sem parenteses) seguida de dois pontos", second_parse, allow_comments);
	}
	| ELSE {
		printCode("else:", second_parse);			
		printComment("\t#Se uma segunda condicao for colocada dentro do else, use 'elif [expressao2] :'", second_parse, allow_comments);
	
	}
	| END_IF {
		deleteTable(table, scope);
		scope--;
		printTable(table);
		printComment("#Observe a identaçao da proxima linha. \n", second_parse, allow_comments);
	}
	;

BoolComparasion:
	 BoolExpression BinaryOperator BoolComparasion {
		char *str = (char *) malloc (sizeof(char));
		strcpy(str, $1);
		strcat(str, " ");
		strcat(str, $2);
		strcat(str, " ");
		strcat(str, $3);
		$$ = str;
	}
	| BoolExpression {
		$$ = $1;
	}
	;
	
BoolExpression:
	NumberOrIdentifier LogicalComparer NumberOrIdentifier {
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
		char *buffer = (char*) malloc(sizeof(char));
		sprintf(buffer,"while  %s:", $2);
		printCode(buffer, second_parse);
		scope++;
		insertVariable(table, "function", "while", NULL, NULL, scope);
		printComment("#\tEssa estrutura de repeticao funciona semelhante ao if. \n", second_parse, allow_comments);
	}
	| END_WHILE {
		deleteTable(table, scope);
		scope--;
		printTable(table);
		printComment("#Observe a identaçao da proxima linha. \n", second_parse, allow_comments);
	}
	;
	
ForExpression:
	FOR IDENTIFIER FROM NumberOrIdentifier TO NumberOrIdentifier STEP NUMBER {
		
    char *buffer = (char*) malloc(sizeof(char));
		sprintf(buffer,"for %s in range(%s, %s, %s):", $2, $4, $6, $8);
		printCode(buffer, second_parse);
		scope++;
		insertVariable(table, "function", "for", NULL, NULL, scope);
		
    Symbol* variable = findName(table, $2);
    if(variable == NULL){
      insertVariable(table, "int", $2, $4, NULL, scope);
    }
    
    printComment("\t#O for usa uma variavel (pra receber os valores temporarios) \n", second_parse, allow_comments);
		indent(scope, second_parse);
		printComment("\t#E também chama a funcao range, que recebe um valor inicial, um valor final e um passo. \n", second_parse, allow_comments);
	}
	| FOR IDENTIFIER FROM NumberOrIdentifier TO NumberOrIdentifier {
	  

    char *buffer = (char*) malloc(sizeof(char));
		sprintf(buffer,"for %s in range(%s, %s):", $2, $4, $6);
		printCode(buffer, second_parse);
		scope++;
		insertVariable(table, "function", "for", NULL, NULL, scope);
    
    Symbol* variable = findName(table, $2);
    if(variable == NULL){
      insertVariable(table, "int", $2, $4, NULL, scope);
    }
		
    printComment("\t#O terceiro parametro do range é opcional e igual a um por definicao . \n", second_parse, allow_comments);
	}
	| END_FOR {
		deleteTable(table, scope);
		scope--;
		printTable(table);
		printComment("#Observe a identaçao da proxima linha. \n", second_parse, allow_comments);
	}
	;

NumberOrIdentifier:
	IDENTIFIER {
		if(is_variable_initialized(table, $1)) {
				$$ = $1;
		} else {
			has_error = 1;
		}
  }
	| NUMBER {
		$$ = $1;
	}
	;

AttribuitionExpression:
	IDENTIFIER RECEIVES AttribuitionValue {
		setVariable(table, $1, $3);
		char *buffer = (char*) malloc(sizeof(char));
		sprintf(buffer,"%s = %s", $1, $3);
		printCode(buffer, second_parse);
		printComment("\t #Sua variavel sempre é declarada quando voce atribui um valor a ela.\n", second_parse, allow_comments);
	}
	;

AttribuitionValue:
	NUMBER {
		$$ = $1;
	}
	| STRING_VALUE {
		$$ = $1;
	}
	| MathExpression {
		$$ = $1;
	}
	;

DeclarationExpression:
	Type IDENTIFIER {
		insertVariable(table, $1, $2, NULL, NULL, scope);
		strcat(argumentList, $1);
		strcat(argumentList, " ");
		$$ = $2;
		printComment("#Observe que a sua variavel nao foi declarada aqui no seu codigo Python.\n", second_parse, allow_comments);
		indent(scope, second_parse);
		printComment("#Fique calmo. O Python não trabalha com declaracao de variaveis,\n", second_parse, allow_comments);
		indent(scope, second_parse);
		printComment("#voce simplesmente usa uma variavel quando achar necessario.\n", second_parse, allow_comments);
	}
	| Type IDENTIFIER RECEIVES AttribuitionValue {
		insertVariable(table, $1, $2, $4, NULL, scope);	
		char *buffer = (char*) malloc(sizeof(char));
		sprintf(buffer,"%s = %s", $2, $4);
		printCode(buffer, second_parse);

		strcat(argumentList, $1);
		strcat(argumentList, " ");

		printComment("\t#Observe que a sua variavel nao possui o tipo declarado, como int ou float\n", second_parse, allow_comments);
		indent(scope, second_parse);
		printComment("#Relaxe. O Python que reconhece o tipo da variavel automaticamente\n", second_parse, allow_comments);
		indent(scope, second_parse);
		printComment("#Isso significa que ela tem um tipo, mas que pode ser mudado com um uso diferente da variavel.\n", second_parse, allow_comments);
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
		strcat(str, $2);
		strcat(str, ")");
		$$ = str;
	}
	;

MathParam:
	IDENTIFIER {
    if (is_a_number(table, $1)) {
      $$ = $1;
    } else {
      has_error = 1;			
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
	has_error = 1;
	printf("Error: %s Line %d\n", s, lineNumber);
}

int main(int argc, char* argv[]) {
	int i;
	for(i = 0; i < argc; i++){
		if(strcmp(argv[i], "-debug") == 0 && debugOption == 0){ 
			debugOption = 1;
		}

		if(strcmp(argv[i], "-comment") == 0 && allow_comments == 0){ 
			allow_comments = 1;
		}
	}
	table = calloc(1, sizeof(Table));
	functionsTable = calloc(1, sizeof(Table));
	

	yyparse();	

	if (table->head != NULL){
		printTable(table);
		printf("Error: Linha: %d, comando \"fim\" esperado. \n", lineNumber);
		has_error = 1;
		deleteTable(table, 0);
		printTable(table);
	}
	else{
		printTable(table);
	}
	
	if (has_error == 0) {
		second_parse = 1;
		fseek(stdin, 0, SEEK_SET);
		yyparse();
	} 

	exit(EXIT_SUCCESS); 
}

