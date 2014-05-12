#ifndef TABLE_H
#define TABLE_H

#define UNDECLARED_FUNCTION -1
#define VARIABLE_ALREADY_DECLARED -2
#define UNITIALIZED_SYMBOL -3
#define UNDECLARED_VARIABLE -4

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
	int debugOption;
} Table;

Table* createTable(Symbol* head, int debugOption);
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

void debugMessages(const Table* table, const char* message);
// void checkError(int code, char* identifier);

#endif
