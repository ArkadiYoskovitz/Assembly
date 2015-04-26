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
msgHintMain	db	10,13,"Hint: 		"							, 10,13,endLine;
msgHint0	db	"0->Quit			" 							, 10,13,endLine;
msgHint1	db	"1->File_Open		" 							, 10,13,endLine;
msgHint2	db	"2->File_Close		" 							, 10,13,endLine;
msgHint3	db	"3->File_Write_New	"							, 10,13,endLine;
msgHint4	db	"4->File_Append		"							, 10,13,endLine;
msgHint5	db	"5->File_Read 		"							, 10,13,endLine;
msgHint6	db	"No response to illegal input "					, 10,13,endLine
;--------------------------------- File Open messages ------------------------------------
msgPFName	db	10,13, "Please enter file name"					, 10,13,endLine;
msgOper		db	10,13, "Press 0 to read, 1 to write, 2 for both", 10,13,endLine;
msgFCreated	db	10,13, "File created successfully" 				, 10,13,endLine;
msgFCError	db	10,13, "Error creating file"					, 10,13,endLine;

msgFOpened	db	10,13, "Finished - File opened"					, 10,13,endLine;
msgFOpenErr	db	10,13, "Could not open file"					, 10,13,endLine;

msgFClosed	db	10,13, "Finished - File closed"					, 10,13,endLine;
msgFClosErr	db	10,13, "Could not close file"					, 10,13,endLine;

msgAppendIn	db	10,13, "Enter text up to 80 chars"				, 10,13,endLine;
msgFAppend	db	10,13, "Finished - File appended"				, 10,13,endLine;
msgFAppendE	db	10,13, "Could not append file"					, 10,13,endLine;

msgFRead	db	10,13, "Finished - File read"					, 10,13,endLine;
msgFReadErr	db	10,13, "Could not read file"					, 10,13,endLine;
;------------------------------------ Case messages --------------------------------------
msgCase0	db	"0->Quit			" 							, 10,13,endLine;
msgCase1	db	"1->File_Open		" 							, 10,13,endLine;
msgCase2	db	"2->File_Close		" 							, 10,13,endLine;
msgCase3	db	"3->File_Write_New	" 							, 10,13,endLine;
msgCase4	db	"4->File_Append		" 							, 10,13,endLine;
msgCase5	db	"5->File_Read 		" 							, 10,13,endLine;
;----------------------------------- System definition -----------------------------------
endLine 	equ	'$'
NULL		equ	0
InteraptV	equ 21h
ENTERED		equ 13
TRUE		equ 1
FALSE		equ 0
;---------------------------------- Function constants -----------------------------------
Func00		equ 0
Func01		equ 1
Func02		equ 2
Func03		equ 3
Func04		equ 4
Func05		equ 5
;-------------------------------- Application constants ----------------------------------
fileLen 	equ	12
fTextLen 	equ	50h
ASCIIComp	equ 30h
;-------------------------------- Application variables ----------------------------------
fName		db	 fileLen+1, fileLen+2 dup (?),10h,10,13,'$'; Storage for file name
fileText	db	fTextLen+1,fTextLen+2 dup (?),10h,10,13,'$'; Storage for file text
fileHandler	dw	?;
fileCommand	dw	?;
INPUT		dw	?;
MaxRuns		db	50;
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
			CALL	PrintMenu
			
			XOR		CX	 ,	CX		; Clear AC reg, so that we can use it as a helper
			XOR		AX	 ,	AX		; Clear AX reg to make sure we can store userInput
			MOV 	AH	 , 	TRUE	; Setup Read command			
			INT		InteraptV		; Read user input
			
			ADD		CL	 ,	AL		; Prepare to store the user input
			MOV		INPUT,	CX		; Store the user input
			SUB		INPUT, ASCIIComp; Compensate for ascii
			
			PUSH 	offset msgNLine	; Print new line
			CALL	PrintMsg
AppSwitch:
			;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			CMP		INPUT,Func00	; Test if the input wasn't sentinel loop
			JE		CASE_Func00		; If it was we jump to handler
			
			CMP		INPUT,Func01
			JE		CASE_Func01
			
			CMP		INPUT,Func02
			JE		CASE_Func02
			
			CMP		INPUT,Func03
			JE		CASE_Func03
			
			CMP		INPUT,Func04
			JE		CASE_Func04
			
			CMP		INPUT,Func05
			JE		CASE_Func05
			
			JMP		CASE_Default
			;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~			
CASE_Func00:
			PUSH 	offset msgCase0	; 0->Quit
			CALL	PrintMsg
			JMP		EndProgram		; User selected to quit
CASE_Func01:
			PUSH 	offset msgCase1	; 1->File_Open
			CALL	PrintMsg
			CALL	File_Open		; Call open file function
			JMP		CASE_Default	; Break from the switch and continu to run
CASE_Func02:
			PUSH 	offset msgCase2	; 2->File_Close
			CALL	PrintMsg
			CALL	File_Close		; Call close file function
			JMP		CASE_Default	; Break from the switch and continu to run
CASE_Func03:
			PUSH 	offset msgCase3	; 3->File_Write_New
			CALL	PrintMsg
			CALL	File_Write_New	; Call file creation function
			JMP		CASE_Default	; Break from the switch and continu to run
CASE_Func04:
			PUSH 	offset msgCase4	; 4->File_Append
			CALL	PrintMsg
			CALL	File_Append		; Call file appending function
			JMP		CASE_Default	; Break from the switch and continu to run
CASE_Func05:
			PUSH 	offset msgCase5	; 5->File_Read
			CALL	PrintMsg
			CALL	File_Read		; Call file reading function
			JMP		CASE_Default	; Break from the switch and continu to run
CASE_Default:
			;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~<<<Handel infinit loop by sentinel value
			DEC		MaxRuns			; Decrement the run counter
			CMP 	MaxRuns, NULL	; Test if we ran too much
			JZ		EndProgram		; Jump to program end
			;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~<<<Handel infinit loop by sentinel value
			JMP		DOMainLoop		; Jump to main loop

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
; Name		: PrintMenu
; Task		: Print a menu message to the screen 
; Input		: 
; Output	: 
; Destroys	: 
;-----------------------------------------------------------------------------------------
PrintMenu		PROC
PMenuInit:
		MOV 	BP, SP					; Get the base of the stack
		
		PUSH 	offset msgHintMain		; Prop for user name
		CALL	PrintMsg
		PUSH 	offset msgHint0			; Prop for user name
		CALL	PrintMsg
		PUSH 	offset msgHint1			; Prop for user name
		CALL	PrintMsg
		PUSH 	offset msgHint2			; Prop for user name
		CALL	PrintMsg
		PUSH 	offset msgHint3			; Prop for user name
		CALL	PrintMsg
		PUSH 	offset msgHint4			; Prop for user name
		CALL	PrintMsg
		PUSH 	offset msgHint5			; Prop for user name
		CALL	PrintMsg
		PUSH 	offset msgHint6			; Prop for user name
		CALL	PrintMsg
		
		RET		
PrintMenu		ENDP        
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

;*****************************************************************************************~~~~~~~111
;--------------------------------- Procedure code ----------------------------------------
; Name		: File_Open
; Task		: Opens a file
; Input		: no input
; Output	: FileHandler
; Destroys	: AX,BX,DX
;-----------------------------------------------------------------------------------------
File_Open		PROC
FOInit:
		MOV 	BP, SP					; Get the base of the stack
		
		PUSH	offset msgPFName		; Prepare promp
		CALL	PrintMsg				; Promp the user to enter a file name 
        
        MOV		FileHandler	,NULL		; Prepare file handler
        
        LEA 	DX	,	fName			; Prepare to read file name
        MOV 	AH	,	10				; Prepare to read file name
        INT 	InteraptV				; Read file name from user input

        MOV 	BL	,	fName[1]		; Get file path length 
        MOV 	BH	,	NULL			; Prepare fix
        MOV 	fName[BX+2],NULL		; Put a fix file path (needs to end with NULL)
        		
		PUSH	offset msgOper			; Prepare promp
		CALL	PrintMsg				; Promp the user to enter a open operation type         		
		XOR		CX	 ,	CX				; Clear AC reg, so that we can use it as a helper
		XOR		AX	 ,	AX				; Clear AX reg to make sure we can store userInput
		MOV 	AH	 , 	TRUE			; Setup Read command			
		INT		InteraptV				; Read user input
					
		ADD		CL	 ,	AL				; Prepare to store the user input
		MOV		fileCommand, CX			; Store the user input			
		SUB		fileCommand, ASCIIComp	; Compensate for ascii
        		
        MOV 	AX	,	fileCommand 	; Prepare To read file; Read-0,Write-1,ReadWrite-2
        MOV 	AH	,	3Dh				; Prepare to open new file
        LEA 	DX	,	fName[2]		; Put file path in DX register
        INT 	InteraptV				; Create file
        JC  	FOError					; If creation failed show error
        
        MOV		FileHandler	,	AX		; Save the file handler of the open file
                
		PUSH	offset msgFOpened		; Prepare success massage
        JMP 	FOPrint					; Jump to print massage
FOError:
		PUSH	offset msgFOpenErr		; Prepare error massage
FOPrint:  
		CALL	PrintMsg				; Show massage

		RET		
File_Open		ENDP
;*****************************************************************************************~~~~~~~111
;
;
;*****************************************************************************************~~~~~~~222
;--------------------------------- Procedure code ----------------------------------------
; Name		: File_Close
; Task		: Close a file
; Input		: Global FileHandler
; Output	: 
; Destroys	: AX,BX,DX
;-----------------------------------------------------------------------------------------
File_Close		PROC
FCInit:
		MOV 	BP, SP					; Get the base of the stack
		
; 		CALL	File_Open				; Call open file
		
		MOV 	AH	,	3Eh				; Prepare to close file
        MOV 	BX	,	[FileHandler]	; Put file handler in BX register
        INT 	InteraptV				; Closing file
        JC  	FOError					; If Closing failed show error
                
		PUSH	offset msgFClosed		; Prepare success massage
        JMP 	FCPrint					; Jump to print massage
FCError:
		PUSH	offset msgFClosErr		; Prepare error massage
FCPrint:  
		CALL	PrintMsg				; Show massage

		RET		
File_Close		ENDP
;*****************************************************************************************~~~~~~~222
;
;
;*****************************************************************************************~~~~~~~333
;--------------------------------- Procedure code ----------------------------------------
; Name		: File_Write_New
; Task		: Create a new file
; Input		: no input
; Output	: 
; Destroys	: AX,BX,DX
;-----------------------------------------------------------------------------------------
File_Write_New	PROC
FWNInit:
		MOV 	BP, SP					; Get the base of the stack
		
		PUSH	offset msgPFName		; Prepare promp
		CALL	PrintMsg				; Promp the user to enter a file name 
        
        LEA 	DX	,	fName			; Prepare to read file name
        MOV 	AH	,	10				; Prepare to read file name
        INT 	InteraptV				; Read file name from user input

        MOV 	BL	,	fName[1]		; Get file path length 
        MOV 	BH	,	NULL			; Prepare fix
        MOV 	fName[BX+2],NULL		; Put a fix file path (needs to end with NULL)
        		
        MOV 	AH	,	3Ch				; Prepare to create new file
        LEA 	DX	,	fName[2]		; Put file path in DX register
        MOV 	CX	,	NULL			; Prepare file attribute
        INT 	InteraptV				; Create file
        JC  	FWNError				; If creation failed show error
        
		PUSH	offset msgFCreated		; Prepare success massage
        JMP 	FWNPrint				; Jump to print massage
FWNError:
		PUSH	offset msgFCError		; Prepare error massage
FWNPrint:  
		CALL	PrintMsg				; Show massage
		
		RET		
File_Write_New	ENDP
;*****************************************************************************************~~~~~~~333
;
;
;*****************************************************************************************~~~~~~~444
;--------------------------------- Procedure code ----------------------------------------
; Name		: File_Append
; Task		: Opens a file
; Input		: 
; Output	: 
; Destroys	: AX,BX,CX,DX,BP
;-----------------------------------------------------------------------------------------
File_Append		PROC
FAInit:
		MOV 	BP, SP					; Get the base of the stack
		
		CMP		FileHandler,NULL		; Check file opened successfully
		JZ		FAEnd

		PUSH	offset msgAppendIn		; Promp the user to input string
		CALL 	PrintMsg				; read a string from the use
		
		LEA 	DX	,	fileText		; Prepare to read file text
        MOV 	AH	,	10				; Prepare to read file name
        INT 	InteraptV				; Read file name from user input
        
		MOV 	AH	,	40h				; Prepare to write file disk
        MOV 	BX	,	[FileHandler]	; Put file handler in BX register
        XOR		CX	,	CX
        MOV 	CL	,	fileText[1]		; Text length
        LEA		DX	,	fileText[2]		; Address of the segment we write to DS:DX

        INT 	InteraptV				; Reading from disk
        JC  	FAError					; If Closing failed show error
      
      	
		PUSH	offset msgFAppend		; Prepare success massage
        JMP 	FAPrint					; Jump to print massage
FAError:
		PUSH	offset msgFAppendE		; Prepare error massage
FAPrint:  
		CALL	PrintMsg				; Show massage

		CALL	File_Close				; Close the file we opened to read
FAEnd:		
		RET		
File_Append		ENDP
;*****************************************************************************************~~~~~~~444
;
;*****************************************************************************************~~~~~~~555
;--------------------------------- Procedure code ----------------------------------------
; Name		: File_Read
; Task		: Opens a file
; Input		: 
; Output	: 
; Destroys	: AX,BX,CX,DX,BP
;-----------------------------------------------------------------------------------------
File_Read		PROC
FRInit:
		MOV 	BP, SP					; Get the base of the stack
		
		CMP		FileHandler,NULL		; Check file opened successfully
		JZ		FREnd
		
		
		MOV 	AH	,	3Fh				; Prepare to close file
        MOV 	BX	,	[FileHandler]	; Put file handler in BX register
		LEA 	DX	,	fileText[2]		; Address of the segment we write to DS:DX
		
		XOR		CX	,	CX				; Prepare to read file from disk
        MOV 	CL	,	fileText[1]		; Set file size to read
        INT 	InteraptV				; Reading from disk
        JC  	FRError					; If Closing failed show error
      
      	MOV 	BL	,	fileText[1]		; Get file size to show
		MOV 	BH	,	NULL			; Prepare fix
		MOV 	fileText[BX+2],endLine	; Put a fix in file text (needs to end by newLine)
		PUSH	offset fileText[2]		; Prepare file to be shown on screen
		CALL	PrintMsg				; Show on screen
		
		PUSH	offset msgFRead			; Prepare success massage
        JMP 	FRPrint					; Jump to print massage
FRError:
		PUSH	offset msgFReadErr		; Prepare error massage
FRPrint:  
		CALL	PrintMsg				; Show massage

FREnd:		
		RET		
File_Read		ENDP
;*****************************************************************************************~~~~~~~555
;
;------------------------------- Procedure code end --------------------------------------

code ends
end start
;*****************************************************************************************