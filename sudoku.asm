.model small
Cor MACRO
  Mov Ah,06h   ; funcao para mudar a cor
  XOR AL,AL
  XOR CX,CX
  Mov DX,184FH 
  Mov BH,0Bh   ;
  INT 10h      ; muda a cor do texto 

 ENDM

PUSHREG MACRO 
  PUSH AX
  PUSH BX
  PUSH CX
  PUSH DX
  PUSH SI
ENDM

POPREG MACRO
   POP SI
   POP DX
   POP CX
   POP BX
   POP AX
ENDM

espaco MACRO
    MOV AH,02
    MOV DL,32
    INT 21h
ENDM 

; barra MACRO
;     MOV AH,02
;     MOV DL,124
;     INT 21h
; ENDM 

; tracejado MACRO
;     MOV AH,09
;     LEA DX, traco
;     INT 21h

;     MOV AH,02
;     MOV DL,10
;     INT 21h
; ENDM 

pula_linha MACRO
    MOV AH,02
    MOV DL,10
    INT 21h
ENDM 

.data
    go DB 10,'Game over! Suas vidas acabaram...$'
    vida_loss DB 'Voce perdeu uma vida! $'
    msg_vida DB 'Vidas: '
    vidas DB 3
    msg_erro DB 'Erro!$'
    res DB 'Qual a resposta? $'
    msg_lin DB 'Qual a linha? $'
    msg_col DB 'Qual a coluna? $'
    traco DB 12 DUP(95),'$'
    msg1  DB  10,13,'             WELCOME SUDOKU         ' ,10,13,'$'
    msg_dif DB 'Qual dificuldade?',10,'1-Normal 2-Dificil',10,'$'
    DIFICULDADE DB '2$'
    
  DR      DB 0,201,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,187
          DB 0,186,'5',32,'3',32,'?',32,179,32,'?',32,'7',32,'?',32,179,32,'?',32,'?',32,'?',32,186
          DB 0,186,'6',32,'?',32,'?',32,179,32,'1',32,'9',32,'5',32,179,32,'X',32,'X',32,'X',32,186
          DB 0,186,'X','9','8',179,'X','X','X',179,'X','6','X',186
          DB 0,186,196,196,196,179,196,196,196,179,196,196,196,186
          DB 0,186,'8','X','X',179,'X','6','X',179,'X','X','3',186
          DB 0,186,'4','X','X',179,'8','X','3',179,'X','X','1',186
          DB 0,186,'7','X','X',179,'X','2','X',179,'X','X','6',186
          DB 0,186,196,196,196,179,196,196,196,179,196,196,196,186
          DB 0,186,'X','6','X',179,'X','X','X',179,'2','8','X',186
          DB 0,186,'X','X','X',179,'4','1','9',179,'X','X','5',186
          DB 0,186,'X','X','X',179,'X','8','X',179,'X','7','9',186
          DB 0,200,205,205,205,205,205,205,205,205,205,205,205,188

        
  D       DB 0,201,205,205,205,205,205,205,205,205,205,205,205,187
          DB 0,186,'X','X','X',179,'8','X','X',179,'X','3','2',186
          DB 0,186,'X','8','1',179,'3','7','X',179,'X','X','X',186
          DB 0,186,'6','X','3',179,'X','X','X',179,'1','X','8',186
          DB 0,186,196,196,196,179,196,196,196,179,196,196,196,186
          DB 0,186,'5','9','X',179,'4','X','X',179,'3','8','X',186
          DB 0,186,'X','X','6',179,'5','X','X',179,'X','X','X',186
          DB 0,186,'7','X','8',179,'X','2','X',179,'X','X','5',186
          DB 0,186,196,196,196,179,196,196,196,179,196,196,196,186
          DB 0,186,'X','X','X',179,'X','5','4',179,'2','X','X',186
          DB 0,186,'X','X','X',179,'X','X','X',179,'5','X','X',186
          DB 0,186,'4','2','5',179,'X','X','X',179,'8','1','7',186
          DB 0,200,205,205,205,205,205,205,205,205,205,205,205,188
.code
MAIN PROC
    MOV AX, @data
    MOV DS, AX
    MOV ES, AX

    Cor

    MOV AH ,09
    LEA DX,MSG1
    INT 21h

  pula_linha 

    LEA DX,msg_dif
    INT 21h

    pula_linha

    MOV AH,01
    INT 21h
    Mov BH,AL
    pula_linha
   
    
    cmp bh,32h       ; verifica a dificuldade, se for dificil (2) se não ele salta
    jne pula
    
    
   
    pula:
    A:
    mov ax,3
    int 10h
    CALL IMPRESSAO   ; chama o proc para imprimir a matriz(Sudoku) na tela
    CALL PREENCHER   ; chama o procedimento para o usuario manipular a matriz(Sudoku)
    lea si,D         ; aponta matriz
    lea di,DR        ; aponta para resposta
    cmpsb            ; compara matriz e resposta, retornando ZF
    jz A             
    pula_linha         

    continuar:
    MOV AH,09
    LEA DX,msg_vida
    INT 21h

    MOV AH,02
    MOV AL,vidas
    AND AL, 30h
    INT 21h

    MOV CX,89
    CLD
    LEA DI,D
    MOV AL,'?'
    REPNE SCASB
    JE continuar

    pula_linha 
    ;fim de jogo
    Cor
    MOV AH,09
    LEA DX, go
    INT 21h

    Mov ah, 4ch
    INT 21h
MAIN ENDP

IMPRESSAO PROC
    PUSHREG
    pula_linha
    xor bx,bx         ; zera SI e BX para iniciar os apontadores da matriz
    xor si,si      
    lea dx,D

    POPREG 
    RET
IMPRESSAO ENDP

PREENCHER PROC
    XOR BX,BX
    MOV AH, 09
    LEA DX,msg_lin
    INT 21h

    MOV AH, 07
    INT 21h

    XOR AH, AH
    XOR BX, BX
    SUB AX, 30h
    DEC AX
    MOV BX,9
    MUL BX
    MOV BX, AX

    pula_linha

    MOV AH, 09
    LEA DX,msg_col
    INT 21h

    MOV AH, 07
    INT 21h

    XOR AH, AH
    MOV DI, AX
    SUB DI,30h
    DEC DI

    pula_linha

    CMP D[BX][DI],63
    JNE jmp_erro
    
    pula_linha

    MOV AH,09
    LEA DX,res
    INT 21h

    MOV AH,07
    INT 21h

    CMP AL,DR[BX][DI]
    JE sem_erro
    SUB vidas,1
    pula_linha
    MOV AH, 09
    LEA DX, vida_loss
    INT 21h

    MOV AH,07
    INT 21h

    CMP vidas,0
    JGE encerrar
    JMP fimdejogo

    sem_erro:
    MOV D[BX][DI],AL
    JMP encerrar

    jmp_erro:
    MOV AH,09
    LEA DX, msg_erro
    INT 21h

    encerrar:
    LIMPA_TELA
    RET
PREENCHER ENDP
; VERIFICIAR PROC
; VERIFICAR ENDP
END MAIN
    
