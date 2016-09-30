#include "stable.h"
#include "error.h"
#include <stdio.h>
#include <string.h>
#define MAX 1024
int imprime(const char *key, EntryData *data)
{
  printf("%s %s\n", key, data->str);
  return 1;
}

int main()
{
  char *key;
  InsertionResult tmp;
  EntryData birl;
  SymbolTable table = stable_create();
  key = emalloc(MAX*sizeof(char));
  printf("chave: ");
  scanf("%s", key);
  tmp = stable_insert(table, key);
  while(tmp.new == 0){
    printf("Nao vai dar nao");
    scanf("%s", key);
    tmp = stable_insert(table, key);
    if(tmp.new == 1) break; 
  }
  printf("da a entrada, porra: ");
  (*(tmp.data)).str = emalloc(MAX*(sizeof(char)));
  scanf("%s",(*(tmp.data)).str);
  stable_visit(table, &imprime);
  return 0;
}
