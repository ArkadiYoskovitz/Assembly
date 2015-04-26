;*****************************************************************************************
data segment
N=12    
MSG1 DB 10,13,"PLEASE ENTER FILE NAME"		 ,10,13,'$'
MSG2 DB 10,13,"ERROR CREATING FILE"			 ,10,13,'$'
MSG3 DB 10,13,"FILE WAS CREATED SUCCESSFULLY",10,13,'$'

;FNAME DB "KUKU.DOC"

 
FILENAME DB N,?,N+1 DUP('$')
data ends
;*****************************************************************************************
sseg segment stack
  DW 100 dup (?)
sseg ends
;*****************************************************************************************
code segment
;------------------------------ Application initialization -------------------------------
assume cs:code,ds:data,ss:sseg

start:
		MOV	AX,data
        MOV ds,AX
;-------------------------------- Application code ---------------------------------------     
        LEA	DX,MSG1			; Prepare promp
        MOV AH,9			; Prepare promp
        INT 21H				; Promp the user to enter a file name 
        
        LEA DX,FILENAME		; Prepare to read file name
        MOV AH,10			; Prepare to read file name
        INT 21H				; Read file name from user input
        
        MOV AH,3CH			; Prepare to create new file
        LEA DX,FILENAME[2]	; Put file path in DX register
        MOV BL,FILENAME[1]	; Get file path length 
        MOV BH,0			; Prepare fix
        MOV FILENAME[BX+2],0; Put a fix ending to the file path (needs to be NULL end)
        MOV CX,0			; Prepare file attribute
        INT 21H				; Create file
        JC  ERROR			; If creation failed show error
        
        LEA DX,MSG3			; Prepare success massage
        JMP PRINT			; Jump to print massage
ERROR:
		LEA DX,MSG2 		; Prepare error massage
PRINT:  
		MOV AH,9			; Prepare to print massage
        INT 21H				; Show success massage
;------------------------------ Application code end -------------------------------------
exit:   
		MOV	AH,4ch
        INT 21h
code ends
end start
;*****************************************************************************************