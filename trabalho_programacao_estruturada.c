//gcc trabalho_mauricio.c -o mauricio
#include <stdio.h>
#include <termios.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#define NCOL 80
#define NLIN 20
#define NOPTM 6
#define NCOLM 30

static struct termios old, new;

/**
* Função desenvolvida para criar o MENU  e gerenciar as opções.
*/
void adicionarTextoAoMenu();

/**
* Função para utilização do leitor de teclas.
*/
void initTermios(int echo);

/**
* Função para utilização do leitor de teclas.
*/
void resetTermios(void);

/**
* Função para utilização do leitor de teclas.
*/
char getch_(int echo);

/**
* Função para utilização do leitor de teclas.
*/
char getch(void);

/**
* Função para utilização do leitor de teclas.
*/
char getche(void);

/**
* Função para definir as coordenadas x e y para efetuar a impressão na tela.
*/
void gotoxy(int x, int y);

/**
* Função para limpar o terminal.
*/
void limparTerminal();

/**
* Função para criar a moldura utilizada no programa.
*/
void criarMolduraTela();

/**
* Função para alterar os dados de um determinado registro.
*/
void alterarProduto();

/**
* Função para remover um determinado registro.
*/
void removerProduto();

/**
* Função para consultar um determinado produto.
*/
void consultarProduto();

/**
* Função para consultar o valor total de venda utilizando como base a quantidade total em estoque.
*/
void consultarValorTotal();

/**
* Estrutura de dados de um produto.
*/
struct produto {
	int codigoProduto;
	char nomeProduto[30];
	int quantidadeDisponivelEstoque;
	double valorUnitCompra;
	double valorUnitVenda;
};

char nomeArquivoDados[100];

/**
* Função principal.
*/
int main()
{
	limparTerminal();
	criarMolduraTela();
	gotoxy(3, 4);
	printf("Informe o nome do arquivo: ");
	scanf("%s", nomeArquivoDados);
	getch();

	limparTerminal();
	criarMolduraTela();	
	adicionarTextoAoMenu();
	gotoxy (0, NLIN + 3);
	printf("");
	return 0;
}

void initTermios(int echo) {
	tcgetattr(0, &old);
	new = old;
	new.c_lflag &= ~ICANON;
	new.c_lflag &= echo ? ECHO : ~ECHO;
	tcsetattr(0, TCSANOW, &new);
}

void resetTermios(void) {
	tcsetattr(0, TCSANOW, &old);
}

char getch_(int echo) {
	char ch;
	initTermios(echo);
	ch = getchar();
	resetTermios();
	return ch;
}

char getch(void) {
	return getch_(0);
}

char getche(void) {
	return getch_(1);
}

void gotoxy(int x,int y)
{
	printf("%c[%d;%df",0x1B,y,x);
}

void limparTerminal() {
	#ifdef WINDOWS
	system("cls");
	#else
	system ("clear");
	#endif
}

void criarMolduraTela() {
	int i, j;
	for (j = 0; j < NLIN; j++) {
		for (i = 0; i < NCOL; i++) {
			printf((j > 0 && j < NLIN - 1) ? ((i == 0) || (i == NCOL - 1) ? "#" : " ") : "#");
		}
		printf("\n");
	}
}

void removerProduto() {
	limparTerminal();
	criarMolduraTela();

	struct produto p;

	gotoxy(3, 4);
	printf("Informe o codigo do produto: ");
	scanf("%d", &p.codigoProduto);

	FILE *ponteiroArquivo;
	ponteiroArquivo = fopen(nomeArquivoDados, "a+b");

	if (ponteiroArquivo == NULL) {
		gotoxy(1, NLIN+1);
		printf("Ocorreu um erro ao abrir o arquivo.");
	}

	int linha = 0;
	int existeProduto = 0;
	int podeRemover = 0;

	while ( !feof(ponteiroArquivo)) {
		char c[100];
		fscanf(ponteiroArquivo,"%s", c);
		char *token = strtok(c, ";");

		int codigo = atoi (token);

		if (codigo == p.codigoProduto) {
			int col = 0;
			while (token) {
				if (col == 2) {
					int q = atoi (token);
					
					if (q == 0) {
						podeRemover = 1;
						existeProduto = 1;
						break;
					}
				}

				token = strtok(NULL, ";");
				col++;
			}

			existeProduto = 1;
			break;
		}

		linha++;
	}

	fclose(ponteiroArquivo);

	if (existeProduto == 0) {
		gotoxy(3, 5);
		printf("O produto informado nao foi encontrado.\n");
	} else {
		if (podeRemover == 0) {
			gotoxy(3, 5);
			printf("Nao e possivel remover este produto pois ainda possui estoque.\n");
		} else {
			
			char linhaDados[1000];
			FILE *arquivoOriginal, *novoArquivo;
			arquivoOriginal = fopen(nomeArquivoDados, "r");
			novoArquivo = fopen("/tmp/novo.dat", "w");
			int i = 0;
			while (fgets(linhaDados, sizeof linhaDados, arquivoOriginal)) {
				if (i != linha) {
					fprintf(novoArquivo, "%s", linhaDados);
				}
				i++;
			}
			fclose(novoArquivo);
			fclose(arquivoOriginal);
			unlink(nomeArquivoDados);
			rename("/tmp/novo.dat", nomeArquivoDados);

			gotoxy(3, 7);
			printf("Sucesso ao remover o registro.");
		}
	}

	gotoxy(3, 9);
	printf("Pressione qualquer tecla para voltar");

	getch();
	getch();

	limparTerminal();
	criarMolduraTela();
	adicionarTextoAoMenu();
}

void consultarProduto() {
	limparTerminal();
	criarMolduraTela();

	struct produto p;

	gotoxy(3, 4);
	printf("Informe o codigo do produto: ");
	scanf("%d", &p.codigoProduto);

	FILE *ponteiroArquivo;
	ponteiroArquivo = fopen(nomeArquivoDados, "a+b");

	if (ponteiroArquivo == NULL) {
		gotoxy(1, NLIN+1);
		printf("Ocorreu um erro ao abrir o arquivo.");
	}

	double total = 0;

	int linha = 6;
	int temProduto = 0;

	while ( !feof(ponteiroArquivo)) {
		char c[100];
		fscanf(ponteiroArquivo,"%s", c);
		char *token = strtok(c, ";");

		int i = 0;
		int codigo = 0;
		char label[50];
		while (token) {
			if (i == 0) {
				codigo = atoi (token);
			}

			if (codigo == p.codigoProduto) {
				temProduto = 1;

				gotoxy(3, linha++);

				if (i == 0) {
					printf("Codigo.......................: %s\n", token);
				} else if (i == 1) {
					printf("Nome.........................: %s\n", token);
				} else if (i == 2) {
					printf("Qtd Estoque..................: %s\n", token);
				} else if (i == 3) {
					printf("Valor Compra.................: %s\n", token);
				} else if (i == 4) {
					printf("Valor Venda..................: %s\n", token);
				}
			}

			token = strtok(NULL, ";");

			i++;
		}

	}

	if (temProduto == 0) {
		gotoxy(3, linha);
		printf("O produto informado nao foi encontrado.");
	}

	fclose(ponteiroArquivo);

	gotoxy(3, linha+2);
	printf("Pressione qualquer tecla para voltar");
	getch();
	getch();

	limparTerminal();
	criarMolduraTela();
	adicionarTextoAoMenu();
}

void consultarValorTotal() {
	FILE *ponteiroArquivo;
	ponteiroArquivo = fopen(nomeArquivoDados, "a+b");

	if (ponteiroArquivo == NULL) {
		gotoxy(1, NLIN+1);
		printf("Ocorreu um erro ao abrir o arquivo.");
	}

	double total = 0;

	while ( !feof(ponteiroArquivo)) {
		char c[100];
		fscanf(ponteiroArquivo,"%s", c);
		char *token = strtok(c, ";");
		int i = 0;
		int quantidade = 0;
		double valor;
		while (token) {
			if (i == 2) {
				quantidade = atoi (token);
			}

			if (i == 4) {
				valor = atof (token);
			}

			token = strtok (NULL, ";");
			i++;
		}

		total += (quantidade * valor);
	} 

	fclose(ponteiroArquivo);

	limparTerminal();
	criarMolduraTela();
	gotoxy(1, NLIN+1);
	printf("Valor Total dos Produtos: %.2f", total);
	adicionarTextoAoMenu();
}

void alterarProduto() {
	limparTerminal();
	criarMolduraTela();

	struct produto p;

	gotoxy(3, 4);
	printf("Informe o codigo do produto: ");
	scanf("%d", &p.codigoProduto);

	FILE *ponteiroArquivo;
	ponteiroArquivo = fopen(nomeArquivoDados, "a+b");

	if (ponteiroArquivo == NULL) {
		gotoxy(1, NLIN+1);
		printf("Ocorreu um erro ao abrir o arquivo.");
	}

	int linha = 0;
	int existeProduto = 0;

	while ( !feof(ponteiroArquivo)) {
		char c[100];
		fscanf(ponteiroArquivo,"%s", c);
		char *token = strtok(c, ";");
		int codigo = atoi (token);

		if (codigo == p.codigoProduto) {
			existeProduto = 1;
			break;
		}

		linha++;
	}

	fclose(ponteiroArquivo);

	if (existeProduto == 0) {
		gotoxy(3, 5);
		printf("O produto informado nao foi encontrado.");
	} else {

		gotoxy(3, 5);
		printf("Informe o nome do produto: ");
		scanf("%s", &p.nomeProduto);
		gotoxy(3, 6);
		printf("Informe a quantidade em estoque: ");
		scanf("%d", &p.quantidadeDisponivelEstoque);
		gotoxy(3, 7);
		printf("Informe o valor unitario de compra: ");
		scanf("%lf", &p.valorUnitCompra);
		gotoxy(3, 8);
		printf("Informe o valor unitario de venda: ");
		scanf("%lf", &p.valorUnitVenda);

		char linhaDados[1000];
		FILE *arquivoOriginal, *novoArquivo;
		arquivoOriginal = fopen(nomeArquivoDados, "r");
		novoArquivo = fopen("/tmp/novo.dat", "w");
		int i = 0;
		while (fgets(linhaDados, sizeof linhaDados, arquivoOriginal)) {
			if (i != linha) {
				fprintf(novoArquivo, "%s", linhaDados);
			} else {
				fprintf(novoArquivo, 
					"%d;%s;%d;%.2f;%.2f\n", 
					p.codigoProduto, 
					p.nomeProduto, 
					p.quantidadeDisponivelEstoque, 
					p.valorUnitCompra, 
					p.valorUnitVenda);
			}
			i++;
		}

		fclose(novoArquivo);
		fclose(arquivoOriginal);
		unlink(nomeArquivoDados);
		rename("/tmp/novo.dat", nomeArquivoDados);

		gotoxy(3, 9);
		printf("Sucesso ao alterar o registro.");
	}

	gotoxy(3, 11);
	printf("Pressione qualquer tecla para voltar");
	getch();
	getch();

	limparTerminal();
	criarMolduraTela();
	adicionarTextoAoMenu();
}

void inserirProduto() {
	gotoxy(1,1);
	limparTerminal();
	criarMolduraTela();	

	struct produto p;

	gotoxy(3, 4);
	printf("Informe o codigo do produto: ");
	scanf("%d", &p.codigoProduto);
	gotoxy(3, 5);
	printf("Informe o nome do produto: ");
	scanf("%s", &p.nomeProduto);
	gotoxy(3, 6);
	printf("Informe a quantidade em estoque: ");
	scanf("%d", &p.quantidadeDisponivelEstoque);
	gotoxy(3, 7);
	printf("Informe o valor unitario de compra: ");
	scanf("%lf", &p.valorUnitCompra);
	gotoxy(3, 8);
	printf("Informe o valor unitario de venda: ");
	scanf("%lf", &p.valorUnitVenda);


	FILE *ponteiroArquivo;
	ponteiroArquivo = fopen(nomeArquivoDados, "a+b");

	if (ponteiroArquivo == NULL) {
		gotoxy(3, 10);
		printf("Ocorreu um erro ao abrir o arquivo.");
	}

	int podeRegistrar = 1;

	while ( !feof(ponteiroArquivo) && podeRegistrar == 1) {
		if (podeRegistrar == 1) {
			char c[100];
			fscanf(ponteiroArquivo,"%s", c);
			char *token = strtok(c, ";");
			int codigoAux = atoi (token);
			podeRegistrar = (atoi (token)) == p.codigoProduto ? 0 : 1;
		}
	} 

	if (podeRegistrar == 1) {
		fprintf(ponteiroArquivo, 
			"%d;%s;%d;%.2f;%.2f\n", 
			p.codigoProduto, 
			p.nomeProduto, 
			p.quantidadeDisponivelEstoque, 
			p.valorUnitCompra, 
			p.valorUnitVenda);
	}

	fclose(ponteiroArquivo);

	limparTerminal();
	criarMolduraTela();
	getch();
	gotoxy(1, NLIN+1);
	printf(podeRegistrar == 1 ? "Sucesso ao efetuar o registro." : "O codigo do produto informado ja esta registrado.");
	adicionarTextoAoMenu();
}

void adicionarTextoAoMenu() {
	int linhaCentral = floor (NLIN / 2);
	linhaCentral = NLIN % 2 != 0 ? linhaCentral : (linhaCentral - 1);
	linhaCentral = NOPTM > 0 ? linhaCentral - NOPTM : linhaCentral;

	int colunaCentral = floor (NCOL / 2);
	colunaCentral = NCOL % 2 == 0 ? colunaCentral : (colunaCentral - 1);
	colunaCentral = (NCOLM / 2) > 0 ? colunaCentral - (NCOLM / 2) : colunaCentral;

	int posCursor = linhaCentral;

	gotoxy (colunaCentral, linhaCentral++);
	printf("[*][   INSERIR PRODUTO       ]");
	gotoxy (colunaCentral, linhaCentral++);
	printf("[ ][   CONSULTAR PRODUTO     ]");
	gotoxy (colunaCentral, linhaCentral++);
	printf("[ ][   EXCLUIR PRODUTO       ]");
	gotoxy (colunaCentral, linhaCentral++);
	printf("[ ][   ALTERAR PRODUTO       ]");
	gotoxy (colunaCentral, linhaCentral++);
	printf("[ ][   CONSULTA VALOR TOTAL  ]");
	gotoxy (colunaCentral, linhaCentral++);
	printf("[ ][   SAIR DO PROGRAMA      ]");

	int posCursorLimpar = 0;
	int linhaInicial = 3;
	int linhaFinal = 8;
	int colunaCentralCursor = colunaCentral + 1;
	int x = 0;
	int y = 0;
	int z = 0;

	gotoxy(colunaCentralCursor, posCursor);

	while(x != 10){
		x = getch();

		if (x == 27) {
			y = getch();
			z = getch();
			if (x == 27 && y == 91) {
				if (z == 65) {
					if (posCursor > linhaInicial) {
						posCursor--;
					}
					posCursorLimpar = posCursor + 1;
				} else if (z == 66) {
					if (posCursor < linhaFinal) {
						posCursor++;
					}
					posCursorLimpar = posCursor - 1;
				} 
				gotoxy(colunaCentralCursor, posCursorLimpar);
				printf(" ");
				gotoxy(colunaCentralCursor, posCursor);
				printf("*");
			}
		}
	}

	if (x == 10) {
		if (posCursor == 3) {
			inserirProduto();
		} else if (posCursor == 4) {
			consultarProduto();
		} else if (posCursor == 5) {
			removerProduto();
		} else if (posCursor == 6) {
			alterarProduto();
		} else if (posCursor == 7) {
			consultarValorTotal();
		} else if (posCursor == 8) {
		}
	}
}