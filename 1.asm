NULL equ 0

data segment

str1   db   "HELLO WORLD",NULL

data ends

sseg segment stack
  DW 100 dup (?)
sseg ends

code segment

assume cs:code,ds:data,ss:sseg

start:  mov ax,data
        mov ds,ax

init:   mov si,offset str1

do:     cmp byte ptr [si], NULL
        je stop
        inc si
        jmp do

stop:   dec si

        mov di, offset str1

next:   cmp di, si
        jae exit
        mov al, [di]; exchange the values
        mov ah, [si]
        xchg byte ptr [di], ah
        xchg byte ptr [si], al
        inc di
        dec si
        jmp next

exit:   mov ah,4ch
        int 21h

code ends
end start


