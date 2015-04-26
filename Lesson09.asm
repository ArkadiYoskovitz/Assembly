data segment

N equ 4
string db 'A','b','6','D'

data ends

sseg segment stack
  DW 100 dup (?)
sseg ends

code segment

assume cs:code,ds:data,ss:sseg

start:  mov ax,data
        mov ds,ax
         
        mov cx,N
        mov bx,offset string

Next:
        CMP byte ptr [bx],'A'
        JB  Continue
        CMP byte ptr [bx],'Z'
        JMP Compute

        CMP byte ptr [bx],'a'
        JB  Compute
        CMP byte ptr [bx],'z'
        JMP Continue

Compute:
        xor byte ptr [bx] , 20h

Continue:
        inc bx
        loop next

exit:    mov ah,4ch
         int 21h

code ends
end start


