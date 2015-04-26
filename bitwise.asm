data segment
;--------------------------------- Application messages ----------------------------------
;msgUser	db	10,13,"Please enter username:  ",10,13,endLine
;msgPass	db	10,13,"Please enter password:  ",10,13,endLine
;----------------------------------- System definition -----------------------------------
;endLine equ	'$'
;null	equ	0
;ENTERED	equ 13
;TRUE	equ 1
;FALSE	equ 0
;-------------------------------- Application constants ----------------------------------
;-------------------------------- Application variables ----------------------------------
ARRAY	dw	1234h, 9876h, 1234h, 9876h, 1234h, 9876h, 1234h, 9876h, 1234h, 9876h,;
ASIZE	db	10D;
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


		LEA		SI,	ARRAY
		MOV		CX,	0
		MOV		CL, ASIZE
DO:		PUSH 	CX
		PUSH 	SI
		CALL 	ClearSides
		POP		CX
		INC		SI
		INC		SI
		LOOP	DO
		
;------------------------------ Application code end -------------------------------------
Exit:   MOV 	ah,	4ch
        INT 	21h

;--------------------------------- Procedure code ----------------------------------------
; Name		: ClearSides
; Task		: Clears the word sides
; Input		: 
; Output	: 
; Destroys	: DI,CX
;-----------------------------------------------------------------------------------------
ClearSides		PROC
PMInit:
		MOV 	BP, SP					; Get the base of the stack
		MOV 	DI, [BP+2]				; DI->str
		
		MOV 	CL,	4h
		SHL		WORD PTR [DI], CL
		SHL 	CL,	1
		SHR		WORD PTR [DI], CL
		SHR 	CL,	1		
		SHL		WORD PTR [DI], CL
		RET	
ClearSides		ENDP
;------------------------------- Procedure code end --------------------------------------

code ends
end start
;*****************************************************************************************