;  Must include:
;   Luis Maya
;	assignment 01
;	section <1002>

;   No name, asst, section -> no points!

; *****************************************************************
;  Data Declarations
;	Note, all data is declared statically (for now).

section	.data

; -----
;  Standard constants.

TRUE		equ	1
FALSE		equ	0

EXIT_SUCCESS	equ	0			; successful operation
SYS_exit	equ	60			; call code for terminate

; -----
;  Byte (8-bit) variable declarations

	num1	db	17
	num2	db	9

	res1	db	0
	res2	db	0
	res3	dw	0
	res4	db	0
	rem4	db	0

; -----
;  Word (16-bit) variable declarations

	num3	dw	5003
	num4	dw	7

	res5	dw	0
	res6	dw	0
	res7	dd	0
	res8	dw	0
	rem8	dw	0

; -----
;  Double-word (32-bit) variable declarations

	num5	dd	100007
	num6	dd	1501

	res9	dd	0
	res10	dd	0
	res12	dd	0
	rem12	dd	0

; *****************************************************************
;  Code Section

section	.text
global _start
_start:

; ----------
;  Byte variables examples (signed data)

;	res1 = num1 + num2
	mov	al, num1
	add	al, num2
	mov bl, res1
	mov	bl, al

; *****************************************************************
;	Done, terminate program.

last:
	mov	eax, SYS_exit		; call code for exit
	mov	ebx, EXIT_SUCCESS	; exit program with success
	syscall
