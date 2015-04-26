data segment
Num1    DW  100h
Num2    DW  300h
Num3    DW  20h
sum     DD  1000h
data ends


sseg segment stack
    DW 100 dup (?)
sseg ends

code segment

assume cs:code,ds:data,ss:sseg

start:  MOV ax,data
        MOV ds,ax

MOV ax              , word ptr num1 ;
ADD ax              , word ptr num2 ;
SBB word ptr sum + 2, 0h            ;
SUB word ptr sum    , ax            ;
MOV ax              , word ptr num3 ;
SUB word ptr sum    , ax            ;
SBB word ptr sum + 2, 0h            ;



exit:   mov ah,4ch
        int 21h

code ends

end start

;Write the following program:
;sum = sum - (num1 + num 2) - num3
;sum = 1000h
;num1= 100h
;num2= 300h
;num3= 200h
