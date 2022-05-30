TITLE Project 6: Low-Level I/O Procedures & Macros     (Proj6_ALLMANLJ.asm)

; Author: Jessica-Allman-LaPorte
; Last Modified: 5/30/2022
; OSU email address: allmanlj@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: 6                Due Date: 6/5/2022
; TODO: Update description
; Description: 


INCLUDE Irvine32.inc

; (insert macro definitions here)

; (insert constant definitions here)

.data

intro1				BYTE	"Project 6: Fun with Low-Level I/O Procedures & Macros! - by Jessica Allman-LaPorte",13,10,13,10,0
; TODO: Update description
intro2				BYTE	"DESCRIPTION LINE 1",13,10
					BYTE	"DESCRIPTION LINE 2",13,10
					BYTE	"DESCRIPTION LINE 3",13,10,0

.code
main PROC

	PUSH	OFFSET intro1
	PUSH	OFFSET intro2
	CALL	introduction

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

END main
