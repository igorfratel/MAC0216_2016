/*
  buffer.c

  A character buffer.
*/

#include "buffer.h"
#include "error.h"

#define MAX 1024

Buffer *buffer_create()
{ /**/
	Buffer *B = emalloc(sizeof(Buffer));
  B->data = emalloc(MAX*sizeof(char));
	B->i = 0;
	B->n = 0;
	return B;
}

void buffer_destroy(Buffer *B)
{ /**/
  free(B);
}

void buffer_reset(Buffer *B)
{ /**/
  B->n = B->i = 0;
}

void buffer_push_back(Buffer *B, char c)
{ /**/
  B->data[B->i++] = c;
  B->n++;
}

int read_line(FILE *input, Buffer *B)
{ /**/
  buffer_reset(B);

  int i = 0;
  char c = fgetc(input);
  
  if (c == EOF) return 0;
  
  while(c != '\n' && c != EOF){
    B->data[i++] = c;
    c = fgetc(input);
  }

  if (c == '\n') B->data[i++] = c;
  return i;
}