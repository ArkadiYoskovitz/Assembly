;=======================================================
data segment

ARRAY   db  1,2,9,6,7,8,4,3
LEN     equ 8

data ends
;=======================================================
sseg segment stack
DW 100 dup (?)
sseg ends
;=======================================================

code segment

assume cs:code,ds:data,ss:sseg
;-------------------------------------------------------
start:  mov ax,data
        mov ds,ax
;-------------------------------------------------------

        push offset ARRAY
        push LEN
        call ARRAYSORT
;-------------------------------------------------------
exit:   mov ah,4ch
        int 21h

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++
ARRAY_SORT PROC

        MOV BP, SP     ; Save the stack pointer

        MOV SI, [BP+4] ; SI -> ARRAY[0]
        MOV DI, [BP+2] ; DI = LEN
        ADD DI, SI
        DEC DI         ; DI-> ARRAY[N-1]

NEXT:   CMP SI,DI
        JAE RETURN

        TEST BYTE PTR [SI],1h
        JZ   N_EVEN

        TEST BYTE PTR [DI],1h
        JNZ   N_ODD

swap:   MOV  AL,[SI]
        XCHG AL,[DI]
        MOV  [SI],AL

        INC SI
        DEC DI
        JMP NEXT


N_EVEN: INC SI
        JMP NEXT

N_ODD:  DEC DI
        JMP NEXT

RETURN: RET 4

ARRAY_SORT ENDP
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++

code ends
end start
;=======================================================