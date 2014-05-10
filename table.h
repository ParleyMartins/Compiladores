#ifndef TABLE_H
#define TABLE_H

typedef struct symbol {
	char* type;
	char* name;
	char* value;
	char* returnedValue;
	int scope;
	struct symbol* prev;
} Symbol;

typedef struct table {

	Symbol* head;
	Symbol* tail;
} Table;

Table* createTable(Symbol* head);
Symbol* createSymbol(Symbol* prev, char* type, char* name, 
	char* value, char* returnedValue, int scope);

void insertSymbol(Table* table, Symbol* symbol);

void deleteSymbol(Symbol* symbol);
void deleteTable(Table* table);

Symbol* findName (const Table* table, const char* name);

void printTable(const Table *table);

int insertVariable(Table* table, char* type, char* name, 
		char* value, char* returnedValue, int scope);

void printSymbol(const Symbol* current, int position);

int setVariable(const Table* table, const char* name, char* value);
// void checkError(int code, char* identifier);

#endif
