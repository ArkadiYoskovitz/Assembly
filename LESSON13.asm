data segment

    Math            db  67,87,54,78,27,70,74,90,54,65
    History         db  63,61,62,74,85,90,71,62,98,77
    English         db  63,56,94,48,80,57,73,49,83,72

    BEST_STUDENT    db  ?
    BEST_AVG        db  ?

    LEN = 10

data ends

sseg segment stack
DW 100 dup (?)
sseg ends

code segment

assume cs:code,ds:data,ss:sseg

start:  mov ax,data
        mov ds,ax

        mov cx, LEN
xor ax, ax  ; ax max_total
xor bx, bx  ; index of student

do:  xor dx, dx   ; tmp total
        add dl, Math[bx]
        add dl, History[bx]
        adc dh, 0
        add dl, English[bx]
        adc dh, 0; dx is sum of student bx marks

        cmp dx, ax
        jbe cont

        mov ax, dx  ; save new max
        mov BEST_STUDENT, bl ; save the index of the max avg grade

cont:   inc bx
        loop do

        mov dl, 3
        div dl

        mov BEST_AVG, al

exit:   mov ah,4ch
        int 21h

code ends
end start


