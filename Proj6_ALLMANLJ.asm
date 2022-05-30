TITLE Project 6: Low-Level I/O Procedures & Macros     (Proj6_ALLMANLJ.asm)

; Author: Jessica-Allman-LaPorte
; Last Modified: 5/30/2022
; OSU email address: allmanlj@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: 6                Due Date: 6/5/2022
; Description: 


INCLUDE Irvine32.inc

; (insert macro definitions here)

; (insert constant definitions here)

.data

intro1				BYTE	"Project 6: Fun with Low-Level I/O Procedures & Macros! - by Jessica Allman-LaPorte",13,10,13,10,0
intro2				BYTE	"DESCRIPTION LINE 1",13,10
					BYTE	"DESCRIPTION LINE 2",13,10
					BYTE	"DESCRIPTION LINE 3",13,10,0

.code
main PROC

; (insert executable instructions here)

	Invoke ExitProcess,0	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
