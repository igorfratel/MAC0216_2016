#include "buffer.h"
#include "error.h"

#define MAX 1024

void Realloc(Buffer *B) {
  int maxnovo = B->n * 2;
  Buffer *w = emalloc(sizeof(Buffer));
  w->data = emalloc(maxnovo*sizeof(char));
  w->i = B->i;
  for (int i = 0; i < B->n; i++) w->data[i] = B->data[i];
  free(B->data);
  B->data = w->data;
  B->i = w->i;
  B->n = maxnovo;
}

Buffer *buffer_create()
{
  Buffer *B = emalloc(sizeof(Buffer));
  B->data = emalloc(MAX*sizeof(char));
  B->i = 0;
  B->n = MAX;
  return B;
}

void buffer_destroy(Buffer *B)
{
  free(B);
}

void buffer_reset(Buffer *B)
{
  for (int i = 0; i < B->n; i++)
    B->data[i] = 0;
  B->i = 0;
}

void buffer_push_back(Buffer *B, char c)
{
  if (B->i == B->n) Realloc(B);
  B->data[B->i++] = c;
}

int read_line(FILE *input, Buffer *B)
{
  buffer_reset(B);
  char c = fgetc(input);
  if (c == EOF) return 0;
  while(c != EOF) {
    buffer_push_back(B, c);
    if (c == '\n') return B->i;
    c = fgetc(input);
  }
  return B->i;
}