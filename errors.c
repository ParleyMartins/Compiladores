#include "errors.h"

// Will return 0 if the variable exists, and 1 if not
int is_variable_declared(const Table* table, const char* variable_name) {
	int return_value;
	Symbol* variable = findName(table, variable_name);

	if (variable != NULL) {
		return_value = 0;				
	} else {
		printf("Error: Variavel %s nao declarada\n", variable_name);
		return_value = 1;
	}

	return return_value;
}

// Will return 0 if the variable is initialized, and 1 if not
int is_variable_initialized(const Table* table, const char* variable_name) {
	int return_value;
	Symbol* variable = findName(table, variable_name);

	if (variable->value != NULL) {
		return_value = 0;				
	} else {
		printf("Error: Variavel %s precisa ser inicializada\n", variable_name);
		return_value = 1;
	}

	return return_value;
}

// Will return 0 if the variable is a number, and 1 if not
int is_a_number(const Table* table, const char* variable_name) {
	int return_value;
	Symbol* variable = findName(table, variable_name);

	if (strcmp(variable->type,"int") == 0 || strcmp(variable->type,"float") == 0) {
		return_value = 0;				
	} else {
		printf("Error: A variavel %s nao possui valor numerico\n", variable_name);
		return_value = 1;
	}

	return return_value;
}
