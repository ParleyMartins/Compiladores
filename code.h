#ifndef CODE_H
#define CODE_H

#include <stdio.h>

void indent(int scope, int secondParse);
void printCode(char* code, int secondParse);
void printComment(char* comment, int secondParse, int allowComments);

#endif
