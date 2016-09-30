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
};

SymbolTable stable_create()
{
  SymbolTable st = emalloc(sizeof(struct stable_s));
  st->tab = emalloc(MAX*(sizeof(Entry))); 
  st->k = 0;
  return st;
}

void stable_destroy(SymbolTable table)
{
  free(table->tab); 
  free(table);
}

InsertionResult stable_insert(SymbolTable table, const char *key)
{
  InsertionResult result;
  for(int i = 0; i < table->k; i++)
    if(table->tab[i].entryKey == key){
      result.new = 0;
      result.data = &(table->tab[i].data); 
      return result;
    }
  result.new = 1;
  result.data = &(table->tab[table->k].data);
  table->tab[table->k].entryKey = emalloc(MAX);
  strcpy(table->tab[table->k++].entryKey, key); //erro aqui
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
  int tmp;
  for(int i = 0; i < table->k; i++)
    if ((tmp = visit(table->tab[i].entryKey, &(table->tab[i].data))) == 0) return 0;
  return 1;
}


