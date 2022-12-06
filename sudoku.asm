.model small
espaco MACRO
    MOV AH,02
    MOV DL,32
    INT 21h
ENDM espaco

barra MACRO
    MOV AH,02
    MOV DL,124
    INT 21h
ENDM barra
tracejado MACRO
    MOV AH,09
    LEA DX, traco
    INT 21h

    MOV AH,02
    MOV DL,10
    INT 21h
ENDM tracejado

pula_linha MACRO
    MOV AH,02
    MOV DL,10
    INT 21h
ENDM pula_linha

imp_sudoku MACRO matriz
    XOR BX,BX
    tracejado
    volta:
    barra
    XOR DI,DI
    MOV CX,9
    imp_matriz:
        CMP matriz[BX][DI],48
        JNE nao_zero
        espaco
        barra
        INC DI
        JMP pula
        nao_zero:
        MOV AH,02
        MOV DL, matriz[BX][DI]
        INT 21h
        INC DI
        espaco
        barra
        pula:
    loop imp_matriz
    pula_linha
    tracejado
    CMP BX,72
    JE fim
    ADD BX,9
    JMP volta
    fim:
ENDM imp_sudoku
.data
    traco DB 12 DUP(95),'$'
    msg_dif DB 'Qual dificuldade?',10,'1-Normal 2-Dificil',10,'$'
    DIFICULDADE DB '2$'
    ;Siglas:
    ;D - Dificil
    ;N - Normal
    ;R - Reposta
    ;L - Linha
    DR   DB '5','3','4','6','7','8','9','1','2'
         DB '6','7','2','1','9','5','3','4','8'
         DB '1','9','8','3','4','2','5','6','7'
         DB '8','5','9','7','6','1','4','2','3'
         DB '4','2','6','8','5','3','7','9','1'
         DB '7','1','3','9','2','4','8','5','6'
         DB '9','6','1','5','3','7','2','8','4'
         DB '2','8','7','4','1','9','6','3','5'
         DB '3','4','5','2','8','6','1','7','9$'

    D    DB '5','3','0','0','7','0','0','0','0'
         DB '6','0','0','1','9','5','0','0','0'
         DB '0','9','8','0','0','0','0','6','0'
         DB '8','0','0','0','6','0','0','0','3'
         DB '4','0','0','8','0','3','0','0','1'
         DB '7','0','0','0','2','0','0','0','6'
         DB '0','6','0','0','0','0','2','8','0'
         DB '0','0','0','4','1','9','0','0','5'
         DB '0','0','0','0','8','0','0','7','9','$'
.code
MAIN PROC
    MOV AX, @data
    MOV DS, AX

    MOV AH, 09
    LEA DX,msg_dif
    INT 21h

    MOV AH, 07
    INT 21h

    CALL IMPRESSAO

    MOV AH, 4Ch
    INT 21h
MAIN ENDP
IMPRESSAO PROC
    imp_sudoku D
    RET
IMPRESSAO ENDP
END MAIN
    