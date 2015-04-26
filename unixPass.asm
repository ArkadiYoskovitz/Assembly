;*****************************************************************************************
; Homework
; ========================================================================================
; Write an assembly program that gets the username and the password from the user
; user name length 5 chars
; password  length 5 chars
; allowed number of tries 3
; if the password is correct show a messeg, else show error and promp for more input
; if the user fails three times show final error message
;*****************************************************************************************
data segment
;--------------------------------- Application messages ----------------------------------
msgUser	db	10,13,"Please enter username:  ",10,13,endLine
msgPass	db	10,13,"Please enter password:  ",10,13,endLine
msgErr	db	10,13,"...",10,13,"WRONG INPUT!",10,13,endLine
msgLog	db	10,13,"...",10,13,"Reciving transmission...",10,13,"Transmission recived...",10,13,"System connected!",10,13,endLine
msgGame db	"Welcome commander, which capital whould you like to destroy?",10,13,endLine
msgG1	db	10,13,"1. London",10,13,"2. Paris",10,13,"3. Berlin",10,13,"4. Moscow",10,13,"5. Jerusalem",10,13,"6. Woshingtown DC",10,13,endLine
msgG2	db	10,13,"You have selected to destroy Woshingtown DC",10,13,"...",10,13,"...",10,13,"Lunching missiles...",10,13,endLine
msgLoss	db	10,13,"...",10,13,"You entred wrong password too many times, Looooser!",10,13,endLine
;----------------------------------- System definition -----------------------------------
endLine equ	'$'
null	equ	0
ENTERED	equ 13
TRUE	equ 1
FALSE	equ 0
MAX_IN	equ	7
;-------------------------------- Application constants ----------------------------------
userLen	=	6
passLen	=	6
;-------------------------------- Application variables ----------------------------------
user	db	"arkadi",null
pass	db	"arkadi",null
flagU	db	?
flagP	db	?
tries	db	2
inChar	db	?
;------------------------------------- Temp variables ------------------------------------
;tempU	db	TRUE
;tempP	db	FALSE
;--------------------------------- Application messages ----------------------------------
inUser	db	userLen+1, userLen+2 dup(?), 10,13,'$' ;Storage for the inputed user name
inPass	db	passLen+1, passLen+2 dup(?), 10,13,'$' ;Storage for the inputed password
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
		PUSH 	offset msgUser		; Prop for user name
		CALL	PrintMsg
        
        MOV 	dx, offset inUser		; Read user input
        MOV 	ah, 0Ah
		INT 	21h
		; ================================================================================        
PrompPass:
		PUSH 	offset msgPass			; Prop for password
		CALL	PrintMsg
		
		MOV		bx, 2					; create a pointer
do_read:
        
ReadChar:        
        MOV 	ah, 7					; Read char as secure --> 7,Read String --> 0Ah,
		INT		21h
		MOV 	inChar,al				; 	input = getchar();
		MOV		byte ptr inPass[bx], al		; 	inputString[i] = input;
		INC 	BX						;	i++;

while_M:	
		CMP 	inChar,ENTERED			; } while (input != ENTERED)
		JNE		do_read
		; ================================================================================
CalcFlag:
		PUSH 	offset user				; Passing user array via stack
		PUSH 	offset inUser[2]		; Passing user input array via stack
		PUSH 	offset flagU			; Passing flag  via stack
		CALL 	CompareArrays			; bool a = inUser==user;
		
		PUSH 	offset pass				; Passing user array via stack
		PUSH 	offset inPass[2]		; Passing user input array via stack
		PUSH 	offset flagP			; Passing flag  via stack
		CALL 	CompareArrays			; bool b = inPass==pass;
		; ================================================================================
AppLogic:
		MOV 	dh, flagU				; prepare flags for calculation
		MOV 	dl, flagP				;
		
		AND		dl, dh					; Compare the two registers (that contain flags)
		CMP 	dl, TRUE				; if (a & b) 
		JE		MsgLogin				;	goto MsgLogin;
		
		CMP 	tries,null				; if (tries != 0)
		JNE		MsgError				;	goto MsgError;
										; else 
		JMP		MsgLooooser				;	goto MsgLooooser;
		; ================================================================================
MsgError:
		PUSH 	offset msgErr			; Show error message
		CALL	PrintMsg
        DEC		tries
		JMP		PrompUser
		; ================================================================================
MsgLogin:
		PUSH 	offset msgLog			; Show successful login message
		CALL	PrintMsg
        
		PUSH 	offset msgGame			; Show game message
		CALL	PrintMsg
        
		PUSH 	offset msgG1			; Show game message
		CALL	PrintMsg
        		
		MOV 	ah, 7					; Wait for user input
		INT 	21h
		
		PUSH 	offset msgG2			; Show game message
        CALL	PrintMsg
        
        JMP 	Exit					; Go to program end
		; ================================================================================
MsgLooooser:
		PUSH 	offset msgLoss			; Show failed to login message
		CALL	PrintMsg
		JMP 	Exit					; Go to program end
		; ================================================================================
;------------------------------ Application code end -------------------------------------
Exit:   MOV 	ah,4ch
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
; Name		: CompareArrays
; Task		: Compare two byte arrays which end with Null
; Input		: Via stack: first array address, second array address , result address
; Output	: Comparison result in result variable address
; Destroys	: BX,DX
;-----------------------------------------------------------------------------------------
CompareArrays	PROC
ProcInit:
		MOV BP, SP						; Get the base of the stack
		MOV DI, [BP+6]					; DI->str1
		MOV SI, [BP+4]					; SI->str2
		MOV BX, [BP+2]					; BX->result

BasicTest:
		CMP byte ptr [DI],null			; Test first  string, we shouldn't run if its null
		JE	RetFalse
		
		CMP byte ptr [SI],null			; Test second string, we shouldn't run if its null
		JE	RetFalse
do:		
		MOV dh,byte ptr [DI]			; Read char from str1
		MOV dl,byte ptr [SI]			; Read char from str2
		CMP dh,dl						; Compare the strings
		JNE	RetFalse
		INC DI							; Move pointer, *di++
		INC SI							; Move pointer, *di++
while_P:
		CMP byte ptr [DI],null			; Check for string end
		JNE	do
		jmp RetTrue
		
RetTrue:
		MOV byte ptr [BX], TRUE
		JMP procEnd
		
RetFalse:
		MOV byte ptr [BX], FALSE
		JMP procEnd

procEnd:
		ret	4
CompareArrays	ENDP
;------------------------------- Procedure code end --------------------------------------

code ends
end start
;*****************************************************************************************