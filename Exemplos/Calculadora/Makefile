prog: lexic.l sintatic.y
	bison -d sintatic.y
	mv sintatic.tab.h sintatic.h
	mv sintatic.tab.c sintatic.c
	flex lexic.l
	mv lex.yy.c lexic.c
	gcc -o prog sintatic.c lexic.c -lfl

clean:
	rm lexic.* sintatic.* calc.exe
