STKSEG SEGMENT STACK 
    DW 32 DUP(0) 
STKSEG ENDS 

DATASEG SEGMENT
    PROMPT DB "The 9mul9 table:$"
    NEW_LINE DB 0AH 
    SPACE DB 20H
    COUNT DW 9
DATASEG ENDS

ASSUME CS:CODESEG,DS:DATASEG,SS:STKSEG 

CODESEG SEGMENT 

PRINT_AX PROC FAR
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX

    MOV CX,AX
    MOV BX,1
TRANSF:
    XCHG AX,BX
    MOV DX,10
    MUL DX
    XCHG AX,BX
    DIV BX
    CMP AX,0
    MOV AX,CX
    JNE TRANSF

OUTPUT:
    XCHG AX,BX
    XCHG BX,CX
    MOV BX,10
    XOR DX,DX
    DIV BX
    XCHG BX,CX
    XCHG AX,BX
    XOR DX,DX
    DIV BX
    XCHG AX,DX
    
    ADD DL,30H
    XCHG AX,CX
    MOV AH,2
    INT 21H
    XCHG AX,CX
    CMP BX,1
    JNE OUTPUT

    POP DX
    POP CX
    POP BX
    POP AX

    RET
PRINT_AX ENDP

CALCU PROC FAR
    PUSH AX
    PUSH CX
    PUSH DX

    MOV CX,AX
    MOV AH,2

    XOR DX,DX
    MOV DL,AL
    ADD DX,30H
    INT 21H

    MOV DX,"*"
    INT 21H

    MOV DL,BL
    ADD DX,30H
    INT 21H

    MOV DX,"="
    INT 21H

    MOV AX,CX
    MUL BL

    CALL PRINT_AX

    XOR DX,DX
    MOV AH,2
    MOV DL,[SPACE]
    INT 21H

    POP DX
    POP CX
    POP AX
    
    RET
CALCU ENDP

MAIN PROC FAR 
    MOV AX,DATASEG 
    MOV DS,AX 
    
    MOV AH,9
    LEA DX,PROMPT
    INT 21H

    XOR DX,DX
    MOV AH,2
    MOV DL,[NEW_LINE]
    INT 21H

    MOV CX,[COUNT]
OUTLOOP:
    MOV BX,1
    MOV AX,CX
INTERLOOP: 
    CALL CALCU
    INC BX
    CMP BX,CX
    JLE INTERLOOP

    XOR DX,DX
    MOV AH,2
    MOV DL,[NEW_LINE]
    INT 21H

    LOOP OUTLOOP

    MOV AX,4C00H 
    INT 21H
MAIN ENDP 

CODESEG ENDS 

END MAIN 
substitute