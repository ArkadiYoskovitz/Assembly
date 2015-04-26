;*****************************************************************************************
; Homework
; ========================================================================================
; Write an assembly program reads the a user input of a hexadecimal address
; The program must move the hex value of the input into the AX register and then
; Prints out the 2nd complete of the value
;*****************************************************************************************
data segment
;--------------------------------- Application messages ----------------------------------
msgUser	db	10,13,"Please enter a hexadecimal address",10,13,endLine
;----------------------------------- System definition -----------------------------------
endLine equ	'$'
null	equ	0
ENTERED	equ 13
TRUE	equ 1
FALSE	equ 0
;-------------------------------- Application constants ----------------------------------
inputSize	=	6
;-------------------------------- Application variables ----------------------------------
input	db	inputSize+1, inputSize+2 dup(?), 10,13,'$' ;Storage for the inputed address
result	db	inputSize+1, inputSize+2 dup(?), 10,13,'$' ;Storage for the inputed address
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
		; ================================================================================
PrompUser:
		PUSH 	offset msgUser			; Prop for user name
		CALL	PrintMsg
        
        MOV 	dx, offset input		; Read user input
        MOV 	ah, 0Ah
		INT 	21h
		; ================================================================================
AppLogic:
		LEA		SI,	input[2]			; SI->Input
		PUSH	SI
		XOR		BX, BX
		ADD		BL, input[1]
		PUSH	BX
		CALL	RegMov
		; ================================================================================		
MsgResult:
		PUSH 	offset result			; Show game message
        CALL	PrintMsg
;------------------------------ Application code end -------------------------------------
Exit:   MOV 	ah,	4ch
        INT 	21h

;--------------------------------- Procedure code ----------------------------------------
; Name		: PrintMsg
; Task		: Print a message to the screen 
; Input		: Via stack: message address
; Output	: 
; Destroys	: DX
;-----------------------------------------------------------------------------------------
PrintMsg		PROC
PMInit:
		MOV 	BP, SP					; Get the base of the stack
		MOV 	DI, [BP+2]				; DI->str
		MOV 	DX, DI					; Show successful login message
        MOV 	AH, 9
		INT 	21h
		RET	
PrintMsg		ENDP
;--------------------------------- Procedure code ----------------------------------------
; Name		: RegMov
; Task		: Move a hex address from string to register
; Input		: Via stack: string address, string length
; Output	: AX
; Destroys	: DX
;-----------------------------------------------------------------------------------------
RegMov			PROC
RMInit:
		MOV 	BP, SP					; Get the base of the stack
		MOV 	DI, [BP+2]				; DI->str
		MOV		CX, [BP+4]				; CX = strLen
		XOR		AX,	AX					; Clear result location

PRLoop:		
		MOV		DL,	BYTE PTR [DI]		; get char from string
		CMP		DL, 40h
		JB		PRMask
		ADD		DL, 9h
PRMask:				
		AND		DX, 000fh
		
Move:	MOV		BL,	10h
		MUL		BL
		
		ADD		AX, DX
		
		Loop PRLoop
RMEnd:
		RET		2
RegMov			ENDP
;------------------------------- Procedure code end --------------------------------------

code ends
end start
;*****************************************************************************************