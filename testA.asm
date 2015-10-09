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
;----------------------------------- System definition -----------------------------------
endLine 	equ	'$'
NULL		equ	0
InteraptV	equ 21h
ENTERED		equ 13
TRUE		equ 1
FALSE		equ 0
;--------------------------------- Application messages ----------------------------------
msgAppStart	db	"Application began"								, 10,13,endLine;
msgAppEnd	db	"Application Ends"								, 10,13,endLine;
msgNLine	db	10,13,endLine
;------------------------------ Application hint messages --------------------------------

;--------------------------------- File Open messages ------------------------------------
;-------------------------------- Application constants ----------------------------------
positiveOne	equ 1
negativeOne	equ -1
zero		equ 0
;-------------------------------- Application variables ----------------------------------

D1	DW 	190h
D2	DW	 90h;

result	DW ?

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
initProgram :
			
		push D1;
		push D2;
		CALL CompDate;

		POP result;

EndProgram:
			
;------------------------------ Application code end -------------------------------------
Exit:   MOV 	ah,	4ch
        INT 	21h
             
;--------------------------------- Procedure code ----------------------------------------
; Name		: CompDate
; Task		: Compere two dates in the following format: year-7,month-4,day-5
; Input		: Via stack: tow dates
; Output	: if D1 < D2 return -1, if D1 > D2 return 1, else return 0;
; Destroys	: AX,BX,CX,DX
;-----------------------------------------------------------------------------------------
CompDate		PROC
CompDateInit:
		MOV 	BP, SP					; Get the base of the stack
		MOV 	DI, [BP+2]				; DI->D2
		MOV 	SI, [BP+4]				; SI->D1

		MOV 	AX, FALSE;
		MOV 	BX, FALSE;
		MOV 	CX, FALSE;
		MOV 	DX, FALSE;		

CompDateCalcFirst:
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Calculate year
		MOV 	AX,	[DI]				; AX = D2
		MOV		CX, 09h
		SHL	 	AX,	CL
		SHR		AX, CL					; AX = YEAR D2
		
		MOV 	BX,	[SI]				; AX = D1
		MOV		CX, 09h
		SHL	 	BX,	CL
		SHR		BX, CL					; AX = YEAR D1
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Calculate year END
		CMP		AX, BX
		JA		returnValueM1;
		JB		returnValueP1;
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Calculate month
		MOV		CX, 05h
		
		MOV 	AX,	[DI]				; AX = D2
		MOV 	BX,	[SI]				; AX = D1
				
		SHL	 	AX,	CL
		SHR		AX, CL					; AX = month D2 not final
		SHL	 	BX,	CL
		SHR		BX, CL					; AX = month D1 not final
		
		MOV		CX, 07h
		
		SHR 	AX,	CL
		SHL		AX, CL					; AX = month D2  final
		SHR 	BX,	CL
		SHL		BX, CL					; BX = month D1  final
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Calculate month END				
		CMP		AX, BX
		JA		returnValueM1;
		JB		returnValueP1;
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Calculate day		
		MOV		CX, 0Bh

		MOV 	AX,	[DI]				; AX = D2
		SHR	 	AX,	CL
		SHL		AX, CL					; AX = YEAR D2
		
		MOV 	BX,	[SI]				; AX = D1
		SHR	 	BX,	CL
		SHL		BX, CL					; AX = YEAR D1
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Calculate day 
		CMP		AX, BX
		JA		returnValueM1;
		JB		returnValueP1;
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Calculate day end		

returnValue00:
	MOV		WORD PTR [bp+4],	zero;
	JMP		CompDateEND;


returnValueP1:
	MOV		WORD PTR [bp+4],	positiveOne;
	JMP		CompDateEND;
returnValueM1:
	MOV		WORD PTR [bp+4],	negativeOne;
	JMP		CompDateEND;

CompDateEND:
		RET		2
CompDate		ENDP
;*****************************************************************************************
;
;------------------------------- Procedure code end --------------------------------------

code ends
end start
;*****************************************************************************************