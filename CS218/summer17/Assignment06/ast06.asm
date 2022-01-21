;  Luis Maya
;  Section #1002
;  CS 218, Assignment #6
;  Provided Main

;  Simple assembly language program to convert ternary
;  numbers in ASCII format to integers.
;  Also converts an integer to ternary in ASCII format.


; *****************************************************************************
;  Macro, ternary2int, to convert an ASCII string (STR_SIZE characters,
;  byte-size, leading sign, right justified, blank filled, NULL terminated)
;  representing the signed ternary value into a signed base-10 integer.

;  Assumes valid/correct data.  As such, no error checking is performed.

;  NOTE, addresses are passed.  For example:
;	mov	rbx, %1 	  		-> copies 1st argument address to rbx
;	mov	dword [%2], eax   	-> sets 2nd argument.

%macro	ternary2int	2


;	YOUR CODE GOES HERE

mov r8, 0								; Counter to traverse string
mov rax, 0								; Clear rax register
mov dword [intDigit], 0					; Clear intDigit value
mov dword [%2], 0						; Clear temp

%%spaceCheck:
	movsx eax, byte [%1 + r8]			; Move current character of string into eax
	cmp eax, " "						; Compare current character with " "
	jne %%controlLoop					; If current character is not " " jump to controlLoop
	inc r8								; Increase counter
	jmp %%spaceCheck					; Jump to spaceCheck and check next character
%%controlLoop:
	cmp eax, "-"						; Check if number is negative
	je %%rmNegSign						; Jump to rmNegSign if number is negative
	inc r8								; Update counter to access first digit if identified as postive
%%positiveLoop:
	movsx eax, byte [%1 + r8]			; Move first digit into eax
	cmp eax, NULL						; Check if at end of string
	je %%controlDone					; Jump to controlDone if current character is equal to NULL
	cmp eax, "0"						; Check if current character is number
	jge %%postiveSum					; If character is 0 or above, jump to convert character to number
%%rmNegSign:
	inc r8								; Update counter to access first digit in string
%%negativeLoop:
	movsx eax, byte [%1 + r8]			; Move first digit into eax
	cmp eax, NULL						; Check if at end of string
	je %%negativeDone					; Jump to negativeDone if current character is equal to NULL
	cmp eax, "0"						; Check if current character is number
	jge %%negativeSum					; If character is 0 or above, jump to convert character to number
%%postiveSum:
	sub eax, "0"						; "Curr number" - "0" to get number as is
	mov dword [intDigit], eax			; Move number to temp storage location
	mov eax, dword [%2]					; Move current decimal number to eax
	imul dword [numThree]				; Mul current number by three to convert into decimal
	add eax, dword [intDigit]			; ans += intDigit
	mov dword [%2], eax					; Move current value of eax to ans
	inc r8								; Update string counter
	jmp %%positiveLoop					; Jump to positiveLoop to continue
%%negativeSum:
	sub eax, "0"						; "Curr number" - "0" to get number as is
	mov dword [intDigit], eax			; Move number to temp storage location
	mov eax, dword [%2]					; Move current decimal number to eax
	imul dword [numThree]				; Mul current number by three to convert into decimal
	add eax, dword [intDigit]			; ans += intDigit
	mov dword [%2], eax					; Move current value of eax to ans
	inc r8								; Update string counter
	jmp %%negativeLoop					; Jump to negativeLoop to continue
%%negativeDone:
	mov eax, dword [%2]					; Move decimal number to eax
	neg eax								; Negate decimal number to get negative
	mov dword [%2], eax					; Move negative number to ans
%%controlDone:


%endmacro


; --------------------------------------------------------------
;  Macro, int2ternary, to convert a signed base-10 integer into
;  an ASCII string representing the ternary value.

;  The macro stores the result into an ASCII string (STR_SIZE characters,
;  byte-size, right justified, blank filled, NULL terminated).
;  Each integer is a double word value.

;  Assumes valid/correct data.  As such, no error checking is performed.

;  NOTE, addresses are passed.  For example:
;	mov	eax, dword [%1], eax	-> gets 1st argument value
;	mov	rbx, %1 		-> copies 2nd argument address to rbx

%macro	int2ternary	2	; integer, string


;	YOUR CODE GOES HERE

mov rsi, 0								; Character counter = 0
mov eax, dword [%1]						; Move decimal integer into eax

%%signCheck:
	cmp eax, 0							; Check if decimal number is postive or negative
	jge %%posConversion					; If postive, jump to posConversion
	neg eax								; If negative, negate number then jump to negConversion
	jmp %%negConversion
%%posConversion:
	cdq
	idiv dword [numThree]				; Divide decimal number by 3 repeatedly to convert to base 3
	push rdx							; Remainder will be stored, push onto stack
	inc rsi								; Increase character counter
	cmp eax, 0							; Compare current value in eax with 0 to determine if conversion is done
	jne %%posConversion					; Keep converting if not done
	mov rcx, MAX_SIZ					; Move max size of string (10) into rcx
	sub rcx, rsi						; Subtract the max size of the string with current char counter to determine spaces
	dec rcx								; Subtract the amount of spaces by 1 to take into account sign
	mov rdi, 0							; Counter for string
	mov rbx, %2							; Move address of tans0 into rbx
	jmp %%setPosSpaces
%%negConversion:
	cdq
	idiv dword [numThree]				; Divide decimal number by 3 repeatedly to convert to base 3
	push rdx							; Remainder will be stored, push onto stack
	inc rsi								; Increase character counter
	cmp eax, 0							; Compare current value in eax with 0 to determine if conversion is done
	jne %%negConversion					; Keep converting if not done
	mov rcx, MAX_SIZ					; Move max size of string (10) into rcx
	sub rcx, rsi						; Subtract the max size of the string with current char counter to determine spaces
	dec rcx								; Subtract the amount of spaces by 1 to take into account sign
	mov rdi, 0							; Counter for string
	mov rbx, %2							; Move address of tans0 into rbx
	jmp %%setNegSpaces
%%setPosSpaces:
	mov byte [rbx + rdi], " "			; Add space to current index in string
	inc rdi								; Update counter to traverse string
	loop %%setPosSpaces					; Decrease rcx; number of spaces left to place in string; loop if != 0
	mov byte [rbx + rdi], "+"			; Add "+" after spaces are complete
	inc rdi								; Update counter to traverse string
	mov rcx, rsi						; Move value of digits left to place in string to rcx
	jmp %%popLoop						; Jump to popLoop
%%setNegSpaces:
	mov byte [rbx + rdi], " "			; Add space to current index in string
	inc rdi								; Update counter to traverse string
	loop %%setNegSpaces					; Decrease rcx; number of spaces left to place in string; loop if != 0
	mov byte [rbx + rdi], "-"			; Add "-" after spaces are complete
	inc rdi								; Update counter to traverse string
	mov rcx, rsi						; Move value of digits left to place in string to rcx
	jmp %%popLoop						; Jump to popLoop
%%popLoop:
	pop rax								; Pop digit that needs to be placed
	add al, "0"							; Convert digit in character
	jmp %%setChar						; Jump to setChar
%%setChar:
	mov byte [rbx + rdi], al			; Set character in current string position
	inc rdi								; Update counter to traverse string
	loop %%popLoop						; Dec rcx; remaining amount of digits that need to be placed

mov rcx, 0								; Clear rcx

%endmacro

; --------------------------------------------------------------
;  Simple macro to display a string.
;	Call:	printString  <stringAddress>

;	Arguments:
;		%1 -> <string>, string address

;  Algorithm:
;	Count characters (excluding NULL).
;	Use system service to display string at address <string>

%macro	printString	1
	push	rax			; save altered registers
	push	rdi
	push	rsi
	push	rdx
	push	rcx

	mov	rdx, 0
	mov	rdi, %1
%%countLoop:
	cmp	byte [rdi], NULL
	je	%%countLoopDone
	inc	rdi
	inc	rdx
	jmp	%%countLoop
%%countLoopDone:

	mov	rax, SYS_write		; system call for write (SYS_write)
	mov	rdi, STDOUT		; standard output
	mov	rsi, %1			; address of the string
	syscall				; call the kernel

	pop	rcx			; restore registers to original values
	pop	rdx
	pop	rsi
	pop	rdi
	pop	rax
%endmacro

; *****************************************************************************

section	.data

; -----
;  Define standard constants

TRUE		equ	1
FALSE		equ	0

SUCCESS		equ	0			; Successful operation

STDIN		equ	0			; standard input
STDOUT		equ	1			; standard output
STDERR		equ	2			; standard error

SYS_read	equ	0			; system call code for read
SYS_write	equ	1			; system call code for write
SYS_open	equ	2			; system call code for file open
SYS_close	equ	3			; system call code for file close
SYS_fork	equ	57			; system call code for fork
SYS_exit	equ	60			; system call code for terminate
SYS_creat	equ	85			; system call code for file open/create
SYS_time	equ	201			; system call code for get time

LF			equ	10
NULL		equ	0
ESC			equ	27

; -----
;  Program specific constants.

MAX_SIZ			equ	10
NUMS_PER_LINE	equ	6
STR_SIZE		equ	12

; -----
;  Misc. variales for printString macro.

intMsg		db	"-----------------------------------------------------"
			db	LF, ESC, "[1m", "CS 218 - Assignment #6", ESC, "[0m"
			db	NULL

hdr			db	LF, LF, "----------------------"
			db	"----------------------"
			db	LF, "Answer:", LF, NULL

newLine		dd	LF, NULL

; -----
;  Misc. data definitions.

tmp		dd	0


; -----
;  Assignment #6 Provided Data:

tlet0	db	"     +12012", NULL
ans0	dd	0

tlet1	db	"     +12002", NULL
		db	"    +101212", NULL
		db	"   +1020201", NULL
		db	"      -1201", NULL
		db	"    -102022", NULL
len1	dd	5
ans1	dd	0


tlet2	db	"    +102201", NULL, "   +1020121", NULL
		db	"      +2001", NULL, "    -102010", NULL
		db	"    +102011", NULL, "    +101121", NULL
		db	"    -102101", NULL, "    -111200", NULL
		db	"     +12001", NULL, "   +1001201", NULL
		db	"      -2101", NULL, "    -102020", NULL
		db	"     +12001", NULL, "   +1020201", NULL
		db	"      -2101", NULL, "    -112002", NULL
len2	dd	16
ans2	dd	0


tlet3	db	"         +2", NULL, "        +20", NULL
		db	"       +210", NULL, "      +1200", NULL
		db	"     +12100", NULL, "    +100210", NULL
		db	"   +1202021", NULL, "  +10020100", NULL
		db	"   -1202010", NULL, "  -20010200", NULL
		db	"     -20120", NULL, "    -121020", NULL
		db	"       -120", NULL, "      -1200", NULL
		db	"         -2", NULL, "        -20", NULL
		db	"        +12", NULL
len3	dd	17
ans3	dd	0


tlet4	db	"     +12011", NULL, "    +120201", NULL
		db	"   +1202001", NULL, "    -112020", NULL
		db	"     +12001", NULL, "    -102210", NULL
		db	"     +12011", NULL, "     +11221", NULL
		db	"     -12101", NULL, "     -12210", NULL
		db	"     +22001", NULL, "    +102201", NULL
		db	"      -2101", NULL, "         -1", NULL
		db	"       +211", NULL, "       +121", NULL
		db	"      -1201", NULL, "       +120", NULL
		db	"     +11101", NULL, "      +1200", NULL
		db	"      -1201", NULL, "     +12021", NULL
		db	"         +2", NULL, "    +102021", NULL
		db	"        +12", NULL, "       +120", NULL
		db	"        -12", NULL, "       -121", NULL
len4	dd	28
ans4	dd	0


tlet5	db	"     -12021", NULL, "    -120121", NULL
		db	"      -1201", NULL, "         -1", NULL
		db	"       +121", NULL, "       -121", NULL
		db	"      -1201", NULL, "       -120", NULL
		db	"     -12201", NULL, "      -1200", NULL
		db	"      -2001", NULL, "     +12001", NULL
		db	"         -1", NULL, "    -102021", NULL
		db	"        -12", NULL, "       -120", NULL
		db	"        -22", NULL, "       -121", NULL
len5	dd	18
ans5	dd	0

intDigit	dd	0
numThree	dd	3

; --------------------------------------------------------------
;  Uninitialized (empty) variables

section	.bss

tans0		resb	STR_SIZE+1

ilst1		resd	5
tans1		resb	STR_SIZE+1

ilst2		resd	16
tans2		resb	STR_SIZE+1

ilst3		resd	17
tans3		resb	STR_SIZE+1

ilst4		resd	28
tans4		resb	STR_SIZE+1

ilst5		resd	18
tans5		resb	STR_SIZE+1


; *****************************************************************************

section	.text
global	start
start:

; -----
;  Print initial header message.

	printString	intMsg

; -----
;  Write and test code to conert ASCII ternary string (tlet0) to integer (ans0).
;	NOTE, this code should NOT use the macro.


;	YOUR CODE GOES HERE

mov rsi, 0								; Counter to traverse string

spaceCheck:
	movsx eax, byte [tlet0 + rsi]		; Move current character of string into eax
	cmp eax, " "						; Compare current character with " "
	jne controlLoop						; If current character is not " " jump to controlLoop
	inc rsi								; Increase counter
	jmp spaceCheck						; Jump to spaceCheck and check next character
controlLoop:
	cmp eax, "-"						; Check if number is negative
	je rmNegSign						; Jump to rmNegSign if number is negative
	inc rsi								; Update counter to access first digit if identified as postive
positiveLoop:
	movsx eax, byte [tlet0 + rsi]		; Move first digit into eax
	cmp eax, NULL						; Check if at end of string
	je controlDone						; Jump to controlDone if current character is equal to NULL
	cmp eax, "0"						; Check if current character is number
	jge postiveSum						; If character is 0 or above, jump to convert character to number
rmNegSign:
	inc rsi								; Update counter to access first digit in string
negativeLoop:
	movsx eax, byte [tlet0 + rsi]		; Move first digit into eax
	cmp eax, NULL						; Check if at end of string
	je negativeDone						; Jump to negativeDone if current character is equal to NULL
	cmp eax, "0"						; Check if current character is number
	jge negativeSum						; If character is 0 or above, jump to convert character to number
postiveSum:
	sub eax, "0"						; "Curr number" - "0" to get number as is
	mov dword [intDigit], eax			; Move number to temp storage location
	mov eax, dword [ans0]				; Move current decimal number to eax
	imul dword [numThree]				; Mul current number by three to convert into decimal
	add eax, dword [intDigit]			; ans += intDigit
	mov dword [ans0], eax				; Move current value of eax to ans
	inc rsi								; Update string counter
	jmp positiveLoop					; Jump to positiveLoop to continue
negativeSum:
	sub eax, "0"						; "Curr number" - "0" to get number as is
	mov dword [intDigit], eax			; Move number to temp storage location
	mov eax, dword [ans0]				; Move current decimal number to eax
	imul dword [numThree]				; Mul current number by three to convert into decimal
	add eax, dword [intDigit]			; ans += intDigit
	mov dword [ans0], eax				; Move current value of eax to ans
	inc rsi								; Update string counter
	jmp negativeLoop					; Jump to negativeLoop to continue
negativeDone:
	mov eax, dword [ans0]				; Move decimal number to eax
	neg eax								; Negate decimal number to get negative
	mov dword [ans0], eax				; Move negative number to ans
controlDone:

; -----
;  Double the initial value:
;		12012 (3) + 12012 (3) = 101101 (3)
;		140 (10) + 140 (10) = 280 (10)

	mov	eax, dword [ans0]
	add	dword [ans0], eax

; -----
;  Write and test code to conert integer (ans0) to ASCII ternary string (tans0).
;	NOTE, this code should NOT use the macro.


;	YOUR CODE GOES HERE

mov rsi, 0								; Character counter = 0
mov eax, dword [ans0]					; Move decimal integer into eax

signCheck:
	cmp eax, 0							; Check if decimal number is postive or negative
	jge posConversion					; If postive, jump to posConversion
	neg eax								; If negative, negate number then jump to negConversion
	jmp negConversion
posConversion:
	cdq
	idiv dword [numThree]				; Divide decimal number by 3 repeatedly to convert to base 3
	push rdx							; Remainder will be stored, push onto stack
	inc rsi								; Increase character counter
	cmp eax, 0							; Compare current value in eax with 0 to determine if conversion is done
	jne posConversion					; Keep converting if not done
	mov rcx, MAX_SIZ					; Move max size of string (10) into rcx
	sub rcx, rsi						; Subtract the max size of the string with current char counter to determine spaces
	dec rcx								; Subtract the amount of spaces by 1 to take into account sign
	mov rdi, 0							; Counter for string
	mov rbx, tans0						; Move address of tans0 into rbx
	jmp setPosSpaces
negConversion:
	cdq
	idiv dword [numThree]				; Divide decimal number by 3 repeatedly to convert to base 3
	push rdx							; Remainder will be stored, push onto stack
	inc rsi								; Increase character counter
	cmp eax, 0							; Compare current value in eax with 0 to determine if conversion is done
	jne negConversion					; Keep converting if not done
	mov rcx, MAX_SIZ					; Move max size of string (10) into rcx
	sub rcx, rsi						; Subtract the max size of the string with current char counter to determine spaces
	dec rcx								; Subtract the amount of spaces by 1 to take into account sign
	mov rdi, 0							; Counter for string
	mov rbx, tans0						; Move address of tans0 into rbx
	jmp setNegSpaces
setPosSpaces:
	mov byte [rbx + rdi], " "			; Add space to current index in string
	inc rdi								; Update counter to traverse string
	loop setPosSpaces					; Decrease rcx; number of spaces left to place in string; loop if != 0
	mov byte [rbx + rdi], "+"			; Add "+" after spaces are complete
	inc rdi								; Update counter to traverse string
	mov rcx, rsi						; Move value of digits left to place in string to rcx
	jmp popLoop							; Jump to popLoop
setNegSpaces:
	mov byte [rbx + rdi], " "			; Add space to current index in string
	inc rdi								; Update counter to traverse string
	loop setNegSpaces					; Decrease rcx; number of spaces left to place in string; loop if != 0
	mov byte [rbx + rdi], "-"			; Add "-" after spaces are complete
	inc rdi								; Update counter to traverse string
	mov rcx, rsi						; Move value of digits left to place in string to rcx
	jmp popLoop							; Jump to popLoop
popLoop:
	pop rax								; Pop digit that needs to be placed
	add al, "0"							; Convert digit in character
	jmp setChar							; Jump to setChar
setChar:
	mov byte [rbx + rdi], al			; Set character in current string position
	inc rdi								; Update counter to traverse string
	loop popLoop						; Dec rcx; remaining amount of digits that need to be placed

	mov rcx, 0							; Clear rcx


; ----
;	Display results.
;	Should show: +101101 (3)

	printString	hdr				; print header
	printString	tans0			; print answer

; ==================================================
;  Invoke macro for each set of data.

; -----
;  Data Set #1

	lea	rdi, [tlet1]			; get address
	mov	rcx, 0
	mov	ecx, dword [len1]		; length
lp1:
	push	rcx					; save registers
	push	rdi
	ternary2int	rdi, tmp		; convert ternary number to integer
	pop	rdi						; restore register
	pop	rcx
	mov	eax, dword [tmp]		; add number to running sum
	add	dword [ans1], eax
	add	rdi, STR_SIZE			; update address
	dec rcx
	cmp rcx, 0
	jne lp1

	int2ternary	ans1, tans1		; convert integer to ternary
	printString	hdr				; print header
	printString	tans1			; print answer

; -----
;  Data Set #2

	lea	rdi, [tlet2]			; get address
	mov	rcx, 0
	mov	ecx, dword [len2]		; length
lp2:
	push	rcx					; save registers
	push	rdi
	ternary2int	rdi, tmp		; convert ternary number to integer
	pop	rdi						; restore register
	pop	rcx
	mov	eax, dword [tmp]		; add number to running sum
	add	dword [ans2], eax
	add	rdi, STR_SIZE			; update address
	dec rcx
	cmp rcx, 0
	jne lp2

	int2ternary	ans2, tans2		; convert integer to ternary
	printString	hdr				; print header
	printString	tans2			; print answer

; -----
;  Data Set #3

	lea	rdi, [tlet3]			; get address
	mov	rcx, 0
	mov	ecx, dword [len3]		; length
lp3:
	push	rcx					; save registers
	push	rdi
	ternary2int	rdi, tmp		; convert ternary number to integer
	pop	rdi						; restore register
	pop	rcx
	mov	eax, dword [tmp]		; add number to running sum
	add	dword [ans3], eax
	add	rdi, STR_SIZE			; update address
	dec rcx
	cmp rcx, 0
	jne lp3

	int2ternary	ans3, tans3		; convert integer to ternary
	printString	hdr				; print header
	printString	tans3			; print answer

; -----
;  Data Set #4

	lea	rdi, [tlet4]			; get address
	mov	rcx, 0
	mov	ecx, dword [len4]		; length
lp4:
	push	rcx					; save registers
	push	rdi
	ternary2int	rdi, tmp		; convert ternary number to integer
	pop	rdi						; restore register
	pop	rcx
	mov	eax, dword [tmp]		; add number to running sum
	add	dword [ans4], eax
	add	rdi, STR_SIZE			; update address
	dec rcx
	cmp rcx, 0
	jne lp4

	int2ternary	ans4, tans4		; convert integer to ternary
	printString	hdr				; print header
	printString	tans4			; print answer

; -----
;  Data Set #5

	lea	rdi, [tlet5]			; get address
	mov	rcx, 0
	mov	ecx, dword [len5]		; length
lp5:
	push	rcx					; save registers
	push	rdi
	ternary2int	rdi, tmp		; convert ternary number to integer
	pop	rdi						; restore register
	pop	rcx
	mov	eax, dword [tmp]		; add number to running sum
	add	dword [ans5], eax
	add	rdi, STR_SIZE			; update address
	dec rcx
	cmp rcx, 0
	jne lp5

	int2ternary	ans5, tans5		; convert integer to ternary
	printString	hdr				; print header
	printString	tans5			; print answer

	printString	newLine
	printString	newLine

; -----
;  Done, terminate program.

last:
	mov	eax, SYS_exit			; call code for exit (sys_exit)
	mov	ebx, SUCCESS			; exit with SUCCESS (no error)
	syscall

; *****************************************************************************
