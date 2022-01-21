;  CS 218 - Assignment 8
;  Functions Template.

; --------------------------------------------------------------------
;  Write assembly language functions.

;  The function, bubbleSort(), sorts the numbers into descending
;  order (large to small).  Uses the bubble sort algorithm from
;  assignment #7 (modified to sort in descending order).

;  The function, basicStats(), finds the minimum, median, and maximum
;  for a list of numbers.

;  The function, iAvergae(), computes the integer average for a
;  list of numbers.

;  The function, variance(), to compute the variance for a
;  list of numbers.

;  Note, all data is signed!


; ********************************************************************************

section	.data

; -----
;  Define standard constants.

LF		equ	10			; line feed
CR		equ	13			; carridge return
NULL		equ	0			; end of string

TRUE		equ	0
FALSE		equ	-1

SUCCESS		equ	0			; Successful operation
NOSUCCESS	equ	1			; Unsuccessful operation

STDIN		equ	0			; standard input
STDOUT		equ	1			; standard output
STDERR		equ	2			; standard error

SYS_exit	equ	1			; system call code for terminate
SYS_fork	equ	2			; system call code for fork
SYS_read	equ	3			; system call code for read
SYS_write	equ	4			; system call code for write
SYS_open	equ	5			; system call code for file open
SYS_close	equ	6			; system call code for file close
SYS_create	equ	8			; system call code for file open/create


; -----
;  Local variables for bubbleSort() procedure (if any)

swapped		db	FALSE
j			dd	0
tmp			dd	0


; -----
;  Local variables for simpleStats() procedure (if any)

dtwo		dd	2
numFour		dd	4

; -----
;  Local variables for iAverage() function (if any)

tmpSum		dd	0

; -----
;  Local variables for variance() function (if any)

tmpVar		dq	0



; ********************************************************************************

section	.text

; *******************************************************************************
;  Function to implement bubble sort to srot an integer array.
;	Note, sorts in desending order

; -----
;  Bubble Sort Algorithm:

;	for ( i = (len-1) to 0 )
;	     swapped = false
;	     for ( j = 0 to i )
;	         if ( lst(j) > lst(j+1) )
;	             tmp = lst(j)
;	             lst(j) = lst(j+1)
;	             lst(j+1) = tmp
;	             swapped = true
;	         }
;	     if ( swapped = false ) exit
;	}

; -----
;  HLL Call:
;	bubbleSort(list, len)

;  Arguments Passed:
;	1) list, addr, rdi
;	2) length, value, esi

;  Returns:
;	sorted list (list passed by reference)

global	bubbleSort
bubbleSort:


;	YOUR CODE GOES HERE
mov rbx, 0									; Clear rbx
mov rcx, 0									; Clear rcx
mov r10, 0									; Clear r10
mov r8, 0									; Clear r8
movsxd rbx, dword [j]						; Move j counter to rbx
movsxd rcx, esi								; Move length value to rcx
sub rcx, 1									; Length - 1
mov r10b, byte [swapped]					; Move swapped value to al

outerLoopStart:
	mov r10b, FALSE							; Set swapped = FALSE
	mov ebx, 0								; Reset j counter to 0
innerLoopStart:
	mov eax, dword [rdi + rbx * 4]			; Move lst[j] into eax
	mov edx, dword [rdi + (rbx * 4) + 4]	; Move lst[j+1] into edx
	cmp eax, edx							; Compare lst[j] with lst[j+1]
	jge swapDone							; If lst[j] => lst[j+1] jump to swapDone
	mov dword [tmp], eax					; Temp = lst[j]
	mov r8d, dword [tmp]					; Move temp value into r8d
	mov dword [rdi + rbx * 4], edx			; lst[j] = lst[j+1]
	mov dword [rdi + (rbx * 4) + 4], r8d	; lst[j+1] = tmp
	mov r10b, TRUE							; swapped = TRUE
swapDone:
	inc rbx									; Update j++ counter
	cmp rbx, rcx							; j to length - 1
	jl innerLoopStart						; If j <= length - 1, loop again
innerLoopDone:
	cmp r10b, FALSE							; Compare swapped value with false
	je sortDone								; If swapped = false, jump to sortDone
	dec rcx									; Decrease length--
	cmp rcx, 0								; Compare (len-1) to 0
	jg outerLoopStart						; Jump to outerLoopStart if not at end of traversal
sortDone:

	ret

; *******************************************************************************
;  Find simple statistical information of an integer array:
;	minimum, median, and maximum

;  Note, for an odd number of items, the median value is defined as
;  the middle value.  For an even number of values, it is the integer
;  average of the two middle values.

;  Note, you may assume the list is already sorted.

; -----
;  HLL Call:
;	simpleStats(list, len, min, max, med)

;  Arguments Passed:
;	1) list, addr, rdi
;	2) length, value, esi
;	3) minimum, addr, rdx
;	4) maximum, addr, rcx
;	5) median, addr, r8

;  Returns:
;	minimum, median, and maximum via
;	pass-by-reference

global simpleStats
simpleStats:


;	YOUR CODE GOES HERE
mov rax, 0								; Clear rax register
movsxd r9, esi							; Set r9 to length value
mov eax, dword [rdi]					; Move lst[i] into eax
mov dword [rcx], eax					; Set max to first value in lst[i]
dec r9									; Length - 1
mov eax, dword [rdi + r9 * 4]			; Move lst[length - 1] into eax
mov dword [rdx], eax					; Set min to lst[length - 1] value


midLoop:
	mov eax, esi        					; Move len value into eax
	cdq
	idiv dword [dtwo]         				; len/2
	cmp edx, 0
	jne oddLoop                 			; If length is odd jump to oddLoop
	mov eax, esi        					; Move value of len into eax
	sub eax, 1                  			; Find first mid value, Length - 1
	cdq
	idiv dword [dtwo]         				; (Length - 1)/2
	imul dword [numFour]        			; Get address of first middle value
	movsxd r9, eax                			; Move address value of first middle value to midOne
	mov eax, dword [rdi + r9]  				; Move value of lst[first middle value] into eax
	add r9, 4                  				; Get address of second middle value
	mov r10d, dword [rdi + r9]  			; Move value of lst[second middle value] into r10d
	add eax, r10d                			; Add first and second middle value, store in eax
	cdq
	idiv dword [dtwo]         				; Divide eax to find average of middle values
	jmp midDone
oddLoop:
	mov eax, esi        					; Move value of len into eax
	sub eax, 1                  			; Find middle value, Length - 1
	cdq
	idiv dword [dtwo]         				; (Length - 1)/2
	imul dword [numFour]        			; Get address of middle value and store it in eax
	movsxd r9, eax                			; Move address of middle value to r9
	mov eax, dword [rdi + r9]  				; Move value of middle value to eax
	jmp midDone
midDone:
	mov dword [r8], eax     				; Move middle value into lstMid

	ret

; *******************************************************************************
;  Function to calculate the integer average of an integer array.

; -----
;  Call:
;	ave = iAverage(list, len)

;  Arguments Passed:
;	1) list, addr - rdi
;	2) length, value -	esi

;  Returns:
;	integer average - value (in eax)

global iAverage
iAverage:


;	YOUR CODE GOES HERE
mov rax, 0									; Clear rax register
mov rbx, 0									; Clear rbx
mov rcx, 0									; Clear rcx
mov dword [tmpSum], 0						; Reset tmpSum
movsxd rcx, esi								; Move length value into rcx

sumLoop:
	mov eax, dword [rdi + rbx * 4]			; Move lst[i] into eax
	add dword [tmpSum], eax					; tmpSum += lst[i]
	inc rbx									; Update i counter
	cmp rbx, rcx							; Compare current i to length
	jl sumLoop								; If i < length
sumLoopDone:
	mov eax, dword [tmpSum]					; Move tmpSum into eax
	cdq
	idiv rcx								; tmpSum/length to find average

	ret

; *******************************************************************************
;  Function to calculate the variance of an integer array.
;  Must use iAverage() function to find average.

; -----
;  Call:
;	var = variance(list, len)

;  Arguments Passed:
;	1) list, addr, rdi
;	2) length, value, esi

;  Returns:
;	variance - value (quad)

global variance
variance:


;	YOUR CODE GOES HERE
call iAverage
movsxd r10, eax								; Move average into r10
mov rax, 0									; Clear rax register
mov rbx, 0									; Clear rbx register
mov rcx, 0									; Clear rcx register
mov qword [tmpVar], 0						; Reset tmpVar
movsxd rcx, esi								; Move length value into rcx

summationLoop:
	movsxd rax , dword [rdi + rbx * 4]		; Move lst[i] into rax
	sub rax, r10							; lst[i] - average
	imul rax								; Square the result
	add qword [tmpVar], rax					; tmpVar += (lst[i] - average)^2
	inc rbx									; Update counter i++
	cmp rbx, rcx							; Compare i with length
	jl summationLoop						; If i < length, keep looping
summationDone:
	mov rax, qword [tmpVar]					; Result in rax

	ret


; ********************************************************************************
