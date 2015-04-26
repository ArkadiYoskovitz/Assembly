data segment
W1      DW  ?

B1      DB  ?

BARR    DB  3 dup (?)

D1      DD  ?

WARR    DW  3 dup (?)

data ends


sseg segment stack
DW 100 dup (?)
sseg ends

code segment

assume cs:code,ds:data,ss:sseg

start:  MOV ax,data
MOV ds,ax

MOV W1, offset W1
MOV B1, offset B1
MOV BARR[0], offset BARR
MOV BARR[1], offset BARR+1
MOV BARR[2], offset BARR+2

MOV WARR[0], offset WARR
MOV WARR[2], offset WARR+2
MOV WARR[4], offset WARR+4

exit:   mov ah,4ch
int 21h

code ends

end start
