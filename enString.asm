;*****************************************************************************************
; Homework
; ========================================================================================
; Write an assembly program that gets a string from the user
; 	encodes it, prints out the encoded string,
; 	decodes it, prints out the decoded string
;*****************************************************************************************
data segment
;--------------------------------- Application messages ----------------------------------
msgUser	db	10,13,"Please enter a string:  ",10,13,endLine
msgEnc	db	10,13,"The encoded string is:  ",10,13,endLine
msgDec	db	10,13,"The decoded string is:  ",10,13,endLine
msgNL	db	10,13,10,13,endLine
;----------------------------------- System definition -----------------------------------
endLine equ	'$'
null	equ	0
TRUE	equ 1
FALSE	equ 0
ENCODE	equ TRUE
DECODE	equ FALSE
;-------------------------------- Application constants ----------------------------------
strLength = 90h
;--------------------------------- Application messages ----------------------------------
inString	db	strLength+1, strLength+2 dup(?), 10,13,'$' ;Storage for the inputed string
tes			db	"a"
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
       
    	PUSH	offset inString			; Read user input
		CALL 	ReadString
		; ================================================================================
EncodeStr:
		PUSH	offset inString[2]		; String to encode
		CALL	EncodeString			; Call encode procedure for encode
		PUSH	DI
		PUSH	BX
		XOR		BX, BX
		LEA		DI, inString[2]
		MOV		BL, BYTE PTR inString[1]
		MOV		BYTE PTR [DI+BX+2],24h
		POP		BX
		POP		DI
		; ================================================================================
PrintEncodedStr:
		PUSH 	offset msgEnc			; Printout the encoding message
		CALL	PrintMsg
		PUSH 	offset inString[2]		; Printout the encoded string
		CALL	PrintMsg
		; ================================================================================
DecodeStr:
		PUSH	offset inString[2]		; String to encode
		CALL	DecodeString			; Call encode procedure for decode;
		PUSH	DI
		PUSH	BX
		XOR		BX, BX
		LEA		DI, inString[2]
		MOV		BL, BYTE PTR inString[1]
		MOV		BYTE PTR [DI+BX+2],24h
		POP		BX
		POP		DI
		; ================================================================================
PrintDecodeStr:
		PUSH 	offset msgDec			; Printout the decoding message
		CALL	PrintMsg
		PUSH 	offset inString[2]		; Printout the decoded string
		CALL	PrintMsg
		; ================================================================================
;------------------------------ Application code end -------------------------------------
Exit:   MOV 	ah,4ch
        INT 	21h
;--------------------------------- Procedure code ----------------------------------------
; Name		: DecodeString
; Task		: Encodes or decodes a string according to input
; Input		: Via stack: string address, mode
; Output	: 
; Destroys	: BX,DX
;-----------------------------------------------------------------------------------------
DecodeString	PROC
DSInit:
		MOV 	BP, SP		; Get the base of the stack
		MOV 	DI, [BP+2]	; DI->str
		
		MOV		CX, DI		
		SUB		CX,	1		; CX=str.len
		; ================================================================================	
			
DSdo:
	; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		PUSH	CX
		PUSH	DI
		PUSH	SI
		; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		LEA		SI, [DI]
		PUSH	SI			; Count the bits in this char
		CALL	CountBits
		; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		POP		SI
		POP		DI
		PUSH	DI
		PUSH	SI
		; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		LEA		SI, [DI]
		PUSH	SI			; Pass the string reff
		PUSH	AX			; Pass the number of roles
		TEST	AX, FALSE	; Pass the mode
		JNP		DSVEven		;
DSVOdd:
		PUSH	TRUE		;
		JMP		DSVRUN
DSVEven:	
		PUSH	FALSE		;
DSVRUN:		
		CALL 	RoleBits
		POP		SI
		POP		DI
		; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		
		POP		CX
	; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		INC		DI
		LOOP	DSdo
		
		RET		2
DecodeString	ENDP
;------------------------------- Procedure code end --------------------------------------







;--------------------------------- Procedure code ----------------------------------------
; Name		: EncodeString
; Task		: Encodes or decodes a string according to input
; Input		: Via stack: string address, mode
; Output	: 
; Destroys	: BX,DX
;-----------------------------------------------------------------------------------------
EncodeString	PROC
ESInit:
		MOV 	BP, SP		; Get the base of the stack
		MOV 	DI, [BP+2]	; DI->str
		
		MOV		CX, DI		
		SUB		CX,	1		; CX=str.len
		; ================================================================================	
			
do:
	; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		PUSH	CX
		PUSH	DI
		PUSH	SI
		; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		LEA		SI, [DI]
		PUSH	SI			; Count the bits in this char
		CALL	CountBits
		; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		POP		SI
		POP		DI
		PUSH	DI
		PUSH	SI
		; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		LEA		SI, [DI]
		PUSH	SI			; Pass the string reff
		PUSH	AX			; Pass the number of roles
		TEST	AX, TRUE	; Pass the mode
		JNP		VEven		;
VOdd:
		PUSH	TRUE		;
		JMP		VRUN
VEven:	
		PUSH	FALSE		;
VRUN:		
		CALL 	RoleBits
		POP		SI
		POP		DI
		; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		
		POP		CX
	; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		INC		DI
		LOOP	do
		
		RET		2
EncodeString	ENDP
;------------------------------- Procedure code end --------------------------------------
;
;
;--------------------------------- Procedure code ----------------------------------------
; Name		: CountBits
; Task		: Counts how many bits are on in a variable
; Input		: Via stack: variable address
; Output	: AX
; Destroys	: AX, CX
;-----------------------------------------------------------------------------------------
CountBits		PROC

CBInit:
		MOV 	BP, SP					; Get the base of the stack
		MOV 	DI, [BP+2]				; DI->str
		MOV		CX,	8
		XOR		AX,	AX
CountLoop:
		ROL		BYTE PTR [DI],1
		ADC 	AX,0
		Loop 	CountLoop
		RET		2
CountBits		ENDP
;------------------------------- Procedure code end --------------------------------------
;--------------------------------- Procedure code ----------------------------------------
; Name		: RoleBits
; Task		: roles the bits according to mode and number of roles to do
; Input		: Via stack: variable address, mode, number of roles
; Output	: AX
; Destroys	: DI,SI,CX
;-----------------------------------------------------------------------------------------
RoleBits		PROC

RBInit:
		MOV 	BP, SP					; Get the base of the stack
		MOV 	DI, [BP+6]				; DI -> str
		MOV 	CX, [BP+4]				; CX = number
		MOV 	SI, [BP+2]				; SI = mode
	
		CMP		SI,	TRUE
		JNE		Left
Right:
		ROR 	BYTE PTR [DI], CL
		JMP		RBEnd
Left:		
		ROL 	BYTE PTR [DI], CL
		JMP		RBEnd
RBEnd:		
		RET		6
RoleBits		ENDP
;------------------------------- Procedure code end --------------------------------------
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
		RET		2	
PrintMsg		ENDP
;------------------------------- Procedure code end --------------------------------------
;--------------------------------- Procedure code ----------------------------------------
; Name		: ReadString
; Task		: Read a string from the console
; Input		: Via stack: message address
; Output	: 
; Destroys	: BX,DX
;-----------------------------------------------------------------------------------------
ReadString		PROC
RSInit:
		MOV 	BP, SP					; Get the base of the stack
		MOV 	DI, [BP+2]				; DI->str
		MOV 	DX, DI					; Read user input
        MOV 	AH, 0Ah
        INT 	21h
		XOR		BX, BX
        MOV		BL, BYTE PTR [DI+1]
		MOV		BYTE PTR [DI+BX+2],24h
		RET		2
ReadString		ENDP
;------------------------------- Procedure code end --------------------------------------
code ends
end start
;*****************************************************************************************