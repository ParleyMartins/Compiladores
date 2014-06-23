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
	int debugOption;
} Table;

Table* createTable(Symbol* head, int debugOption);
Symbol* createSymbol(Symbol* prev, char* type, char* name, 
	char* value, char* returnedValue, int scope);

void insertSymbol(Table* table, Symbol* symbol);
void insertVariable(Table* table, char* type, char* name, 
		char* value, char* returnedValue, int scope);

void deleteSymbol(Symbol* symbol);
void deleteTable(Table* table, int scope);

Symbol* findName (const Table* table, const char* name);

void printTable(const Table *table);
void printSymbol(const Symbol* current, int position);
void debugMessages(const Table* table, const char* message);

int setVariable(const Table* table, const char* name, char* value);


#endif
