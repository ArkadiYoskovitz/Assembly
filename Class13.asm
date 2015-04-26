N      EQU 11
STRLEN EQU 20

data segment
    ILLEGAL	DB	‘!@#$%^&*><:’;
    STRING  DB	‘ABCDFRJKL%MW#908$!Pk‘;
    RESULT  DB  0;
data ends

sseg segment stack
	DW 100 dup (?)
sseg ends

code segment

assume cs:code,ds:data,ss:sseg

start:  
		mov ax,data
        mov ds,ax

        PUSH OFFSET ILLEGAL;
        PUSH OFFSET STRING;
        CALL CHECK_REG;

        ADC  RESULT,0h;

exit:   mov ah,4ch
        int 21h

CHECK_REG PROC

        MOV bp,sp

        MOV SI, [BP+2] ; SI -> ILEGAL
        MOV DI, [BP+4] ; DI -> STRING


        MOV cx,STRLEN;
OUTL:   MOV al,[SI];

        MOV BX,N;
        MOV DI, [BP+4] ; DI -> STRING

IN_L:   CMP al,[DI];
        JE no;
        INC DI;
        DEC BX;

        JNZ IN_L;

        INC SI;

        LOOP OUTL;

        JMP yes;

 no:    STC;
        REN 4;

yes:    CLC;
        REN 4;

CHECK_REG ENDP


CHECK_STR PROC

        MOV 	BP,	SP

        MOV		SI, [BP+2] 	; SI -> ILEGAL
        MOV		DI, [BP+4] 	; DI -> STRING

        MOV		cx, STRLEN	;
OUTL2:	
		MOV		al, [SI]	;

        PUSH	CX 			;
        MOV		CX, N		;
IN_L2:
        CMP 	al,	[DI]	;
        JE 		no2			;
        INC 	DI			;
        LOOP 	IN_L2		;

        POP 	CX			;
        INC 	SI			;
        LOOP 	OUTL2		;

        JMP 	yes2		;

no2:
		POP 	CX			;
        STC					;
        REN 4				;
yes2:    
		CLC					;
        REN 4				;

CHECK_STR ENDP

code ends
end start