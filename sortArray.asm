;// Write a function that recieves and array of signed words, and its length

N   EQU 10

data segment

ARRAY DX 10,-10,19,78,85,-97,11,41,74,-3;

data ends


sseg segment stack

DW 100 dup (?)

sseg ends



code segment

assume cs:code,ds:data,ss:sseg

start:  mov ax,data
        mov ds,ax

        PUSH OFFSET ARRAY;
        PUSH N;
        CALL ARRAY_SORT;

exit:   mov ah,4ch
        int 21h


ARRAY_SORT PROC

        MOV bp,sp

        MOV SI, [BP+2] ; SI -> ARRAY
        MOV CX, [BP+4] ; CX = N

OUT_L:  MOV AX,[SI]
        PUSH CX
        DEC CX
        JCXZ SOFP

        MOV DI,SI
        ADD DI,2
IN_L:   CPM AX,[DI]
        JLE cont

swap:   XCHG AX,[DI]
        MOV  [SI],AX
cont:   ADD DI, 2h
        LOOP IN_L

        ADD SI,2h;
        POP CX
        LOOP OUT_L

SOFP:   POP CX
        ret 4

ARRAY_SORT ENDP

code ends
end start






