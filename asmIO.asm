;*****************************************************************************************
; Homework
; ========================================================================================
; Write an assembly program that gets the username and the password from the user
; user name length 5 chars
; password  length 5 chars
; allowed number of tries 3
; if the password is correct showa messeg, else show error and promp for more input
; if the user fails three times show final error message
;*****************************************************************************************
data segment
msg1	db	10,13,"Please enter char:  ",10,13,'$'            
msg2	db	10,13,"Please enter digit: ",10,13,'$' 
error	db	10,13,"WRONG INPUT!: "		,10,13,'$'

tav db ?
newline db  10,13,'$' 
data ends
;*****************************************************************************************
sseg segment stack
  DW 100 dup (?)
sseg ends
;*****************************************************************************************
code segment
assume cs:code,ds:data,ss:sseg

start:  mov ax,data
        mov ds,ax
        
;----------------------------------- Initial user input ----------------------------------
again:   
		mov dx,offset msg1 ; Print out the char prop massage to the user
        mov ah,9
        int 21h
        mov ah,1
        int 21h
        mov tav,al
        mov dx,offset msg2 ; Print out the digit prop massage to the user
        mov ah,9
        int 21h 
        mov ah,1
        int 21h  
        cmp al,'0'
        jb  err
        cmp al,'9'
        ja  err
        sub al,30h
        cbw
        mov cx,ax

;-------------- Outer loop - responsable for printing out the control characters ---------
lula:   push cx
        mov dx,offset newline
        mov ah,9
        int 21h
;---------------------------------- Inner loop - print the chars in the line -------------
inl:    mov dl,tav 
        mov ah,2
        int 21h
        loop inl
        pop cx
        loop lula
        
        mov ah,7
        int 21h
		jmp exit

;---------------------------------- Handel the error message -----------------------------
err:    mov dx,offset error
        mov ah,9
        int 21h
         
        mov ah,7
        int 21h
        
        mov ax,0
        int 10h
        jmp again
        
;---------------------------------- End of the program -----------------------------------
exit:   mov ah,4ch
        int 21h

;-----------------------------------------------------------------------------------------
exit:   mov ah,4ch
        int 21h

code ends
end start
;************************************************