#include "buffer.h"
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

int main(int argc, char *argv[])
{
  if (argc != 4) { //Confere o número de argumentos.
    fprintf(stderr, "Wrong number of arguments\n");
    return 0;
  }
  int rest, start, end, len, lenstr, spc, i, odd;
  int numln = 0, endln = 0, c = atoi(argv[3]);
  FILE *entrada = fopen(argv[1], "r");
  FILE *saida = fopen(argv[2], "w");
  Buffer *B = buffer_create();
  while (len = read_line(entrada, B)) {
    numln++;
    //start recebe começo da frase em si.
    for (start = 0; start < len && isspace(B->data[start]); start++);
    //Entra se o buffer começa com letra ou se só tem espaço no buffer com EOF.
    if (!start || (B->data[start-1] != '\n')) {
      if (B->data[B->i-1] == '\n') endln = 1;
      //end recebe final da frase em si.
      for (end = len - 1; end >= start && isspace(B->data[end]); end--);
      lenstr = end - start + 1;
      if (lenstr == 0) {
        B->data[start] = 0;
        fprintf(saida, B->data);
      }
      else if (lenstr >= c) {
        for (i = start; i <= end; fputc(B->data[i++], saida));
        fprintf(stderr, "center: %s: line %d: line too long\n", argv[1], numln);
      }
      else { //Tem frase pra ser centralizada.
        odd = 0;
        if ((rest = c - lenstr) % 2) odd = 1;
        spc = rest/2;      
        for (i = 0; i < spc; i++)
          fprintf(saida, " ");
        for (i = start; i <= end; fputc(B->data[i++], saida));
        for (i = 0; i < spc + odd; i++)
          fprintf(saida, " ");
      }
      if (endln) fprintf(saida, "\n");
      endln = 0;
    }
    else { //Tem \n no final, com espaço ou não antes.
      B->data[start] = 0;
      fprintf(saida, B->data);
    }
  }
  buffer_destroy(B);
  return 0;
}