#ifndef ERRORS_H
#define ERRORS_H

#include <stdio.h>
#include "table.h"

int is_variable_declared(const Table* table, const char* variable_name);
int is_variable_initialized(const Table* table, const char* variable_name);
int is_a_number(const Table* table, const char* variable_name);

#endif
