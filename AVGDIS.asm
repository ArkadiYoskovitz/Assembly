data segment
ARR     DB  40,30,37,56,90
N 		EQU 5
data ends

sseg segment stack
DW 100 dup (?)
sseg ends

code segment

assume cs:code,ds:data,ss:sseg

start:  mov ax,data
mov ds,ax

PUSH OFFSET ARR
PUSH N
CALL CALC_AVG

exit:   mov ah,4ch
int 21h

CALC_AVG PROC

MOV BP, SP; Get the base of the stack in order to know the arraySizeLocation
MOV CX, [BP+2]; put the array size into the loop index
MOV DI, [BP+4]; put the array location into reg

MOV AL, DS:[DI];
MOV AH, 0h;
INC DI;
DEC CX;

Loop_ARRAY_SUM:
ADD AL, DS:[DI];
ADC AH, 0h;
INC DI;
LOOP Loop_ARRAY_SUM

MOV DX, 0h;
MOV CX, [BP+2];
DIV CX; calculated the AVG, currently in AX

MOV DI, [BP+4];

Loop_CHANGE_VALUE:

CMP AL,DS:[DI]; AVG > DATA jump to Else
JG AVG_GTE_DATA

SUB DS:[DI],AL; DATA = DATA - AVG
JMP CONT;

AVG_GTE_DATA:
MOV AH, AL;
SUB AH, DS:[DI]; DATA = AVG - DATA
MOV DS:[DI], AH;

CONT:
INC DI;
LOOP Loop_CHANGE_VALUE

RET
CALC_AVG ENDP

code ends
end start