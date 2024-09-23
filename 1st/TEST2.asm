.model small
.data
MSG1 DB "Hello World$",0dh,0ah,"$"
MSG2 DB "Good Bye$",0dh,0ah,"$"

.code
MAIN:
MOV AX,@data
MOV DS,AX 

LEA DX,MSG1
MOV AH,9 
INT 21H 

MOV AX,4C00H 
INT 21H 

END MAIN 