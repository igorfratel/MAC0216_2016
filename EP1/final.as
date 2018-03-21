v1 IS $1; v2 IS $2; sizeof_v1 IS $3; sizeof_v2 IS $4; c IS $5; temp_c IS $6; address_digit_c IS $7; cont_n IS $8; char_identifier IS $9; paragraph IS $10; return_address IS $11;
is_empty_v1 IS  $12; is_empty_v2 IS $13; space IS  $14; character IS $15; cont_v1 IS $16; cont_v2 IS $17; sumsizesof_v1_v2 IS $18; compare_c IS $19; size_compare IS $20;
remaining_spaces IS $21; spaces_per_word IS $22; cont_spaces IS $23; number_of_spaces IS $24; temp_cont_spaces IS $25



EXTERN main
main  SETW  v1,100                          */Cria os vetores v1 e v2 e "inicializa" seus tamanhos
      SETW  v2,200                          *
      XOR   sizeof_v1,sizeof_v1,sizeof_v1   *
      XOR   sizeof_v2,sizeof_v2,sizeof_v2   */

      XOR   cont_n,cont_n,cont_n            *"Inicializa" o contador de quebras de linha

      SETW  space,32

         SUBU  address_digit_c,rSP, 16               */Faz a leitura do inteiro c a partir
         LDOU  address_digit_c,address_digit_c,0     *dos argumentos da chamada do programa
readint  LDBU  temp_c,address_digit_c, 0             *
         JZ    temp_c,read                           * 
         SUBU  temp_c,temp_c,48                      *
         MULU  c,c,10                                *
         ADDU  c,c,temp_c                            *
         ADDU  address_digit_c,address_digit_c,1     *
         JMP   readint                               */
         
read     SETW rX,1                             *
         INT #80                               *
         CMP   char_identifier,rA,9            */Verifica se o caractere lido é um espaço                   
         JZ    char_identifier,found_space     *
         CMP   char_identifier,rA,13           *                        
         JZ    char_identifier,found_space     *
         CMP   char_identifier,rA,32           *                       
         JZ    char_identifier,found_space     */

         JN    rA,found_EOF                    *Verifica se o caractere lido é um EOF

         CMP  char_identifier,rA,10            */Verifica se o caractere lido é uma quebra de linha
         JNZ   char_identifier,3               *Se for, incrementa cont_n
         ADDU cont_n,cont_n,1                  *
         JMP  read                             */

         CMP  paragraph,cont_n,2               */Verifica se já lemos 2 ou mais quebras de linha
         JNN  paragraph, found_paragraph       */

         JZ   sizeof_v1,save                   */Se encontrar um \n apenas e depois um caractere, tratar como espaço
         JP   cont_n,found_space               */

save     XOR cont_n,cont_n,cont_n              */Salva o caractere lido em v1
         STBU rA,v1,sizeof_v1                  *
         ADDU sizeof_v1,sizeof_v1,1            *
         JMP  read                             */

found_space GETA   return_address,2                         */Se v1 estiver vazio: volta para o read                                  
            JMP    verify_sizeof_v1_v2                      *Se v1 não estiver vazio e:
            JZ     is_empty_v1, 15                          *    v2 estiver vazio: copia, volta para o read
            JZ     is_empty_v2,12                           *    v2 não estiver vazio e:
            ADDU   sumsizesof_v1_v2,sizeof_v1,sizeof_v2     *        sizeof_v1 + sizeof_v2 +1 <= c: adiciona espaço em v2, copia, volta para o read
            ADDU   sumsizesof_v1_v2,sumsizesof_v1_v2,1      *        sizeof_v1 + sizeof_v2 +1 > c: imprime, imprime \n, copia, volta para o read
            CMP    compare_c,sumsizesof_v1_v2,c             *
            JNP    compare_c,6                              *
            GETA   return_address,2                         *
            JMP    print                                    *
            SETW   rY,10                                    *
            INT    #80                                      *
            JMP    3                                        *
            STBU   space,v2,sizeof_v2                       * 
            ADDU   sizeof_v2,sizeof_v2,1                    *
            GETA   return_address,2                         *
            JMP    copy                                     *
            JP     cont_n,save                              *
            JMP    read                                     */


found_EOF   GETA  return_address,2                          */Se nem v1 e nem v2 estiverem vazios: 
                                                            *     sizeof_v1 + sizeof_v2 +1 <= c: adiciona espaço em v2, copia, imprime, encerra o programa 
                                                            *     sizeof_v1 + sizeof_v2 +1 > c: adiciona \n em v2, copia, imprime, encerra o programa            
            JMP   verify_sizeof_v1_v2                       *Se v1 não estiver vazio, mas v2 sim: copia, imprime, encerra programa
            JZ    is_empty_v1,18                             *Se v1 estiver vazio, mas v2 não: imprime, encerra programa
            JZ    is_empty_v2,15                             *Se v1 e v2 estiverem vazios: encerra programa
            ADDU   sumsizesof_v1_v2,sizeof_v1,sizeof_v2     *        
            ADDU   sumsizesof_v1_v2,sumsizesof_v1_v2,1      *       
            CMP    compare_c,sumsizesof_v1_v2,c             *
            JNP    compare_c,9                              *
            GETA   return_address,2
            JMP    print
            SETW   rY,10
            INT    #80
            GETA   return_address,2                         *
            JMP    copy                                     *
            GETA   return_address,9                         *
            JMP    print                                    *
           STBU   space,v2,sizeof_v2                       *
            ADDU   sizeof_v2,sizeof_v2,1                    *
           GETA  return_address,3                          *
            JMP   copy                                      *
           JZ    is_empty_v2,3                             *
          GETA  return_address,2                          * 
            JMP   print                                     *
           INT   0                                          */


found_paragraph   XOR  cont_n,cont_n,cont_n   */Se nem v1 e nem v2 estiverem vazios: adiciona espaço em v2, copia, imprime, imprime \n\n, volta para o save
                  GETA return_address,2       *Se v1 não estiver vazio, mas v2 sim: copia, imprime, imprime \n\n, volta para o save
                  JMP  verify_sizeof_v1_v2    *Se v1 estiver vazio, mas v2 não: imprime, imprime \n\n, volta para o save
                  JZ   is_empty_v1,12         *Se v1 e v2 estiverem vazios: volta para o save
                  JZ   is_empty_v2,3          *
                  STBU space, v2,sizeof_v2    *
                  ADDU sizeof_v2,sizeof_v2,1  *
                  GETA return_address,2       *
                  JMP  copy                   *
                  GETA return_address,2       *
                  JMP  print                  *
                  SETW rY,10                  *
                  INT  #80                    *
                  INT  #80                    *
                  JMP  save                   *
                  JZ   is_empty_v2,save       *
                  JMP -7                      */


verify_sizeof_v1_v2   CMP is_empty_v1,sizeof_v1,0 */Confere se v1 e/ou v2 estão vazios
                      CMP is_empty_v2,sizeof_v2,0 *
                      GO  return_address,0        */
                  

copy  XOR   cont_v1,cont_v1,cont_v1          */Copia v1 para v2
      CMP   size_compare,cont_v1,sizeof_v1   *
      JN    size_compare,3                   *
      XOR   sizeof_v1,sizeof_v1,sizeof_v1    *
      GO    return_address,0                 *
      LDBU  character,v1,cont_v1             *
      STBU  character,v2,sizeof_v2           *
      ADDU  cont_v1,cont_v1,1                *
      ADDU  sizeof_v2,sizeof_v2,1            *
      JMP   -8                               */


print XOR   cont_v2,cont_v2,cont_v2          */Imprime v2
      SETW  rX,2                             *
      CMP   size_compare,cont_v2,sizeof_v2   *
      JN    size_compare,3                   *
      XOR   sizeof_v2,sizeof_v2,sizeof_v2    *
      GO    return_address,0                 *
      LDBU  character,v2,cont_v2             *
      OR    rY,character,0                   *
      INT   #80                              *
      ADDU  cont_v2,cont_v2,1                *
      JMP   -8                               */


insert_spaces SETW  rX,2
              XOR   cont_v2,cont_v2,cont_v2
              XOR   number_of_spaces,number_of_spaces,number_of_spaces
              OR    cont_v2,sizeof_v2,0
              SUBU  cont_v2,cont_v2,1
              JN    cont_v2,8
              LDBU  character,v2,cont_v2
              CMP   char_identifier,character,32
              JZ    char_identifier,3
              SUBU  cont_v2,cont_v2,1
              JMP   -5
              ADDU  number_of_spaces,number_of_spaces,1
              JMP   -8

              XOR   cont_v2,cont_v2,cont_v2
              SUBU  remaining_spaces,c,sizeof_v2
              JNP   remaining_spaces, print
              DIVU  spaces_per_word,remaining_spaces,number_of_spaces
              SUBU  cont_spaces, number_of_spaces,rR
              CMP   size_compare,cont_v2,sizeof_v2
              JZ    size_compare,21
              LDBU  character,v2,cont_v2
              CMP   char_identifier,character,32
              JNZ   char_identifier,14
              JNZ   cont_spaces,7
              OR    temp_cont_spaces,rR,0
              OR    rY,space,0
              INT   #80
              SUBU  temp_cont_spaces,temp_cont_spaces,1
              JNZ   temp_cont_spaces,-2
              JMP   8
              SUBU  cont_spaces,cont_spaces,1
              OR    temp_cont_spaces,spaces_per_word,0
              OR    rY,space,0
              INT   #80
              SUBU  temp_cont_spaces,temp_cont_spaces,1
              JNZ   temp_cont_spaces,-2
              LDBU  rY,v2,cont_v2
              INT   #80
              ADDU  cont_v2,cont_v2,1
              JMP   -21 
              XOR   sizeof_v2,sizeof_v2,sizeof_v2
              GO    return_address,0     