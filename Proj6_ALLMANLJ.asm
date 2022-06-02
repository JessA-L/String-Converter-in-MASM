TITLE Project 6: Low-Level I/O Procedures & Macros     (Proj6_ALLMANLJ.asm)

; Author: Jessica-Allman-LaPorte
; Last Modified: 5/30/2022
; OSU email address: allmanlj@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: 6                Due Date: 6/5/2022
; TODO: Update description
; Description: Program includes proceedures that user input as a string of ascii characters and converts
;				the string to numeric form and then converts back to print the ASCII representation of 
;				the value to the output. Includes a test program within main that fills an array of 
;				user defined integers, display the integers, their sum, and their truncated average. 

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
; prompt = address of prompt string
; string_len = size of input_string
; input_string = array of ascii characters input by user
; - string_size:REQ
;
; returns: stringAddr = generated string address
; ---------------------------------------------------------------------------------
mGetString MACRO prompt:REQ, string_len:REQ, input_string:REQ, string_size:REQ
; prompt user for input
	PUSH	EDX
	MOV		EDX, prompt
	CALL	WriteString

; get user input
	MOV		EDX, input_string			; EDX = address of num_string (buffer)
	MOV		ECX, string_size			; ECX = num_string (buffer) size
	CALL	ReadString					; returns:
										;	EDX = address of num_string (user string)					
	MOV		string_len, EAX				;	EAX = number of characters entered

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

ARRAYSIZE = 3							; TEST: change back to 10

.data

intro1				BYTE	"Project 6: Fun with Low-Level I/O Procedures & Macros! - by Jessica Allman-LaPorte",13,10,13,10,0
intro2				BYTE	"Input 10 signed decimal integers (positive or negative. or 0).",13,10
					BYTE	"Each number must fit inside a 32 bit register. After you've input the raw numbers,",13,10
					BYTE	"the program will display a list of the integers, their sum, and their truncated mean.",13,10,0
prompt1				BYTE	"Please enter a signed number: ",0
error_mess			BYTE	"ERROR: You did not enter a signed number or your number was too big.",13,10,0
num_string			BYTE	21 DUP(0)
int_array			DWORD	ARRAYSIZE DUP(?)
; TODO: Write prompts for test program in main

.code
main PROC

	PUSH	OFFSET intro1
	PUSH	OFFSET intro2
	CALL	introduction
	
; Test program which uses the ReadVal and WriteVal procedures to:

	MOV		ECX, ARRAYSIZE			; _fillLoop will loop ARRAYSIZE times
	MOV		EDI, OFFSET int_array	; Address of array in EDI

; fill array with ARRAYSIZE (default 10) valid integers entered by users
_fillLoop:
	PUSH	SIZEOF num_string		; [EBP+20]
	PUSH	OFFSET num_string		; [EBP+16]
	PUSH	OFFSET error_mess		; [EBP+12]
	PUSH	OFFSET prompt1			; [EBP+8]
	CALL	ReadVal					; EAX = returned int

	MOV		[EDI], EAX				; int into [EDI]
	ADD		EDI, 4					; inc by type size
	LOOP	_fillLoop

; TODO: Display the integers

; TODO: Display the sum of the integers

; TODO: Display the truncated average of the integers

	Invoke ExitProcess,0			; exit to operating system
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
; Name: ReadVal
;
; Invokes the mGetString macro to get user input, converts the string of ascii 
;	digits to its numeric value representation, and stores this one value in a 
;	EAX. 
;
; Preconditions: the array contains a string of ascii digits, mGetString macro works
;
; Postconditions: EAX, EBX, EDX changed
;
; Receives:
;	 - SIZEOF num_string
;	 - address of num_string
;	 - address of error_mess
;	 - address of prompt1
;
; returns: an integer in EAX
; ---------------------------------------------------------------------------------
ReadVal PROC
	LOCAL s_len:DWORD, num_char:BYTE, num_int:SDWORD
	PUSH	ECX
	MOV		num_int, 0				;  num_int = 0

_getNewString:
; Read the user's input as a string and convert the string to numeric form.
;  get num_string (uset input of ascii chars)	
	mGetString [EBP+8], s_len, [EBP+16], [EBP+20]		
	CALL	CrLf

	CLD								; sets direction flag (forward)
	MOV		EBX, 10
	MOV		ECX, s_len
	MOV		ESI, [EBP+16]			; address of num_string
_convert:

; TODO: If the user enters non-digits other than something which will indicate sign 
;		(e.g. ‘+’ or ‘-‘), or the number is too large for 32-bit registers, 
;		an error message should be displayed and the number should be discarded.
; TODO: CONVERT loop two branches to handle sign : sub or add to zero

	LODSB							;  for num_char in num_string:
	MOV		num_char, AL
	CMP		num_char, 48
	JL		_error
	CMP		num_char, 57
	JG		_error					;    if 48 <= num_char <= 57:
	MOV		EAX, num_int			;      num_int = 10 * num_int + (num_char - 48)
	IMUL	EBX						; 10 * num_int
	MOVZX	EDX, num_char
	ADD		EAX, EDX
	SUB		EAX, 48					; EAX = integer converted from string
	MOV		num_int, EAX
  LOOP	_convert
	
	CALL	WriteInt				; TEST: prints integer after user input
	CALL	CrLf					; TEST: delete this line later

	JMP		_out
									
_error:								;    else:
	MOV		EDX, [EBP+12]			;		print error message
	CALL	WriteString
	MOV		num_int, 0				;		num_int = 0
	JMP		_getNewString			;		get another num_string

; Store this one value in a memory variable (output parameter, by reference). 
_out:
	MOV		EAX, num_int
	POP		ECX
	RET		16
ReadVal	ENDP
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
