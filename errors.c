#include "errors.h"

// This will return 1 if the variable exists, and 0 otherwise
int is_variable_declared(const Table* table, const char* variable_name) {
	int return_value;
	Symbol* variable = findName(table, variable_name);

	if (variable != NULL) {
		return_value = 1;				
	} else {
		printf("Error: Variavel %s nao declarada\n", variable_name);
		return_value = 0;
	}

	return return_value;
}

// This will return 1 if the variable is initialized, and 0 otherwise
int is_variable_initialized(const Table* table, const char* variable_name) {
	int return_value;
	Symbol* variable = findName(table, variable_name);

  int is_declared = is_variable_declared(table, variable_name);

  if(is_declared){
    if (variable->value != NULL) {
      return_value = 1;				
    } else {
      printf("Error: Variavel %s precisa ser inicializada\n", variable_name);
      return_value = 0;
    }
  } else {
    return_value = is_declared;
  }
	return return_value;
}

// This will return 1 if the variable is a number, and 0 otherwise
int is_a_number(const Table* table, const char* variable_name) {
	int return_value;
	Symbol* variable = findName(table, variable_name);

  int is_declared = is_variable_declared(table, variable_name);

  if(is_declared){
    if (strcmp(variable->type,"int") == 0 || strcmp(variable->type,"float") == 0) {
      return_value = 1;				
    } else {
      printf("Error: A variavel %s nao possui valor numerico\n", variable_name);
      return_value = 0;
    }
  } else { 
    return_value = is_declared;
  } 
	return return_value;
}


int function_is_declared(const Table* functions_table, const char* function_name){
    
	int return_value;
	Symbol* function = findName(functions_table, function_name);

	if (function != NULL) {
		return_value = 1;				
	} else {
		printf("Error: Funcao %s nao declarada\n", function_name);
		return_value = 0;
	}

	return return_value;
}
