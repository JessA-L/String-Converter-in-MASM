TITLE Project 6: Low-Level I/O Procedures & Macros     (Proj6_ALLMANLJ.asm)

; Author: Jessica-Allman-LaPorte
; Last Modified: 5/30/2022
; OSU email address: allmanlj@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: 6                Due Date: 6/5/2022
; TODO: Update description
; Description: 


INCLUDE Irvine32.inc

; ---------------------------------------------------------------------------------
; Name: mGetString
;
; Display a prompt (input parameter, by reference), then get the user’s keyboard 
;	input using ReadString, in the form of a string of digits, into a memory location. 
;
; Preconditions: do not use eax, ecx, esi as arguments
;
; Receives:
;	prompt
;	userInput = array address
;	stringSize = array length
;
; returns: stringAddr = generated string address
; ---------------------------------------------------------------------------------
mGetString MACRO 
	LOCAL prompt1
  .data
	prompt1				BYTE	"Please enter a signed number: ",0
  .code
	PUSH	EDX
	MOV		EDX, OFFSET prompt1
	CALL	WriteString

	MOV		EDX, OFFSET int_string		; EDX = address of int_string
	MOV		ECX, SIZEOF	int_string		; ECX = int_string size
	CALL	ReadString					; gets int_string

	CALL	CrLf

	CALL	WriteString					; TEST print

	POP		EDX
ENDM

; ---------------------------------------------------------------------------------
; Name: mDisplayString
;
; Print the string stored in a specified memory location using WriteString.
;
; Preconditions: 
;	do not use eax, ecx, esi as arguments
;	stringAddress has been pushed to stack
;
; Receives:
;	stringAddress - contains string to be printed
;
; returns: none
; ---------------------------------------------------------------------------------

; (insert constant definitions here)

.data

intro1				BYTE	"Project 6: Fun with Low-Level I/O Procedures & Macros! - by Jessica Allman-LaPorte",13,10,13,10,0
intro2				BYTE	"Input 10 signed decimal integers (positive or negative. or 0).",13,10
					BYTE	"Each number must fit inside a 32 bit register. After you've input the raw numbers,",13,10
					BYTE	"the program will display a list of the integers, their sum, and their truncated mean.",13,10,0

error_mess			BYTE	"ERROR: You did not enter an signed number or your number was too big.",13,10
					BYTE	"Please try again: ",13,10,0
int_string			BYTE	12 DUP(0)

.code
main PROC

	PUSH	OFFSET intro1
	PUSH	OFFSET intro2
	CALL	introduction

; Write a test program which uses the ReadVal and WriteVal procedures to:
; Get 10 valid integers from the user. 
; - Your ReadVal will be called within the loop in main. 
; - Do not put your counted loop within ReadVal.
; Stores these numeric values in an array.
; Display the integers, their sum, and their truncated average.
; ** Your ReadVal will be called within the loop in main. 
; **  - Do not put your counted loop within ReadVal.

	CALL	readVal

	Invoke ExitProcess,0	; exit to operating system
main ENDP

; ---------------------------------------------------------------------
; Name: introduction
;
; Introduces the user to the program and displays the title, programmer's name
;	and description
;
; Preconditions: intro1 and intro2 exist and have been pushed onto stack
;
; Postconditions: EDX changed
; --------------------------------------------------------------------
introduction PROC
	PUSH	EBP						; Step 1) Preserve EBP
	MOV		EBP, ESP				; Step 2) Assign static stack-frame pointer
	MOV     EDX, [EBP+12]   
	CALL    WriteString				; print intro1
	MOV     EDX, [EBP+8]   
	CALL    WriteString				; print intro2
	CALL	CrLf
	
	POP		EBP
	RET		8
introduction ENDP
; ---------------------------------------------------------------------------------
; Name: readVal
;
; Invokes the mGetString macro to get user input, converts the string of ascii 
;	digits to its numeric value representation, and stores this one value in a 
;	memory variable. 
;
; Preconditions: the array contains a string of ascii digits.
;
; Postconditions: 
;
; Receives:
;
; returns: 
; ---------------------------------------------------------------------------------
readVal PROC
	PUSH	EBP						; Step 1) Preserve EBP
	MOV		EBP, ESP				; Step 2) Assign static stack-frame pointer
; Read the user's input as a string and convert the string to numeric form.
; - Invoke the mGetString macro (see parameter requirements above) to get user input 
;	in the form of a string of digits.
	mGetString 

; Convert (using string primitives LODSB and/or STOSB) the string of ascii digits to 
; its numeric value representation (SDWORD), validating the user’s input is a valid 
; number (no letters, symbols, etc).
;	 - If the user enters non-digits other than something which will indicate sign 
;		(e.g. ‘+’ or ‘-‘), or the number is too large for 32-bit registers, 
;		an error message should be displayed and the number should be discarded.
;	 - If the user enters nothing (empty input), display an error and re-prompt.


; Store this one value in a memory variable (output parameter, by reference). 

	POP		EBP
	RET		
readVal	ENDP
; ---------------------------------------------------------------------------------
; Name: WriteVal
;
; Converts a numeric SDWORD value to a string of ASCII digits and invokes the 
; mDisplayString macro to print the ASCII representation of the value to the output.
;
; Preconditions: 
;
; Postconditions: 
;
; Receives:
;
; returns: 
; ---------------------------------------------------------------------------------

; Convert a numeric SDWORD value (input parameter, by value) to a string of ASCII digits.

; Invoke the mDisplayString macro to print the ASCII representation of the SDWORD value 
;	to the output.

END main
