#include "table.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

Table* createTable(){
	return (Table *) calloc(1, sizeof(Table));
}

Symbol* createSymbol (){
	return (Symbol *) calloc(1, sizeof(Symbol));
}

Symbol* initializeSymbol(Symbol* prev, 
		char* type, char* name,
		char* value, char* returnedValue, int scope){
	
	Symbol* current = createSymbol();
	current->type = type;
	current->name = name;
	current->value = value;
	current->returnedValue = returnedValue;
	current->scope = scope;
	current->prev = prev;

	return current;
}

Table* initializeTable(Symbol* head){
	Table* table = createTable();
	table->head = head;
	table->tail = head;

	return table;
}

void addSymbolToTable(Table* table, Symbol* symbol){
	if(table == NULL || symbol == NULL){
		return;
	}
	if(table->tail == NULL){
		table->tail = symbol;
		return;
	}
	symbol->prev = table->tail;
	table->tail = symbol;
}

void deleteSymbol(Symbol* symbol){
	free(symbol->name);
	free(symbol->value);
	free(symbol->returnedValue);
	free(symbol);

}
void deleteTable(Table* table){

	if(!table){
		return;
	}

	Symbol* current;
	Symbol* temp = table->tail;
	for(current = table->tail; current; current = temp->prev){
		deleteSymbol(current);
		temp = temp->prev;
	}
	free(table->head);
	free(table->tail);
	free(temp);
	free(table);
}

Symbol* findName (const Table* table, char* name){
	if(!table){
		return NULL;
	}

	if(strcmp(name, "") == 0){
		return NULL;
	}

	Symbol* current;
	for(current = table->tail; current; current = current->prev){
		if(strcmp(current->name, name) == 0){
			return current;
		}
	}
	return current;
}

void 
printTable(const Table *table)
{
	Symbol *prev;
	int i;
	
	if (table == NULL)
		return;
	
	for (prev = table->tail, i = 0; prev; prev = prev->prev, i++)
	{
		printf("No %d (%p):\ninfo = %s\n\
			%s\n\
			%s\n\
			%d\n\
			%s\n\
			prev " "= %p\n\n", i, (void *) prev, 
				prev->type,
				prev->name,
				prev->returnedValue,
				prev->scope,
				prev->value, (void *) prev->prev);
	}
}