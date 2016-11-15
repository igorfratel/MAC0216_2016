#include "stable.h"
#include "error.h" 
#include <stdio.h>
#include <string.h>
#define MAX 1024

typedef struct {
  char *entryKey;
  EntryData data;
} Entry;

struct stable_s {
  Entry *tab;
  int k;
  int max;
};

int maxWord = 0;

void Realloc(SymbolTable table)
{
  int maxnovo = table->max * 2;
  SymbolTable w = emalloc(sizeof(struct stable_s));
  w->tab = emalloc(maxnovo*sizeof(Entry));
  w->k = table->k;
  for (int i = 0; i < table->max; i++) w->tab[i] = table->tab[i];
  free(table->tab);
  table->tab = w->tab;
  table->k = w->k;
  table->max = maxnovo;
}

EntryData *ordena(SymbolTable table, const char *key)
{ /*Organiza a tabela na ordem lexicográfica com o novo key.*/
  EntryData *data;
  char aux[maxWord];
  int faux;
  int j = table->k;
  while (j > 0 && (strcmp(key, table->tab[j-1].entryKey) < 0)) {
    strcpy(aux, table->tab[j-1].entryKey);
    faux = table->tab[j-1].data.i;
    strcpy(table->tab[j-1].entryKey, key);
    data = &(table->tab[j-1].data);
    strcpy(table->tab[j].entryKey, aux);
    table->tab[j].data.i = faux;
    j--;
  }
  table->k++;
  return data;
}

SymbolTable stable_create()
{
  SymbolTable st = emalloc(sizeof(struct stable_s));
  st->tab = emalloc(MAX*(sizeof(Entry))); 
  st->k = 0;
  st->max = MAX;
  return st;
}

void stable_destroy(SymbolTable table)
{
  free(table->tab); 
  free(table);
}

InsertionResult stable_insert(SymbolTable table, const char *key)
{ /*Coloca a key na table em ordem lexicográfica.*/
  InsertionResult result;
  int tam;
  for(int i = 0; i < table->k; i++) //Verifica se já existe a chave.
    if(!strcmp(table->tab[i].entryKey, key)){
      result.new = 0;
      result.data = &(table->tab[i].data); 
      return result;
    }
  if(table->k == table->max) Realloc(table);
  result.new = 1; //Chave nova.
  result.data = &(table->tab[table->k].data);
  for (tam = 0; key[tam] != 0; tam++);
  if (tam > maxWord) maxWord = tam;
  table->tab[table->k].entryKey = emalloc(maxWord);
  if (table->k == 0) {
    strcpy(table->tab[table->k++].entryKey, key);
    return result;
  }
  // A chave é a última na ordem lexicográfica, portanto coloca no final.
  if (strcmp(key, table->tab[table->k-1].entryKey) >= 0) {
    strcpy(table->tab[table->k].entryKey, key);
    table->tab[table->k++].data.i = 1;
    return result;
  }
  // A chave ficará fora de ordem na ordem lexicográfica se colocada no final.
  result.data = ordena(table, key);
  return result;
}

EntryData *stable_find(SymbolTable table, const char *key)
{
  for(int i = 0; i < table->k; i++) 
    if(table->tab[i].entryKey == key) return &(table->tab[i].data);
  return NULL;
}

int stable_visit(SymbolTable table,
                 int (*visit)(const char *key, EntryData *data))
{
  for(int i = 0; i < table->k; i++)
    if (!visit(table->tab[i].entryKey, &(table->tab[i].data) ))
      return 0;
  return 1;
}