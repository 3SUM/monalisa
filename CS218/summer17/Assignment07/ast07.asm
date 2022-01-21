; Luis Maya
; CS 218 Section #1002
; Assignment #7
; Example Solution.

;  Sort a list of number using the bubble sort algorithm.
;  Also finds the minimum, median, maximum, and average of the list.

; -----
;  Bubble Sort Algorithm

;	for ( i = (len-1) to 0 )	{
;	     swapped = false
;	     for ( j = 0 to i )	{
;	         if ( lst(j) > lst(j+1) )
;	             tmp = lst(j)
;	             lst(j) = lst(j+1)
;	             lst(j+1) = tmp
;	             swapped = true
;	         }
;	     if ( swapped = false ) exit
;	}

; --------------------------------------------------------------
;  Macro, "int2ternary", to convert a signed base-10 integer into
;  an ASCII string representing the ternary value.  The macro stores
;  the result into an ASCII string (byte-size, right justified,
;  blank filled, NULL terminated).  Each integer is a doubleword value.
;  Assumes valid/correct data.  As such, no error checking is performed.


%macro	int2ternary	2


;	YOUR CODE GOES HERE...
mov rsi, 0								; Character counter = 0


%%signCheck:
	cmp %1, 0							; Check if decimal number is postive or negative
	jge %%posConversion					; If postive, jump to posConversion
	neg %1								; If negative, negate number then jump to negConversion
	jmp %%negConversion
%%posConversion:
	cqo
	idiv qword [numThree]				; Divide decimal number by 3 repeatedly to convert to base 3
	push rdx							; Remainder will be stored, push onto stack
	inc rsi								; Increase character counter
	cmp %1, 0							; Compare current value in eax with 0 to determine if conversion is done
	jne %%posConversion					; Keep converting if not done
	mov rcx, MAX_STR_SIZE				; Move max size of string (10) into rcx
	sub rcx, rsi						; Subtract the max size of the string with current char counter to determine spaces
	dec rcx								; Subtract the amount of spaces by 1 to take into account sign
	mov rdi, 0							; Counter for string
	mov rbx, %2							; Move address of tans0 into rbx
	cmp rcx, 0
	je %%setPosSign
	jmp %%setPosSpaces
%%negConversion:
	cqo
	idiv qword [numThree]				; Divide decimal number by 3 repeatedly to convert to base 3
	push rdx							; Remainder will be stored, push onto stack
	inc rsi								; Increase character counter
	cmp %1, 0							; Compare current value in eax with 0 to determine if conversion is done
	jne %%negConversion					; Keep converting if not done
	mov rcx, MAX_STR_SIZE				; Move max size of string (10) into rcx
	sub rcx, rsi						; Subtract the max size of the string with current char counter to determine spaces
	dec rcx								; Subtract the amount of spaces by 1 to take into account sign
	mov rdi, 0							; Counter for string
	mov rbx, %2							; Move address of tans0 into rbx
	cmp rcx, 0
	je %%setNegSign
	jmp %%setNegSpaces
%%setPosSpaces:
	mov byte [rbx + rdi], " "			; Add space to current index in string
	inc rdi								; Update counter to traverse string
	loop %%setPosSpaces					; Decrease rcx; number of spaces left to place in string; loop if != 0
%%setPosSign:
	mov byte [rbx + rdi], "+"			; Add "+" after spaces are complete
	inc rdi								; Update counter to traverse string
	mov rcx, rsi						; Move value of digits left to place in string to rcx
	jmp %%popLoop						; Jump to popLoop
%%setNegSpaces:
	mov byte [rbx + rdi], " "			; Add space to current index in string
	inc rdi								; Update counter to traverse string
	loop %%setNegSpaces					; Decrease rcx; number of spaces left to place in string; loop if != 0
%%setNegSign:
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

; ---------------------------------------------

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

LF		equ	10
NULL	equ	0
ESC		equ	27

; -----
;  Misc. constants

MAX_STR_SIZE	equ	16

; -----
;  String definitions

newLine		db	LF, NULL

hdr		db	LF, "**********************************"
		db	LF, "CS 218 - Assignment #7", LF
		db	LF, "List Statistics:"
		db	LF, LF, NULL

lstMin		db	"List Minimum: ", NULL
lstMed		db	"List Median:  ", NULL
lstMax		db	"List Maximum: ", NULL
lstSum		db	"List Sum:     ", NULL
lstAve		db	"List Average: ", NULL

; -----
;  Provided data.

lst		dd	 1113, -1232,  2146,  1376,  5120
		dd	 2356,  3164,  4565,  3155,  3157
		dd	 6759,  6326,   171,   147, -5628
		dd	 7527,  7569,  1177,  6785,  3514
		dd	-1001,   128,  1133,  1105, -3327
		dd	  101,   115,  1108,  2233, -2115
		dd	 1227,  1226,  5129,   117,   107
		dd	  105,   109,  1730, -1150,  3414
		dd	 1107,  6103,  1245,  6440,  1465
		dd	 2311,   254,  4528,  1913,  6722
		dd	-1149,  2126,  5671,  4647,  4628
		dd	 -327, -2390,  1177,  8275,  5614
		dd	 3121,   415,  -615,   122,  7217
		dd	    1,   410, -1129,  -812,  2134
		dd	-1221, -2234,  6151,   432,   114
		dd	 1629,   114,   522,  2413,   131
		dd	 5639,   126,  1162,   441,   127
		dd	 -877,   199,  5679, -1101,  3414
		dd	-2101,   133,  1133,  2450,  4532
		dd	 8619,   115,  1618,  1113,  -115
		dd	 1219,  3116,  -612,   217,   127
		dd	 6787,  4569,   679, -5675,  4314
		dd	 1104,  6825,  1184,  2143,  1176
		dd	  134, -4626,   100,  4566,  2346
		dd	 1214,  6786,  1617,   183, -3512
		dd	 7881, -8320,  3467,  4559, -1190
		dd	  103,   112,  1146,  2186,   191
		dd	  186,   134,  1125, -5675,  3476
		dd	 2137,  2113, -1647,   114,   115
		dd	-6571, -7624,   128,   113,  3112
		dd	 1724,  6316,  1217,  2183, -4352
		dd	  121,   320,  4540,  5679, -1190
		dd	-9125,   116,  1122,   117,   127
		dd	 5677,   101,  3727, -1125,  3184
		dd	 1897,  6374,  1190,     0,  1224
		dd	  125,   116,  8126,  6784, -2329
		dd	 1104,   124,  1112,   143,   176
		dd	 7534,  2126,  6112,   156,  1103
		dd	 1153,   172, -1146,  2176,   170
		dd	  156,   164,   165,  -155,  5156
		dd	  894,  6325,  1184,   143,   276
		dd	 5634,  7526,  3413,  7686,  7563
		dd	  511, -6383,  1133,  2150,  -825
		dd	 5721,  5615,  4568,  7813,  1231
		dd	  169,   146, -1162,   147,   157
		dd	  167,   169,   177,   175,  2144
		dd	 5527,  1344,  1130,  2172,   224
		dd	 7525,  5616,  5662,  6328,  2342
		dd	  181,   155,  1145,   132,   167
		dd	  185,   150,   149,   182,  1434
		dd	 6581,  3625,  6315,     1,  -617
		dd	 7855,  6737,   129,  4512,  1134
		dd	  177,   164,  1160,  1172,   184
		dd	  175,   166,  6762,   158,  4572
		dd	 6561,  1283,  1133,  1150,   135
		dd	 5631, -8185,   178, -1197,  1185
		dd	 5649,  6366,  1162,  1167,   167
		dd	-1177,   169,  1177,   175,  1169
		dd	 5684,  2179,  1117,  3183,   190
		dd	 1100, -4611,  1123,  3122,  -131

len		dd	300

min		dd	0
med		dd	0
max		dd	0
sum		dd	0
avg		dd	0


; -----
;  Misc. data definitions (if any).

swapped		db	TRUE

weight		dd	3
dtwo		dd	2

i	dd	0
j	dd	0
tmp dd	0
numFour	dd	4
numThree	dq	3

; -----

section	.bss
tempString	resb	MAX_STR_SIZE


; ---------------------------------------------

section	.text
global	_start
_start:


;	YOUR CODE GOES HERE...
mov esi, dword [i]						; Move i counter to esi
mov edi, dword [j]						; Move j counter to edi
mov ecx, dword [len]					; Move length value to ecx
sub ecx, 1								; Length - 1
mov r11d, ecx
mov r10b, byte [swapped]				; Move swapped value to al

outerLoopStart:
	mov r10b, FALSE							; Set swapped = FALSE
	mov edi, 0								; Reset j counter
innerLoopStart:
	movsxd rax, dword [lst + edi * 4]		; Move lst[j] into eax
	movsxd rbx, dword [lst + (edi * 4) + 4]	; Move lst[j+1] into ebx
	cmp rax, rbx							; Compare lst[j] with lst[j+1]
	jle swapDone							; If lst[j] <= lst[j+1] jump to swapDone
	mov dword [tmp], eax					; Temp = lst[j]
	mov r8d, dword [tmp]					; Move temp value into r8d
	mov dword [lst + edi * 4], ebx			; lst[j] = lst[j+1]
	mov dword [lst + (edi * 4) + 4], r8d	; lst[j+1] = tmp
	mov r10b, TRUE							; swapped = TRUE
swapDone:
	inc edi									; Update j++ counter
	cmp edi, r11d							; j to length - 1
	jl innerLoopStart						; If j < length - 1, loop again
innerLoopDone:
	cmp r10b, FALSE							; Compare swapped value with false
	je sortDone								; If swapped = false, jump to sortDone
	dec r11d								; Decrease length--
	cmp r11d, 0								; Compare (len-1) to 0
	jg outerLoopStart						; Jump to outerLoopStart if not at end of traversal
sortDone:
	mov ecx, dword [len]					; Reset ecx to length value
	mov eax, dword [lst + esi * 4]			; Move lst[i] into eax
	mov dword [min], eax					; Set min to first value in lst[i]
	dec ecx									; Length - 1
	mov eax, dword [lst + ecx * 4]			; Move lst[length - 1] into eax
	mov dword [max], eax					; Set max to lst[length - 1] value
statsLoop:
	mov eax, dword [lst + esi * 4]			; Move lst[i] into eax
	add dword [sum], eax					; sum += lst[i]
	inc esi									; Update i counter
	cmp esi, dword [len]					; Compare i counter with length
	jl statsLoop							; If i < length continue to loop
	mov eax, dword [sum]					; Move sum value into eax
	cdq
	idiv dword [len]						; Sum/length stored in eax
	mov dword [avg], eax					; Move eax value into average
midLoop:
	mov eax, dword [len]        			; Move len value into eax
	cdq
	idiv dword [dtwo]         				; len/2
	cmp edx, 0
	jne oddLoop                 			; If length is odd jump to oddLoop
	mov eax, dword [len]        			; Move value of len into eax
	sub eax, 1                  			; Find first mid value, Length - 1
	cdq
	idiv dword [dtwo]         				; (Length - 1)/2
	imul dword [numFour]        			; Get address of first middle value
	mov esi, eax                			; Move address value of first middle value to midOne
	mov eax, dword [lst + esi]  			; Move value of lst[first middle value] into ebx
	add esi, 4                  			; Get address of second middle value
	mov ecx, dword [lst + esi]  			; Move value of lst[second middle value] into ecx
	add eax, ecx                			; Add first and second middle value, store in ebx
	cdq
	idiv dword [dtwo]         				; Divide eax to find average of middle values
	jmp midDone
oddLoop:
	mov eax, dword [len]        			; Move value of len into eax
	sub eax, 1                  			; Find middle value, Length - 1
	cdq
	idiv dword [dtwo]         				; (Length - 1)/2
	imul dword [numFour]        			; Get address of middle value and store it in eax
	mov esi, eax                			; Move address of middle value to rsi
	mov eax, dword [lst + esi]  			; Move value of middle value to eax
	jmp midDone
midDone:
	mov dword [med], eax     				; Move middle value into lstMid

; -----
;  Output results to console.
;	Convert each result into a string
;	Display header and then ASCII/ternary string

	printString	hdr

	printString	lstMin
	movsxd	rax, dword [min]
	int2ternary	eax, tempString
	printString	tempString
	printString	newLine

	printString	lstMed
	mov	eax, dword [med]
	int2ternary	eax, tempString
	printString	tempString
	printString	newLine

	printString	lstMax
	mov	eax, dword [max]
	int2ternary	eax, tempString
	printString	tempString
	printString	newLine

	printString	lstSum
	mov	eax, dword [sum]
	int2ternary	eax, tempString
	printString	tempString
	printString	newLine

	printString	lstAve
	mov	eax, dword [avg]
	int2ternary	eax, tempString
	printString	tempString
	printString	newLine

	printString	newLine

; -----
;  Done, terminate program.

last:
	mov	eax, SYS_exit			; call code for exit (sys_exit)
	mov	ebx, SUCCESS			; exit with SUCCESS (no error)
	syscall
