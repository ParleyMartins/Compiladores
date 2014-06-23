Compilador Portugol -> Python

I - Utilizando o compilador:

	1) Gere um arquivo portugol de entrada (qualquer extensao desejada, seguindo o padrao na sessao III)
	2) Abra um terminal linux
	3) Chame o compilador com uma das seguintes sintaxes:
		./script [entrada]
		./script [entrada] [saida]
		./script [entrada] [saida] [-flags desejadas]
		./script (Nesse caso, seu arquivo de entrada deve ter obrigatoriamente o nome 'entrada')
	4) Se o seu codigo compilou sem erros, rode o arquivo python (se desejar) utilizando o comando:
		python [nome do arquivo de saida]


II - Flags
Flags são um palavras que vao te auxiliar em alguma funcionalidade. Temos as seguintes:
	1) -comment
		Essa flag foi feita para os iniciantes em Python. Mesmo quem ja tem experiencia com outras linguagens deveria utilizar essa flag uma vez.
		Ela ativa os comentários das principais funcoes do Python e algumas diferencas entre outras linguagens. Esses comentarios sao feitos no 
		seu codigo python, gerado pelo compilador.

	2) -debug
		Essa flag é para ajudar a entender o erro que esta acontecendo nas suas funcoes ou no comportamento do compilador. Se você nao possui muita
		experiencia com programacao, não é muito aconselhado utilizar essa flag, pois ela demonstra o funcionamento interno do compilador, para a 
		depuracao de erros.


III - Sintaxe adotada do portugol
O Portugol possui varios 'tipos' de sintaxe (por nao se tratar de uma linguagem de programacao propriamente dita). Esse compilador irá aceitar a seguinte:
	1) tipos de variaveis:
		inteiro, real, caractere, texto
	2) estrutura de controle:
		se (condicao) entao
		...
		fim_se

		se (condicao) entao
		...
		senao
		...
		fim_se
	3) repetição
		enquanto (condicao)
		...
		fim_enquanto
		
		para [variavel] de [valor inicial] ate [valor final] passo [valor do incremento]
		...
		fim_para

	4) funcoes
		funcao [nome da funcao]
		...
		fim_funcao

	5) leitura e impressao
		escreva [variaval ou string]
		leia [nome da variavel no qual o que vai ser lido deve ser armazenado]

	6) algoritmo
		inicio
		...
		fim
	
	7) Atribuiçoes e operaçoes especiais
		<= 	menor ou igual
		>= 	maior ou igual
		=/= 	diferente	
		= 	igual
		<-	simbolo de atribuicao
		'e'	operador logico
		'ou'	operador logico
