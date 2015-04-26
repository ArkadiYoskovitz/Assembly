data segment

SIZE    = 100

ARRAY   db   92, -101, 68, 23, 14, -15, 158, 45, 82, -37, 89, 78
sum     dd 0

average db ?

data ends

sseg segment stack
  DW 100 dup (?)
sseg ends

code segment

assume cs:code,ds:data,ss:sseg

start:  mov ax,data
        mov ds,ax

init:
        mov si,offset ARRAY
        mov bx, SIZE

do:     mov al, [si]
        cbw
        add word ptr sum  , ax
        jnc cont
        inc word ptr sum+2

cont:   dec bx
        inc si

        cmp bx, 0
        je avg

        jmp do

avg:    mov bx, SIZE
        mov ax, word prt sum
        mov dx, word prt sum + 2

        idiv bx
        mov average, al

exit:   mov ah,4ch
        int 21h

code ends
end start


