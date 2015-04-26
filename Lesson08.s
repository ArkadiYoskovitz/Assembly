//
//  Lesson08.asm
//  
//
//  Created by Arkadi Yoskovitz on 17/12/14.
//
//
data segment
    A       DB  4
    B       DB  40
    C       DB  -14
    Result  DD  ?
data ends

sseg segment stack
    DW  100 dup (?)
sseg ends

code segment

assume cs:code,ds:data,ss:sseg

start:  MOV ax,data
        MOV ds,ax
        MOV al,B
        IMUL AL     ;   AX=B^2

        CWD            ; EXTEND  TO DOUBLE
        MOV   BX,AX
        MOV   DI,DX  ;  SAVE  IN    DI:BX
        MOV   AL,4
        IMUL  A
        MOV    CX,AX
        MOV    AL ,C
        CBW
        IMUL  CX      ;  AX:DX = 4*A*C
        SUB BX,AX
        SBB DI,DX
        MOV WORD PTR RESULT ,BX
        MOV WORD PTR RESULT[2] ,DI

exit:   MOV ah,4ch
        int 21h

code ends

end start

;Write the following program:
;sum = sum - (num1 + num 2) - num3
;sum = 1000h
;num1= 100h
;num2= 300h
;num3= 200h
