CC = gcc
CFLAGS = -lfl -lm
BFLAGS = -v -d


all: prog

prog: sintatico.c lexico.c table.c
	$(CC) -o prog sintatico.c lexico.c table.c $(CFLAGS)

sintatico.c: sintatico.y table.c
	bison $(BFLAGS) sintatico.y
	mv sintatico.tab.h sintatico.h
	mv sintatico.tab.c sintatico.c

lexico.c: lexico.l sintatico.c
	flex lexico.l 
	mv lex.yy.c lexico.c


clean:
	rm sintatico.c sintatico.h sintatico.output
	rm lexico.c 
	rm prog saida
