.model small
LIMPA_TELA MACRO
  Mov Ah,00    ; tipo de video 
  Mov AL,03h   ; tipo de texto
  INT 10h      ; executa a entrada de video 
;formata modo de video
  Mov AH,09
  Mov AL,20h
  Mov BH,00   ;número de página
  Mov Bl,0FH   ; atribuição de cor
  Mov CX,800h
  INT 10h  ; executa a entrada de video 
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
    msg2 DB  OC4H , OC5H , 18 DUP (OC4H), '$'
    msg3 DB  OB3H , '$'
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
    ;Siglas:
    ;D - Dificil
    ;N - Normal
    ;R - Reposta
  DR    DB '5','3','4','6','7','8','9','1','2'
        DB '6','7','2','1','9','5','3','4','8'
        DB '1','9','8','3','4','2','5','6','7'
        DB '8','5','9','7','6','1','4','2','3'
        DB '4','2','6','8','5','3','7','9','1'
        DB '7','1','3','9','2','4','8','5','6'
        DB '9','6','1','5','3','7','2','8','4'
        DB '2','8','7','4','1','9','6','3','5'
        DB '3','4','5','2','8','6','1','7','9$'

 D      DB '5','3','?','?','7','?','?','?','?'
        DB '6','?','?','1','9','5','?','?','?'
        DB '?','9','8','?','?','?','?','6','?'
        DB '8','?','?','?','6','?','?','?','3'
        DB '4','?','?','8','?','3','?','?','1'
        DB '7','?','?','?','2','?','?','?','6'
        DB '?','6','?','?','?','?','2','8','?'
        DB '?','?','?','4','1','9','?','?','5'
        DB '?','?','?','?','8','?','?','7','9','$'
.code
MAIN PROC
    MOV AX, @data
    MOV DS, AX
    MOV ES, AX

    LIMPA_TELA

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
    cmpsb            ; compara matriz e gabarito, retornando ZF
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


    ;fim de jogo
    LIMPA_TELA
    MOV AH,09
    LEA DX, go
    INT 21h

    Mov ah, 4ch
    INT 21h
MAIN ENDP

IMPRESSAO PROC
    PUSHREG
    pula_linha

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
    
