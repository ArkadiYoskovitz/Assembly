;*****************************************************************************************
; Homework
; ========================================================================================
; Write an assembly program that 
; Select:
; case 01: Call open		file Function
; case 02: Call close		file Function
; case 03: Call create new	file Function
; case 04: Call Add text to EOF	 Function
; case 05: Call Read text from file and show on screen Function
; case 00: Call End of Program 
;*****************************************************************************************
data segment
;--------------------------------- Application messages ----------------------------------
msgAppStart	db	"Application began"								, 10,13,endLine;
msgAppEnd	db	"Application Ends"								, 10,13,endLine;
msgNLine	db	10,13,endLine
;------------------------------ Application hint messages --------------------------------

;--------------------------------- File Open messages ------------------------------------
;----------------------------------- System definition -----------------------------------
endLine 	equ	'$'
NULL		equ	0
InteraptV	equ 21h
ENTERED		equ 13
TRUE		equ 1
FALSE		equ 0
;-------------------------------- Application constants ----------------------------------
;-------------------------------- Application variables ----------------------------------

ROW	db	FFh;
COL	db	FFh;

data ends
;*****************************************************************************************
sseg segment stack
  DW 100 dup (?)
sseg ends
;*****************************************************************************************
code segment
;------------------------------ Application initialization -------------------------------
assume cs:code,ds:data,ss:sseg

Start:
		MOV 	AX, DATA
        MOV 	DS, AX       
;-------------------------------- Application code ---------------------------------------
initProgram:
			CALL	PrintAppStart
DOMainLoop:

EndProgram:
			CALL	PrintAppEnd
;------------------------------ Application code end -------------------------------------
Exit:   MOV 	ah,	4ch
        INT 	21h
        
;--------------------------------- Procedure code ----------------------------------------
; Name		: PrintAppStart
; Task		: Print application start message
; Input		: 
; Output	: 
; Destroys	: 
;-----------------------------------------------------------------------------------------
PrintAppStart	PROC
PASInit:
		MOV 	BP, SP					; Get the base of the stack
PASFunc:
		PUSH 	offset msgAppStart		; Print application start message
		CALL	PrintMsg
PASEnd:
		RET		
PrintAppStart	ENDP
;--------------------------------- Procedure code ----------------------------------------
; Name		: PrintAppEnd
; Task		: Print application end message
; Input		: 
; Output	: 
; Destroys	: 
;-----------------------------------------------------------------------------------------
PrintAppEnd	PROC
PAEInit:
		MOV 	BP, SP					; Get the base of the stack
		
PAEFunc:
		PUSH 	offset msgAppEnd		; Print application end message
		CALL	PrintMsg
		
PAEEnd:
		RET		
PrintAppEnd	ENDP       
;--------------------------------- Procedure code ----------------------------------------
; Name		: PrintMsg
; Task		: Print a message to the screen 
; Input		: Via stack: message address
; Output	: 
; Destroys	: DX
;-----------------------------------------------------------------------------------------
PrintMsg		PROC
PMsgInit:
		MOV 	BP, SP					; Get the base of the stack
		MOV 	DI, [BP+2]				; DI->str
		MOV 	DX, DI					; Show successful login message
        MOV 	AH, 9
		INT 	InteraptV
		RET		2
PrintMsg		ENDP
;*****************************************************************************************
;
;------------------------------- Procedure code end --------------------------------------

code ends
end start
;*****************************************************************************************