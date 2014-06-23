#include "code.h" 

void indent(int scope, int secondParse){
	int i;
	for(i = 0; i < scope; i++){
		printCode("\t", secondParse);
	}
}

void printCode(char* code, int second_parse) {
	if (second_parse) {
		printf("%s", code);	
	}
}

void printComment(char* comment, int second_parse, int allow_comments){
	if(allow_comments && second_parse){
		printf("%s", comment);
	}
}
