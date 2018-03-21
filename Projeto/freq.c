#include "stable.h"
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#define MAX 1024

int m = 0;

int imprime(const char *key, EntryData *data)
{ /*Imprime a key e a data da tabela de símbolos com os devidos espaços entre 
  eles.*/
  static int i = 0;
  int espacos = m - strlen(key);
  printf("%s", key);
  for (; espacos > 0; espacos--) printf(" ");
  printf(" %d\n", data->i);
  return 1;
}

int maior(const char *key, EntryData *data)
{ /*Calcula o tamanho da maior key.*/
  int maux;
  if ((maux = strlen(key)) > m) m = maux;
  return 1;
}

int main(int argc, char *argv[])
{
  if (argc != 2) { //Confere o número de argumentos.
    fprintf(stderr, "Wrong number of arguments\n");
    return 0;
  }              
  FILE *entrada = fopen(argv[1], "r");
  SymbolTable tab;
  InsertionResult endereco;
  tab = stable_create();
  int i = 0;
  char c;
  char palavra[MAX];
  //Faz a leitura do arquivo palavra por palavra.
  while ((c = fgetc(entrada))!= EOF) {
    //Procura o primeiro caractere:
    while (isspace(c) && c != EOF) c = fgetc(entrada);    
    if (c == EOF) break;    
    //Primeiro caractere encontrado.
    palavra[i++] = c;
    //Armazena a palavra no vetor:
    while (!isspace(c = fgetc(entrada)) && c != EOF) palavra[i++] = c;
    palavra[i] = 0;
    endereco = stable_insert(tab, palavra);
    //Conta a frequência da palavra na tabela.
    if (endereco.new) endereco.data->i = 1;
    else endereco.data->i++;    
    if (c == EOF) break;
    i = 0;
  }
  //Procura a maior chave (palavra lida).
  stable_visit(tab, &maior);
  //Imprime a tabela.
  stable_visit(tab, &imprime);
  stable_destroy(tab);
  return 0;
}