c IS $6; temp_c IS $1; address_digit_c IS $0; begin_string IS $5; increment_char IS $3; sizeof_word IS $8; is_space IS $9; is_paragraph IS $10; may_print IS $11
sizeof_string IS $12; sizeof_both IS $13; temp_address IS $14; cont_eol IS $15; may_paragraph IS $16; space IS $17; word_count IS $18; sum_tempword IS $19; stop_save IS $20; remaining_spaces IS $21;
spaces_per_word IS $22; sum_tempstring IS $23; cont_espacos IS $24; increment_espacos IS $25; is_zero IS $26
         EXTERN main
main     XOR   c,c,c
         SETW  space,32
         SETW  temp_address,100
         SETW  begin_string,200
        
         SUBU  address_digit_c,rSP,16                *Faz address_digit_c=rSP-16
readint  LDBU  temp_c,address_digit_c,0
         JZ    temp_c, setup                         * se temp_c for 0, o numero acabou
         SUBU  temp_c,temp_c,48                      * transforma o temp_c em caractere
         MULU  c,c,10                                *Abre espaço para adicionar o algarismo
         ADDU  c,c,temp_c                            *Adiciona o algarismo
         ADDU  address_digit_c,address_digit_c,1
         JMP   readint

setup    SETW  rX,1
         XOR   word_count,word_count,word_count
         XOR  increment_char,increment_char,increment_char
         XOR  sizeof_word,sizeof_word,sizeof_word
         XOR  sizeof_string,sizeof_string,sizeof_string
         XOR  sizeof_both,sizeof_both,sizeof_both
         XOR  cont_eol,cont_eol,cont_eol

  
 readspace          INT   #80                                   *Lê um caractere
           CMP   is_space,rA,9  *Verifica se é tab                      
           JZ    is_space,checkendword
           CMP   is_space,rA,13                        *Verifica se é carriage return
           JZ    is_space,checkendword
           CMP   is_space,rA,32                        *Verifica se é espaço em branco
           JZ    is_space,checkendword
           CMP   is_paragraph,rA,10                    *Verifica se é quebra-de-linha
           JZ    is_paragraph,eol
           
           JZ    rA, readparagraph2                    *se encontrar o final do arquivo


readcharacter    CMP   may_paragraph,cont_eol,2
                 SETW  cont_eol,0
                 JN    may_paragraph,savetxt
readparagraph    JZ   sizeof_string, printparagraph
readparagraph2   ADDU sum_tempstring,begin_string,sizeof_string
                 SETW  rX,2
printlastlineloop CMP  stop_save,begin_string,sum_tempstring
                 JNN   stop_save,printparagraph
                 OR   rY,begin_string,0
                 INT  #80
                 ADDU begin_string,begin_string,1
                 JMP printlastlineloop
                 

                 
printparagraph   JZ rA,end
                 SETW  rX,2
                 SETW  rY,10
                 INT   #80
                 INT   #80
                 SETW  rX,1
                 JMP   savetxt              
                 

eol             ADDU  cont_eol,cont_eol,1
         
checkendword    JZ    sizeof_word,readspace 

                ADDU  sizeof_both,sizeof_word,sizeof_string
                CMP   may_print,sizeof_both,c 
                JP    may_print,goback
                JZ    sizeof_string,savestring

                STBU  space,begin_string,sizeof_string   *adiciona espaço na ultima palavra da string, pra separar da proxima palavra
                ADDU  sizeof_string,sizeof_string,1

savestring      ADDU  word_count,word_count,1
                ADDU  sum_tempword,sizeof_word,temp_address
                CMP   stop_save,temp_address,sum_tempword
savecharloop    JNN   stop_save,endsavechar
                
                STBU  temp_address,begin_string,sizeof_string
                ADDU  temp_address,temp_address,1
                ADDU  sizeof_string,sizeof_string,1
                JMP   savecharloop
 endsavechar    XOR   sizeof_word,sizeof_word,sizeof_word
                SETW  temp_address,100
                JMP   readspace


              

savetxt  STBU  rA,temp_address,sizeof_word
         ADDU  sizeof_word,sizeof_word,1
         JMP   readspace                       *Volta para ler o próximo caractere


goback    SUBU remaining_spaces,c,sizeof_string   *dá \n e salva no endereço oficial o a palavra do temp_address
          SUBU word_count,word_count,1            *word_count passa a guardar o numero de espaços
          DIVU spaces_per_word,remaining_spaces,word_count
          ADDU sum_tempstring,begin_string,sizeof_string
          SUBU  cont_espacos,word_count,rR
          SETW  rX,2
insertspaceloop          CMP  stop_save,begin_string,sum_tempstring
                         JNN  stop_save,end_eol
                         CMP  stop_save,begin_string,10
                         JZ   stop_save, addspaces
                         OR  rY,begin_string,0
                         INT  #80
                         ADDU begin_string,begin_string,1
                         JMP insertspaceloop

addspaces                  OR  rY,begin_string,0
                           INT  #80
                           JNZ   cont_espacos,addremainderspacesloop
                           ADDU  spaces_per_word,spaces_per_word,1
addremainderspacesloop     ADDU begin_string,begin_string,1
                           SUBU cont_espacos,cont_espacos,1
addspacesloop              CMP  stop_save,increment_espacos,spaces_per_word
                           JNN  stop_save,insertspaceloop
                           INT #80
                           ADDU increment_espacos,increment_espacos,1
                           JMP addspacesloop







          

end_eol  SETW rY,10
         INT   #80
         SETW begin_string,200
         XOR sizeof_string,sizeof_string,sizeof_string
         JMP readspace


end      INT   0