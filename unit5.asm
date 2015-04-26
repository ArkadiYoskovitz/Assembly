data segment
    
    a db 25h
    b db 29h
    c db 17h
    d db 23h
    min db ? 
    max db ?
    

data ends

sseg segment stack
    dw   128  dup(0)
sseg ends

code segment
assume ss:sseg,cs:code,ds:data

start:  mov ax,data
        mov ds,ax
                    
        mov al, a
        mov bl, a            
                        
        cmp al, b
        jge after1
        mov al, b
        
after1: cmp bl, b
        jle after2
        mov bl,b 
               
after2: cmp al, c
        jge after3
        mov al, c        
after3: cmp bl, c
        jle after4
        mov bl, c
                
after4: cmp al, d
        jge after5
        mov al, d                
after5: cmp bl, d
        jle after6
        mov bl, d
        
after6: mov max, al
        mov min, bl                                         
        

exit:  mov ax, 4c00h
        int 21h  

code  ends

end start
