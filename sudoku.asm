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

perdeu_vida MACRO
    DEC vidas           ; Decrementa uma vida
    pula_linha          ; Macro 'pula_linha'
    MOV AH, 09          ;
    LEA DX, vida_loss   ; Imprime a mensagem de vida perdida
    INT 21h             ;

    MOV AH,07           ;
    INT 21h             ; Entrada do usuario para a mensagem não se perder

    CMP vidas,31h       ; 
    JGE encerrar        ; Caso ainda sobrar vidas apenas continua a execução do programa
    JMP fimdejogo       ; Caso não vai para a mensagem de derrota
ENDM

horizontal MACRO
    MOV AH,09           ;
    LEA DX,hor          ; Imprime as barras horizontais
    INT 21h             ;
ENDM

vertical MACRO
    MOV AH,02           ;
    MOV DL,179          ; Imprime a barra vertical
    INT 21h             ;
ENDM

COR MACRO
    MOV AH,06h          ;
    XOR AL,AL           ;
    XOR CX,CX           ;
    MOV DX,184Fh        ; Muda a cor do programa para azul ciano
    MOV BH,0Bh          ;
    INT 10h             ;
ENDM

PUSHREG MACRO 
  PUSH AX               ;
  PUSH BX               ;
  PUSH CX               ; Da push nos registradores para salvar o conteudo
  PUSH DX               ;
  PUSH SI               ;
ENDM

POPREG MACRO
   POP SI               ;
   POP DX               ;
   POP CX               ; Da pop nos registradores para salvar o conteudo
   POP BX               ;
   POP AX               ;
ENDM

espaco MACRO
    MOV AH,02           ;
    MOV DL,32           ; Escreve um espaço
    INT 21h             ;
ENDM 

pula_linha MACRO
    MOV AH,02           ;
    MOV DL,10           ; Pula uma linha
    INT 21h             ;
ENDM 

.data
    hor DB 20 DUP(205),'$'
    win DB 'Parabens, voce completou o sudoku! $'
    go DB 10,'Game over! Suas vidas acabaram...$'
    vida_loss DB 'Resposta errada! Voce perdeu uma vida... $'
    msg_vida DB 'Vidas: $'
    vidas DB '3$'
    msg_erro DB 'Voce nao pode sobreescrever numeros!$'
    res DB 'Qual a resposta? $'
    msg_lin DB 10,'Qual a linha? $'
    msg_col DB 'Qual a coluna? $'
    traco DB 12 DUP(95),'$'
    wel  DB  10,13,'             WELCOME TO SUDOKU         ' ,10,13,'$'
    msg_dif DB 'Qual dificuldade?',10,'1-Normal 2-Dificil',10,'$'
    DIFICULDADE DB '2$'
    ;Siglas:
    ;D - Dificil
    ;N - Normal
    ;R - Reposta

    NR  DB '4','1','5','3','7','8','2','9','6'
        DB '2','3','7','1','6','9','4','8','5'
        DB '6','8','9','4','2','5','7','3','1'
        DB '8','9','3','7','5','1','6','2','4'
        DB '5','7','4','2','3','6','9','1','8'
        DB '1','6','2','9','8','4','3','5','7'
        DB '9','2','8','6','1','7','5','4','3'
        DB '7','4','1','5','9','3','8','6','2'
        DB '3','5','6','8','4','2','1','7','9$'

    N   DB '4','?','?','3','?','8','?','?','6'
        DB '2','3','?','?','6','?','4','?','?'
        DB '?','?','9','4','?','?','7','?','?'
        DB '8','9','?','7','?','?','?','?','?'
        DB '5','?','?','?','?','?','9','1','?'
        DB '?','6','?','?','?','?','?','?','7'
        DB '?','?','8','?','1','?','?','4','3'
        DB '?','4','1','?','?','?','?','6','?'
        DB '?','?','?','8','?','2','?','7','?$'

  DR    DB '5','3','4','6','7','8','9','1','2'
        DB '6','7','2','1','9','5','3','4','8'
        DB '1','9','8','3','4','2','5','6','7'
        DB '8','5','9','7','6','1','4','2','3'
        DB '4','2','6','8','5','3','7','9','1'
        DB '7','1','3','9','2','4','8','5','6'
        DB '9','6','1','5','3','7','2','8','4'
        DB '2','8','7','4','1','9','6','3','5'
        DB '3','4','5','2','8','6','1','7','9$'

    D   DB '5','3','?','?','7','?','?','?','?'
        DB '6','?','?','1','9','5','?','?','?'
        DB '?','9','8','?','?','?','?','6','?'
        DB '8','?','?','?','6','?','?','?','3'
        DB '4','?','?','8','?','3','?','?','1'
        DB '7','?','?','?','2','?','?','?','6'
        DB '?','6','?','?','?','?','2','8','?'
        DB '?','?','?','4','1','9','?','?','5'
        DB '?','?','?','?','8','?','?','7','9$'
.code
MAIN PROC
    MOV AX, @data   ;
    MOV DS, AX      ;   Inicializa segmento de dados
    MOV ES, AX      ;

    LIMPA_TELA      ; Chama macro 'LIMPA_TELA'
    COR             ; Chama macro 'COR'

    MOV AH,09       ;
    LEA DX,wel      ; Imprime mensagem de entrada
    INT 21h         ;

    pula_linha      ; Chama macro 'pula_linha'

    MOV AH,09       ;
    LEA DX,msg_dif  ; Imprime mensagem de dificuldade
    INT 21h         ;

    MOV AH,07           ;
    INT 21h             ; Recebe entrada do usuario para dificuldade
    MOV dificuldade,AL  ; E seta na variavel 'dificuldade'

    LIMPA_TELA          ; Chama macro 'LIMPA_TELA'

    continuar:          ; label 'continuar'
    CALL IMPRESSAO      ; Chama o procedimento de impressão
    CALL PREENCHER      ; Chama o procedimento para preencher

    CMP dificuldade, 31h    ; 
    JNE vef_d               ; Verifica se a dificuldade é normal ou dificil

    MOV CX,89               ;
    CLD                     ;
    LEA DI,N                ; Lê todo o banco para ver se ainda há '?' ou seja espaços não preenchidos
    MOV AL,'?'              ;
    REPNE SCASB             ;
    JE continuar            ; Se houver continua o programa
    JMP ganhou              ; Senão pula para a mensagem de vitoria

    vef_d:                  ; label de verificação do dificil
    MOV CX,89               ;
    CLD                     ;
    LEA DI,D                ; Lê todo o banco para ver se ainda há '?' ou seja espaços não preenchidos
    MOV AL,'?'              ;
    REPNE SCASB             ;
    JE continuar            ; Se houver continua o programa

    ganhou:                 ; label 'ganhou'
    MOV AH,09               ;
    LEA DX, win             ; Imprime mensagem de vitoria
    INT 21h                 ;

    MOV AH, 4Ch             ;
    INT 21h                 ; Finaliza o programa

    fimdejogo:              ; label 'fimdejogo'
    LIMPA_TELA              ; Chama macro 'LIMPA_TELA'

    MOV AH,09               ;
    LEA DX, go              ; Imprime a mensagem de game over
    INT 21h                 ;

    MOV AH,07               ; 
    INT 21h                 ; Entrada do usuario só para aparecer a mensagem antes de finalizar o programa

    MOV AH, 4Ch             ;
    INT 21h                 ; Finaliza o programa
MAIN ENDP

IMPRESSAO PROC              ; Procedimento de impressão
    PUSHREG                 ; Da push nos registradores
    COR                     ; Chama macro 'COR'

    MOV AH,09               ;
    LEA DX, msg_vida        ; Imprime a mensagem de vida
    INT 21h                 ;
    LEA DX, vidas           ; E a quantidade de vida
    INT 21h                 ;

    pula_linha              ; Chama macro 'pula_linha'

    CMP dificuldade, 31h    ; Verifica a dificuldade normal
    JE normal               ; Se não for pula para a normal
    XOR BX,BX               ; Limpa o registrador BX
    voltad:                 ; label volta dificil
    pula_linha              ; Chama macro 'pula_linha'
    XOR DI,DI               ; Limpa registrador DI
    MOV CX,9                ; Seta loop para 9
    imp_dificil:            ; label imprimir dificil

        CMP CX,3            ;
        JNE vertd1          ; Verifica se está na linha 3 para imprimir a barra vertical
        vertical            ;
        vertd1:             ; Se não estiver apenas pula

        CMP CX,6            ;
        JNE vertd2          ; Verifica se está na linha 6 para imprimir a barra vertical
        vertical            ;
        vertd2:             ; Se não estiver apenas pula

        MOV AH,02           ;
        MOV DL,D[BX][DI]    ; Imprime o numero referente a matriz
        INT 21h             ;
        INC DI              ; Incrimenta a coluna
        espaco              ; Escreve um espaço
    loop imp_dificil        ; fecha o loop de imprimir o sudoku dificil

    CMP BX,18               ;
    JNE hord1               ; Verifica se está na linha 18 para imprimir a barra horizontal e pular uma linha
    pula_linha              ;
    horizontal              ;
    hord1:                  ; Se não estiver apenas pula

    CMP BX,45               ;
    JNE hord2               ; Verifica se está na linha 45 para imprimir a barra horizontal e pular uma linha
    pula_linha              ;
    horizontal              ;
    hord2:                  ; Se não estiver apenas pula

    CMP BX,72               ; Verifica se chegou ao final da matriz
    JE fim                  ; Se sim pula para o final
    ADD BX,9                ; Se não adiciona 9 na linha
    JMP voltad              ; E continua a imprimir
    pula_linha              ; Macro 'pula_linha'

    normal:                 ; label 'normal'
    XOR BX,BX               ; Limpa o registrador BX
    voltan:                 ; label 'voltan'
    pula_linha              ; Macro 'pula_linha'
    XOR DI,DI               ; Limpa o registrador DI
    MOV CX,9                ; Seta o loop em 9
    imp_normal:
        CMP CX,3            ; Verifica se está na linha 3 para imprimir a barra vertical
        JNE vertn1          ;
        vertical            ;
        vertn1:             ; Se não estiver apenas pula

        CMP CX,6            ; Verifica se está na linha 6 para imprimir a barra vertical
        JNE vertn2          ;
        vertical            ;
        vertn2:             ; Se não estiver apenas pula

        MOV AH,02           ;
        MOV DL,N[BX][DI]    ; Imprime o numero referente a matriz
        INT 21h             ;
        INC DI              ; Incrementa a coluna
        espaco              ; Dá um espaço
    loop imp_normal         ; fecha o loop de imprimir o sudoku normal

    CMP BX,18               ;
    JNE horn1               ; Verifica se está na linha 18 para imprimir a barra horizontal e pular uma linha
    pula_linha              ;
    horizontal              ;
    horn1:                  ; Se não apenas pula

    CMP BX,45               ;
    JNE horn2               ; Verifica se está na linha 45 para imprimir a barra horizontal e pular uma linha
    pula_linha              ;
    horizontal              ;
    horn2:                  ; Se não apenas pula

    CMP BX,72               ; Verifica se está no fim da matriz
    JE fim                  ; Se sim pula para o fim
    ADD BX,9                ;
    JMP voltan              ; Se não apenas acrescenta 9 na linha e reseta o loop
    fim:                    ; label 'fim'
    pula_linha              ; Macro 'pula linha'
    POPREG                  ; Pop nos registradores
    RET                     ; Sai do procedimento
IMPRESSAO ENDP

PREENCHER PROC
    XOR BX,BX               ; Limpa o registrador BX

    MOV AH,09               ;
    LEA DX,msg_lin          ; Imprime a mensagem de linhas
    INT 21h                 ;

    MOV AH, 01              ;
    INT 21h                 ; Recebe a entrada do usuario

    XOR AH, AH              ;
    XOR BX, BX              ; Limpa os registradores BX e AH
    SUB AX, 30h             ; Transforma a entrada do usuario em numero
    DEC AX                  ; Decrementa em 1 para ficar alinhado com linha da tabela
    MOV BX,9                ;
    MUL BX                  ; Multiplica por 9 para entrar no padrão da matriz
    MOV BX, AX              ; BX recebe o resultado da multiplicação

    pula_linha              ; Macro 'pula_linha'

    MOV AH, 09              ;
    LEA DX,msg_col          ; Imprime a mensagem de coluna
    INT 21h                 ;

    MOV AH, 01              ;
    INT 21h                 ; Recebe a entrada do usuario

    XOR AH, AH              ;
    MOV DI, AX              ; DI recebe a entrada do usuario
    SUB DI,30h              ; Transforma a entrada em numero
    DEC DI                  ; Decrementa DI para alinha com o parametro da matriz

    pula_linha              ; Macro Pula linha

    CMP dificuldade,31h     ; Verifica se a dificuldade é normal
    JNE preen_dif           ; Caso for dificil pula para a metodo de preencher a matriz dificil

    CMP N[BX][DI],63        ; Compara se o elemento da matriz selecionado é um '?'
    JE cont_pren_nor        ; Caso for continua para preencher
    JMP jmp_erro            ; Se não for vai para a mensagem de erro

    cont_pren_nor:
    pula_linha              ; Macro 'pula_linha'

    MOV AH,09               ;
    LEA DX,res              ; Imprime a mensagem de resultado
    INT 21h                 ;

    MOV AH,01               ;
    INT 21h                 ; Recebe a entrada do usuario

    CMP AL,NR[BX][DI]       ; Compara se a entrada do usuario é a correta
    JE sem_erron            ; Se for vai alterar a matriz
    perdeu_vida             ; Se não usuario perde uma vida

    sem_erron:              ;
    MOV N[BX][DI],AL        ; Altera a matriz
    JMP encerrar            ; E encerra o procedimento

    preen_dif:              ;
    CMP D[BX][DI],63        ;
    JNE jmp_erro            ;
    
    pula_linha              ;

    MOV AH,09               ;
    LEA DX,res              ;
    INT 21h                 ;

    MOV AH,01               ;
    INT 21h                 ;

    CMP AL,DR[BX][DI]       ;
    JE sem_errod            ;
    perdeu_vida             ;

    sem_errod:              ;
    MOV D[BX][DI],AL        ;
    JMP encerrar            ; Até aqui as instruções se repetem para a matriz do sudoku dificil

    jmp_erro:               ;
    MOV AH,09               ;
    LEA DX,msg_erro         ; Imprime a mensagem de erro
    INT 21h                 ;

    MOV AH,07               ;
    INT 21h                 ; Entrada do usuario para a mensagem não se perder

    encerrar:
    LIMPA_TELA              ; Macro 'LIMPA_TELA '
    RET                     ; Encerra o procedimento
PREENCHER ENDP
END MAIN
    
