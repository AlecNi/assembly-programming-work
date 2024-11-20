ASSUME CS:CODESEG

PUBLIC PIP_OP

CODESEG SEGMENT 

;BX save DD data ptr
;CX save DW data ptr
;AX output div answer
DIVOP PROC FAR 
    PUSH BX
    PUSH DX

    MOV AX,WORD PTR [BX]
    MOV DX,WORD PTR [BX+2]
    
    XCHG BX,CX
    MOV CX,[BX]
    
    DIV CX
    XCHG BX,CX
    
    POP DX
    POP BX
    
    RET
DIVOP ENDP 

;deal one year data
;BX save DD data ptr
;CX save DW data ptr
;SI save year data ptr
;DI save output array ptr
YEAROP PROC FAR 
    PUSH AX
    PUSH CX
    PUSH SI
    PUSH DI

    PUSH CX
    MOV CX,4
    CLD
    REP MOVSB
    POP CX
    
    INC DI
    MOV AX,WORD PTR [BX]
    MOV ES:[DI],AX
    MOV AX,WORD PTR [BX+2]
    MOV ES:[DI+2],AX
    
    ADD DI,5
    XCHG BX,CX
    MOV AX,WORD PTR [BX]
    MOV ES:[DI],AX
    XCHG BX,CX

    ADD DI,3
    call DIVOP
    MOV ES:[DI],AX

    POP DI
    POP SI
    POP CX
    POP AX
    
    RET
YEAROP ENDP 

;deal all data
;AX save loop times
;BX save DD data start ptr
;CX save DW data start ptr
;SI save year data start ptr
;DI save output array start ptr
PIP_OP PROC FAR 
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH SI
    PUSH DI

YEAR_LOOP:
    call YEAROP
    ADD BX,4
    ADD CX,2
    ADD SI,4
    ADD DI,16
    DEC AX
    CMP AX,0
    JNE YEAR_LOOP
    
    POP DI
    POP SI
    POP CX
    POP BX
    POP AX
    
    RET
PIP_OP ENDP 

CODESEG ENDS 
END