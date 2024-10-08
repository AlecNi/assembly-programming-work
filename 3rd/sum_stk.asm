STKSEG SEGMENT STACK 
    DW 32 DUP(0) 
STKSEG ENDS 

DATASEG SEGMENT
    COUNT DW 100
DATASEG ENDS

ASSUME CS:CODESEG,DS:DATASEG,SS:STKSEG 

CODESEG SEGMENT 
MAIN PROC FAR 
    MOV AX,DATASEG 
    MOV DS,AX 
    MOV AX,STKSEG
    MOV SS,AX
    
    MOV CX,[COUNT]
    XOR AX,AX
SUM:
    ADD AX,CX
    LOOP SUM

    XOR CX,CX
    XOR BX,BX
    MOV BL,10
INSTK:
    XOR DX,DX
    DIV BX
    ADD DL,30H
    PUSH DX
    INC CX
    CMP AX,0
    JNE INSTK
    
    MOV AH,2
OUTPUT:
    POP DX
    INT 21H
    LOOP OUTPUT
    
    MOV AX,4C00H 
    INT 21H
    
MAIN ENDP 

CODESEG ENDS 

END MAIN 
substitute