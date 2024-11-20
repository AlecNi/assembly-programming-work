STKSEG SEGMENT STACK 
    DW 32 DUP(0) 
STKSEG ENDS 

DATA SEGMENT 
    ;以下是表示21年的21个字符串 
    DB  '1975','1976','1977','1978','1979','1980','1981','1982','1983' 
    DB  '1984','1985','1986','1987','1988','1989','1990','1991','1992' 
    DB  '1993','1994','1995' 
    
    ;以下是表示21年公司总收的21个dword型数据 
    DD  16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514 
    DD  345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000 
    
    ;以下是表示21年公司雇员人数的21个word型数据 
    DW  3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226 
    DW  11542,14430,15257,17800         
DATA ENDS 

TABLE SEGMENT 
    DB 21 DUP('year summ ne ?? ') 
TABLE ENDS 

ASSUME CS:CODESEG,DS:DATA,ES:TABLE,SS:STKSEG 

EXTRN CLS:FAR
EXTRN PIP_PRINT:FAR
EXTRN PIP_OP:FAR

CODESEG SEGMENT 

MAIN PROC FAR 
    MOV AX,DATA
    MOV DS,AX
    
    MOV AX,TABLE
    MOV ES,AX

    MOV BX,4
    MOV AX,21
    MUL BX
    MOV BX,AX
    ADD AX,AX
    MOV CX,AX
    XOR SI,SI
    XOR DI,DI
    MOV AX,21
    
    call PIP_OP

    MOV AH,00H    ;设置显示方式
    MOV AL,02H    ;80*25 16色文本显示
    INT 10H
    
    MOV AX,ES
    MOV DS,AX
    MOV BX,0B800H
    MOV ES,BX

    MOV CX,840
    call CLS
    
    MOV SI,0
    MOV DI,170
    MOV AX,21
    MOV CH,04H
    
    call PIP_PRINT

    ; 设置光标位置
    ; AH = 02h (Set Cursor Position)
    ; BH = 00h (Video Page Number)
    ; DH = Row (0-24)
    ; DL = Column (0-79)
    MOV AH, 02h
    MOV BH, 00h
    MOV DH, 16H  ; 设置行号
    MOV DL, 00H  ; 设置列号
    INT 10h

    MOV AX,4C00H 
    INT 21H
MAIN ENDP 

CODESEG ENDS 

END MAIN 
substitute