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

Table* createTable();
Symbol* createSymbol ();
Symbol* initializeSymbol(Symbol* prev, char* type, char* name, 
	char* value, char* returnedValue, int scope);
Table* initializeTable(Symbol* head);
void addSymbolToTable(Table* table, Symbol* symbol);
void deleteSymbol(Symbol* symbol);
void deleteTable(Table* table);
Symbol* findName (const Table* table, char* name);
void printTable(const Table *table);


#endif

