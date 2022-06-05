TITLE Project 6: Low-Level I/O Procedures & Macros     (Proj6_ALLMANLJ.asm)

; Author: Jessica-Allman-LaPorte
; Last Modified: 6/3/2022
; OSU email address: allmanlj@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: 6                Due Date: 6/5/2022
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
;
; Receives:
;	string array
;
; returns: none
; ---------------------------------------------------------------------------------
mDisplayString MACRO array:REQ

	CMP		sign, 0
	JZ		_write
	MOV		AL, 45
	CALL	WriteChar
_write:
	MOV		EDX, array
	CALL	WriteString

ENDM

ARRAYSIZE = 10							

.data

intro1				BYTE	"Project 6: Fun with Low-Level I/O Procedures & Macros! - by Jessica Allman-LaPorte",13,10,13,10,0
intro2				BYTE	"Input 10 signed decimal integers (positive or negative. or 0).",13,10
					BYTE	"Each number must fit inside a 32 bit register. After you've input the raw numbers,",13,10
					BYTE	"the program will display a list of the integers, their sum, and their truncated mean.",13,10,0
prompt1				BYTE	"Please enter a signed number: ",0
error_mess			BYTE	"ERROR: You did not enter a signed number or your number was too big.",13,10,0
display_string		BYTE	"You entered the following numbers:",13,10,0
sum_string			BYTE	"The sum of these numbers is: ",13,10,0
average_string		BYTE	"The truncated average is: ",13,10,0
goodbye_string		BYTE	"Goodbye!",13,10,0
num_string			BYTE	21 DUP(0)
digit_array			BYTE	ARRAYSIZE DUP(?)
digit_array2		BYTE	ARRAYSIZE DUP(?)
int_array			DWORD	ARRAYSIZE DUP(?)


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
	PUSH	OFFSET digit_array2		; [EBP+12]
	PUSH	OFFSET digit_array		; [EBP+8]
	CALL	WriteVal

; TODO: Display the sum of the integers


; TODO: Display the truncated average of the integers

; Display goodbye message
	PUSH	OFFSET goodbye_string
	CALL	goodbye

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
;
; Recieves: intro1 and intro2 strings
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
;	digit to its numeric value representation, and stores this one value in a 
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
	LOCAL s_len:DWORD, num_char:BYTE, num_int:SDWORD, sign:BYTE
	PUSH	ECX
	MOV		num_int, 0				;  num_int = 0

_getNewString:
; Read the user's input as a string and convert the string to numeric form.
;  get num_string (uset input of ascii chars)	
	mGetString [EBP+8], s_len, [EBP+16], [EBP+20]		
	CALL	CrLf
	MOV		sign, 0					; sign = 0 (default; positive integer)

	CLD								; sets direction flag (forward)
	MOV		EBX, 10
	MOV		ECX, s_len
	MOV		ESI, [EBP+16]			; address of num_string

	MOV		AL, [ESI]
; if first character != 45(-), skip to check for +
	CMP		AL, 45
	JNE		_checkPlus
	INC		sign					; sign = 1 (negative integer)
	LODSB
	JMP		_loopAgain
; if first character != 43(+), skip to loop
_checkPlus:
	CMP		AL, 43
	JNE		_convert 

	LODSB
	JMP		_loopAgain

_convert:
	LODSB							;  for num_char in num_string:
	MOV		num_char, AL
	CMP		num_char, 48
	JL		_error
	CMP		num_char, 57
	JG		_error					;    if 48 <= num_char <= 57:
	MOV		EAX, num_int			;      num_int = 10 * num_int + (num_char - 48)
	IMUL	EBX						;		(10 * num_int)
	MOVZX	EDX, num_char
	JO		_error
	ADD		EAX, EDX
	JO		_error

_notTooBig:
	SUB		EAX, 48					; EAX = integer converted from string
	MOV		num_int, EAX

_loopAgain:
  LOOP	_convert
	JMP		_checkSign
									
_error:								;    else:
	MOV		EDX, [EBP+12]			;		print error message
	CALL	WriteString
	MOV		num_int, 0				;		num_int = 0
	JMP		_getNewString			;		get another num_string

; check sign: if negative, subtract from zero
_checkSign:
	CMP		sign, 1
	JZ		_negInt
	JMP		_out
_negInt:
	MOV		EAX, 0
	SUB		EAX, num_int
	MOV		num_int, EAX

; Store this one value in a memory variable (output parameter, by reference). 
_out:	
	MOV		EAX, num_int
		
	CALL	WriteInt				; TEST: prints integer after user input
	CALL	CrLf					; TEST: delete this line later

	POP		ECX
	RET		16
ReadVal	ENDP

; ---------------------------------------------------------------------------------
; Name: WriteVal
;
; Converts a numeric SDWORD value to a string of ASCII digits and invokes the 
; mDisplayString macro to print the ASCII representation of the value to the output.
;
; Preconditions: EAX contains an integer
;
; Postconditions: EBX, ECX, EDX changed
;
; Receives: EAX = the integer to be printed
;
; returns: none
; ---------------------------------------------------------------------------------
WriteVal PROC
; Convert a numeric SDWORD value (input parameter, by value) to a string of ASCII digits.
	LOCAL sign:BYTE, len:DWORD
	PUSH	EAX
	PUSH	EDI
	PUSH	ESI
	MOV		sign, 0				; sing = 0, will indicates sign of integer in EAX, default positive
	MOV		ESI, [EBP+8]		; move digit_array into ESI

; is the integer positive?
	CMP		EAX, 0				
								
	JL		_negative
	JMP		_howBig

; if not, negate and change sign to 1
_negative:
	NEG		EAX					
	MOV		sign, 1

_howBig:
; how large is the integer?
; if > 1000000000
	CMP		EAX, 1000000000
	JGE		_len10
;	 >= 100000000
	CMP		EAX, 100000000
	JGE		_len9
;	 >= 10000000
	CMP		EAX, 10000000
	JGE		_len8
;	 >= 1000000
	CMP		EAX, 1000000
	JGE		_len7
;	 >= 100000
	CMP		EAX, 100000
	JGE		_len6
;	 >= 10000
	CMP		EAX, 10000
	JGE		_len5
;	 >= 1000
	CMP		EAX, 1000
	JGE		_len4
;	 >= 100
	CMP		EAX, 100
	JGE		_len3
;	 >= 10
	CMP		EAX, 10
	JGE		_len2
; else:
	MOV		len, 1
	JMP		_initCounter
_len10:
	MOV		len, 10
	JMP		_initCounter
_len9:
	MOV		len, 9
	JMP		_initCounter
_len8:
	MOV		len, 8
	JMP		_initCounter
_len7:
	MOV		len, 7
	JMP		_initCounter
_len6:
	MOV		len, 6
	JMP		_initCounter
_len5:
	MOV		len, 5
	JMP		_initCounter
_len4:
	MOV		len, 4
	JMP		_initCounter
_len3:
	MOV		len, 3
	JMP		_initCounter
_len2:
	MOV		len, 2

_initCounter:
	MOV		ECX, len

_fillArrayLoop:
; divide integer by 10
	MOV		EBX, 10					; divisor
	MOV		EDX, 0
	IDIV	EBX	
; add 48 to remainder
	ADD		EDX, 48
	MOV		[ESI], EDX				; int into [ESI]
	ADD		ESI, 1					; inc by type size

  LOOP	_fillArrayLoop

	MOV		ECX, len
	MOV		ESI, [EBP+8]
	ADD		ESI, ECX
	DEC		ESI
	MOV		EDI, [EBP+12]		; move digit_array2 into EDI

; Reverse string
_revLoop:
    STD
    LODSB
    CLD
    STOSB
   LOOP   _revLoop

; Invoke the mDisplayString macro to print the ASCII representation of the SDWORD value 
;	to the output.
	mDisplayString [EBP+12]
	CALL	CrLf
	POP		ESI
	POP		EDI
	POP		EAX
	RET		12
WriteVal ENDP

; ---------------------------------------------------------------------
; Name: goodbye
;
; Displays farewell message
;
; Preconditions: goodbye_string exists and has been pushed onto stack
;
; Postconditions: EDX changed
;
; receives: goodbye_string = string
; --------------------------------------------------------------------
goodbye PROC
	PUSH	EBP						; Step 1) Preserve EBP
	MOV		EBP, ESP				; Step 2) Assign static stack-frame pointer

	MOV     EDX, [EBP+8]   
	CALL    WriteString				; print goodbye_string
	CALL	CrLf
	
	POP		EBP
	RET		8
goodbye ENDP
END main
