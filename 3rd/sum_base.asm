STKSEG SEGMENT STACK 
    DW 32 DUP(0) 
STKSEG ENDS 

DATASEG SEGMENT
    COUNT DW 100
    ANS DW 0
DATASEG ENDS

ASSUME CS:CODESEG,DS:DATASEG,SS:STKSEG 

CODESEG SEGMENT 
MAIN PROC FAR 
    MOV AX,DATASEG 
    MOV DS,AX 
    
    MOV CX,COUNT
    XOR BX,BX
SUM:
    ADD BX,CX
    LOOP SUM

    MOV [ANS],BX
    XOR BX,BX
    MOV BL,10
    MOV AX,[ANS]

OUTPUT:
    XOR DX,DX
    DIV BX
    MOV [ANS],AX
    ADD DL,30H
    MOV AH,2
    INT 21H
    MOV AX,[ANS]
    CMP AX,0
    JNE OUTPUT
    
    MOV AX,4C00H 
    INT 21H
    
MAIN ENDP 

CODESEG ENDS 

END MAIN 
substitute