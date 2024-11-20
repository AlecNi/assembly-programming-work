ASSUME CS:CODESEG

PUBLIC CLS
PUBLIC PIP_PRINT

CODESEG SEGMENT 

;CX save clean size
CLS PROC FAR
    PUSH BX
    PUSH CX
    PUSH DX

    XOR BX,BX
    XOR DX,DX
CLS_LOOP:
    MOV ES:[BX],DX
    ADD BX,2
    LOOP CLS_LOOP

    POP DX
    POP CX
    POP BX

    RET
CLS ENDP

;CX save string length
;AH save output style
;BX save input string ptr
;DI save output string ptr
STR_PRINT PROC FAR 
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DI

OUTPUT_STR_LOOP:
    MOV AL,[BX]
    MOV ES:[DI],AX
    INC BX
    ADD DI,2
    LOOP OUTPUT_STR_LOOP
    
    POP DI
    POP CX
    POP BX
    POP AX
    
    RET
STR_PRINT ENDP 

;AX save DW data
;CH save output style
;DI save output string ptr
DW2STR PROC FAR 
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH DI

    XOR CL,CL
    MOV BX,10
GET_DIGIT:
    INC CX
    XOR DX,DX
    DIV BX
    MOV DH,CH
    PUSH DX
    CMP AX,0
    JNE GET_DIGIT
    
    XOR CH,CH
OUTPUT_DW:
    POP AX
    ADD AL,30H
    MOV ES:[DI],AX
    ADD DI,2
    LOOP OUTPUT_DW
    
    POP DI
    POP DX
    POP CX
    POP BX
    POP AX
    
    RET
DW2STR ENDP 

;DX:AX save DD data
;CH save output style
;DI save output string ptr
DD2STR PROC FAR 
    PUSH AX
    PUSH BX
    PUSH DX
    PUSH DI

    MOV BX,10000
    DIV BX
    
    call DW2STR

    XCHG AX,DX
    call DW2STR
    
    POP DI
    POP DX
    POP BX
    POP AX
    
    RET
DD2STR ENDP 

;CH save output style
;DI save output string ptr
;SI save year data ptr
YEAR_PRINT PROC FAR 
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH DI

;CX save string length
;AH save output style
;BX save input string ptr
;DI save output string ptr
    MOV AH,CH
    MOV CX,4
    MOV BX,SI
    
    call STR_PRINT

;DX:AX save DD data
;CH save output style
;DI save output string ptr
    MOV CH,AH
    ADD DI,32
    MOV AX,WORD PTR [SI+5]
    MOV DX,WORD PTR [SI+7]

    call DD2STR

;AX save DW data
;CH save output style
;DI save output string ptr
    ADD DI,32
    MOV AX,WORD PTR [SI+10]
    
    call DW2STR
    
    ADD DI,32
    MOV AX,WORD PTR [SI+13]
    
    call DW2STR
    
    POP DI
    POP DX
    POP CX
    POP BX
    POP AX
    
    RET
YEAR_PRINT ENDP

;AX save loop times
;CH save output style
;DI save output string ptr
;SI save year data start ptr
PIP_PRINT PROC FAR 
    PUSH AX
    PUSH CX
    PUSH DI
    PUSH SI

YEAR_PRINT_LOOP:
    call YEAR_PRINT
    ADD SI,16
    ADD DI,160
    DEC AX
    CMP AX,0
    JNE YEAR_PRINT_LOOP
    
    POP SI
    POP DI
    POP CX
    POP AX
    
    RET
PIP_PRINT ENDP

CODESEG ENDS 
END