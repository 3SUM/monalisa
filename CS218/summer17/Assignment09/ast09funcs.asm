;  Luis Maya
;  CS 218 Section #1002
;  CS 218 - Assignment 9
;  Provided Functions Template.

; --------------------------------------------------------------------
;  Write the following assembly language procedures / functions.

;  Value returning function readTernaryNumber(), reads a ternary number
;  in ASCII format from the user and convert to an integer.
;  Returns a status code.

;  Void function bubbleSort(), sorts the numbers into ascending order
;  (small to large).  Uses modified bubble sort algorithm (from asst #7).

;  Void function simpleStats(), finds the minimum, maximum, and median for
;  a list of numbers.  Note, for an odd number of items, the median value
;  is defined as the middle value.  For an even number of values,
;  it is the integer average of the two middle values.

;  Value returning function iAverage(), finds the integer average
;  for a list of numbers.

;  Value returning function variance(), finds the variance for a
;  list of numbers.


; ************************************************************************************

section	.data

; -----
;  Define standard constants

TRUE		equ	1
FALSE		equ	0

SUCCESS		equ	0			; Successful operation
NOSUCCESS	equ	1

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

MAXNUM		equ	10000000
BUFFSIZE	equ	50			; 49 chars plus NULL


; -----
;  NO STATIC LOCAL VARIABLES!!
;  ALL LOCALS MUST BE DEFINED ON THE STACK!!


; ********************************************************************************

section	.text

; --------------------------------------------------------------------------------
;  Simple function to read a ternary number in ASCII format
;  from the user and call routine to convert to an integer.
;  Returns a status code (SUCCESS or NOSUCCESS).

; -----
;  HLL Call
;	status = readTernaryNumber(&number);

; -----
;  Arguments passed:
;	1) integer, address - 8, rdi

; -----
;  Returns
;	1) integer - value (via passed address)
;	2) status code - value (via EAX)

global	readTernaryNumber
readTernaryNumber:


;	YOUR CODE GOES HERE
push rbp
mov rbp, rsp
sub rsp, 50								; Create stack based 50 charcters array
sub rsp, 1								; Create tempChar

push rsi
push rcx
push rdx
push rbx
push r12
push r8

; -----
;  Set error message -> "Error, re-enter: ", LF, NULL

	mov	dword [rbp-18], "Erro"
	mov	dword [rbp-14], "r, r"
	mov	dword [rbp-10], "e-en"
	mov	dword [rbp-6], "ter:"
	mov	byte [rbp-2], " "
	mov	byte [rbp-1], NULL

; -----

mov r8, rdi								; Move address of &number into r8
controlStart:
lea rbx, [rbp - 50]						; Grab base address of ternaryString[i]
mov r12, 0								; Charcter Counter, i = 0
leadingSpaces:
	mov rax, SYS_read					; System code for read
	mov rdi, STDIN						; Standard in
	lea rsi, [rbp - 51]					; Move address of tempChar into rsi
	mov rdx, 1							; Amount of charcters to read
	syscall

	mov rax, 0							; Clear rax
	mov al, byte [rbp - 51]				; Get charcter to read, move into al
	cmp al, LF							; Compare charcter with lineFeed
	je readDone							; If charcter is lineFeed, jump to readDone
	cmp al, 0x09						; Compare charcter with tab
	je leadingSpaces					; If chacter is tab, jump to leadingSpaces
	cmp al, 0x20						; Compare chacter with space
	je leadingSpaces					; If chacter is space, jump to leadingSpaces
	jmp firstCharacter
readCharacters:
	mov rax, SYS_read					; System code for read
	mov rdi, STDIN						; Standard in
	lea rsi, [rbp - 51]					; Move address of tempChar into rsi
	mov rdx, 1							; Amount of charcters to read
	syscall

	mov rax, 0							; Clear rax
	mov al, byte [rbp - 51]				; Get charcter to read, move into al
	cmp al, LF							; Compare charcter with lineFeed
	je readDone							; If charcter is lineFeed, jump to readDone
firstCharacter:
	inc r12								; Increase charcter counter, i++
	cmp r12, 31							; Compare charcter counter with BUFFSIZE
	jae readCharacters					; If charcter counter >= to BUFFSIZE jump to readCharacters
	mov byte [rbx], al					; Move charcter into ternaryString[i]
	inc rbx								; Update address for next charcter to be placed
	jmp readCharacters
readDone:
	cmp r12, 31							; Compare charcter counter with BUFFSIZE
	ja overFlow							; If charcter counter > BUFFSIZE, jump to overFlow
	cmp r12, 0							; Compare charcter counter with 0
	je noInput							; If charcter counter = 0, jump to noInput
	mov byte [(rbp - 50) + r12], NULL	; Place NULL at end of ternaryString[i]
	mov rcx, 0							; Clear rcx, will be used as counter to check string
	lea rbx, [rbp - 50]					; Grab base address of ternaryString[i]
ternaryCheck:
	mov rax, 0							; Clear rax
	mov al, byte [rbx + rcx]			; Move ternaryString[i] into al
	cmp al, NULL						; Check if at end of ternaryString[i]
	je convertString					; If at end of ternaryString[i], jump to convertString
	cmp al, "3"							; Compare ternaryString[i] with "3"
	jae notTernary						; If ternaryString[i] >= "3" jump to notTernary
	cmp al, "0"							; Compare ternaryString[i] with "0"
	jb notTernary						; If ternaryString[i] < "0", jump to notTernary
	inc rcx								; Update counter to traverse ternaryString[i]
	jmp ternaryCheck					; If counter < value of total characters, jump to ternaryCheck
convertString:
	mov rsi, r8							; Move address of &number into rsi
	lea rdi, [rbp - 50]					; Move base address of ternaryString[i] into rdi
	call ternary2int					; Call ternary2int function
	cmp eax, FALSE						; Compare returned bool value in eax with false
	je invalidNum						; If bool value is false, jump to invalidNum
	mov rcx, 0							; Clear rcx
	mov ecx, dword [rsi]				; Move number into esi
	cmp ecx, 0							; Compare number with MIN
	jb invalidNum						; If number < MIN, jump to invalidNum
	cmp ecx, MAXNUM						; Compare number with MAXNUM
	ja invalidNum						; If number > MAX, jump to invalidNum
successful:
	mov rax, SUCCESS
	jmp done
noInput:
	mov rax, NOSUCCESS
	jmp done
overFlow:
	lea rdi, [rbp - 18]
	call printString
	jmp controlStart
notTernary:
	lea rdi, [rbp - 18]
	call printString
	jmp controlStart
invalidNum:
	lea rdi, [rbp - 18]
	call printString
	jmp controlStart
done:

pop r8
pop r12
pop rbx
pop rdx
pop rcx
pop rsi

mov rsp, rbp
pop rbp


	ret

; *******************************************************************************
;  Simple function to convert ternary string to integer.
;	Reads string and converts to intger

; -----
;  HLL Call
;	bool = ternary2int(&str, &int);

; -----
;  Arguments passed:
;	1) string, address, rdi
;	2) integer, address, rsi

; -----
;  Returns
;	1) integer value (via passed address)
;	2) bool, TRUE if valid conversion, FALSE for error

global	ternary2int
ternary2int:


;	YOUR CODE GOES HERE
push rbp
mov rbp, rsp
sub rsp, 8

mov dword [rsi], 0
mov dword [rbp - 4], 0					; tempInt; Move 0 into temp [rbp - 4]
mov dword [rbp - 8], 3					; numThree; Move 3 into [rbp - 8]
mov rax, 0								; Clear rax
mov r10, 0								; Clear r10, will be used as counter

spaceCheck:
	movsx eax, byte [rdi + r10]			; Move current character of string[i] into eax
	cmp eax, " "						; Compare current character with " "
	jne controlLoop						; If current character is not " " jump to controlLoop
	inc r10								; Increase counter
	jmp spaceCheck						; Jump to spaceCheck and check next character
controlLoop:
	cmp eax, "-"						; Check if number is negative
	je rmNegSign						; Jump to rmNegSign if number is negative
	cmp eax, "0"						; Check if current charcter is a number
	jae positiveLoop					; If charcter is number, jump to positiveLoop
	inc r10								; Update counter to access first digit if identified as postive
positiveLoop:
	movsx eax, byte [rdi + r10]			; Move first digit into eax
	cmp eax, NULL						; Check if at end of string
	je isValid							; Jump to controlDone if current character is equal to NULL
	cmp eax, 0x20						; Compare current character with space
	je notValid							; If current chacter is space, number is not valid
	cmp eax, "0"						; Check if current character is number
	jae postiveSum						; If character is 0 or above, jump to convert character to number
rmNegSign:
	inc r10								; Update counter to access first digit in string
negativeLoop:
	movsx eax, byte [rdi + r10]			; Move first digit into eax
	cmp eax, NULL						; Check if at end of string
	je negativeDone						; Jump to negativeDone if current character is equal to NULL
	cmp eax, "0"						; Check if current character is number
	jae negativeSum						; If character is 0 or above, jump to convert character to number
postiveSum:
	sub eax, "0"						; "Curr number" - "0" to get number as is
	mov dword [rbp - 4], eax			; Move number to temp storage location
	mov eax, dword [rsi]				; Move current decimal number to eax
	mul dword [rbp - 8]					; Mul current number by three to convert into decimal
	add eax, dword [rbp - 4]			; ans += intDigit
	mov dword [rsi], eax				; Move current value of eax to ans
	inc r10								; Update string counter
	jmp positiveLoop					; Jump to positiveLoop to continue
negativeSum:
	sub eax, "0"						; "Curr number" - "0" to get number as is
	mov dword [rbp - 4], eax			; Move number to temp storage location
	mov eax, dword [rsi]				; Move current decimal number to eax
	mul dword [rbp - 8]					; Mul current number by three to convert into decimal
	add eax, dword [rbp - 4]			; ans += intDigit
	mov dword [rsi], eax				; Move current value of eax to ans
	inc r10								; Update string counter
	jmp negativeLoop					; Jump to negativeLoop to continue
negativeDone:
	mov eax, dword [rsi]				; Move decimal number to eax
	neg eax								; Negate decimal number to get negative
	mov dword [rsi], eax				; Move negative number to ans
isValid:
	mov rax, 0
	mov rax, TRUE						; Move TRUE into eax if conversion successful
	jmp controlDone
notValid:
	mov rax, 0
	mov rax, FALSE						; Move FALSE into eax if conversion unsuccessful
	jmp controlDone
controlDone:
	mov r10, 0


mov rsp, rbp
pop rbp

	ret


; *******************************************************************************
;  Procedure to perform standard bubble sort.
;	Note, sorts in asending order

; -----
;  HLL Call:
;	call bubbleSort(list, len)

;  Arguments Passed:
;	1) list, addr, rdi
;	2) length, value, esi

;  Returns:
;	sorted list (list passed by reference)

global	bubbleSort
bubbleSort:


;	YOUR CODE GOES HERE
push rbp
mov rbp, rsp
sub rsp, 4

mov dword [rbp - 4], 0						; Reset temp to 0
mov rax, 0									; Clear rax
mov rbx, 0									; Clear rbx
mov rcx, 0									; Clear rcx
mov rdx, 0									; Clear rdx
mov r10, 0									; Clear r10
mov r8, 0									; Clear r8

movsxd rcx, esi								; Move length value to rcx
sub rcx, 1									; Length - 1
mov r10b, FALSE								; Move swapped value to al

outerLoopStart:
	mov r10b, FALSE							; Set swapped = FALSE
	mov rbx, 0								; Reset j counter to 0
innerLoopStart:
	mov eax, dword [rdi + rbx * 4]			; Move lst[j] into eax
	mov edx, dword [rdi + (rbx * 4) + 4]	; Move lst[j+1] into edx
	cmp eax, edx							; Compare lst[j] with lst[j+1]
	jbe swapDone							; If lst[j] <= lst[j+1] jump to swapDone
	mov dword [rbp - 4], eax				; Temp = lst[j]
	mov r8d, dword [rbp - 4]				; Move temp value into r8d
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
	ja outerLoopStart						; Jump to outerLoopStart if not at end of traversal
sortDone:

mov rsp, rbp
pop rbp

	ret

; *******************************************************************************
;  Procedure to compute and return simple stats for list:
;	minimum, maximum, median

;   Note, assumes the list is ALREADY sorted.

;   Note, for an odd number of items, the median value is defined as
;   the middle value.  For an even number of values, it is the integer
;   average of the two middle values.
;   The median must be determined after the list is sorted.

; -----
;  HLL Call:
;	call simpleStats(list, len, &min, &max, &med)

; -----
;  Arguments Passed:
;	1) list, addr, rdi
;	2) length, value, esi
;	3) minimum, addr, rdx
;	4) maximum, addr, rcx
;	5) median, addr, r8

;  Returns
;	results via passed addresses

global simpleStats
simpleStats:


;	YOUR CODE GOES HERE
push rbp
mov rbp, rsp
sub rsp, 8

mov dword [rbp - 4], 2					; Move 2 into [rbp - 4]
mov dword [rbp - 8], 4					; Move 4 into [rbp - 8]

mov rax, 0								; Clear rax register
movsxd r9, esi							; Set r9 to length value
mov eax, dword [rdi]					; Move lst[i] into eax
mov dword [rdx], eax					; Set min to first value in lst[i]
dec r9									; Length - 1
mov eax, dword [rdi + r9 * 4]			; Move lst[length - 1] into eax
mov dword [rcx], eax					; Set max to lst[length - 1] value


midLoop:
	mov eax, esi        					; Move len value into eax
	mov edx, 0
	div dword [rbp - 4]         			; len/2
	cmp edx, 0
	jne oddLoop                 			; If length is odd jump to oddLoop
	mov eax, esi        					; Move value of len into eax
	sub eax, 1                  			; Find first mid value, Length - 1
	mov edx, 0
	div dword [rbp - 4]         			; (Length - 1)/2
	mul dword [rbp - 8]        				; Get address of first middle value
	movsxd r9, eax                			; Move address value of first middle value to midOne
	mov eax, dword [rdi + r9]  				; Move value of lst[first middle value] into eax
	add r9, 4                  				; Get address of second middle value
	mov r10d, dword [rdi + r9]  			; Move value of lst[second middle value] into r10d
	add eax, r10d                			; Add first and second middle value, store in eax
	mov edx, 0
	div dword [rbp - 4]         			; Divide eax to find average of middle values
	jmp midDone
oddLoop:
	mov eax, esi        					; Move value of len into eax
	sub eax, 1                  			; Find middle value, Length - 1
	mov edx, 0
	div dword [rbp - 4]         			; (Length - 1)/2
	mul dword [rbp - 8]        				; Get address of middle value and store it in eax
	movsxd r9, eax                			; Move address of middle value to r9
	mov eax, dword [rdi + r9]  				; Move value of middle value to eax
	jmp midDone
midDone:
	mov dword [r8], eax     				; Move middle value into lstMid

mov rsp, rbp
pop rbp

	ret

; *******************************************************************************
;  Function to compute and return integer average for a list of numbers.

; -----
;  HLL Call:
;	ave = iAverage(list, len)

; -----
;  Arguments Passed:
;	1) list, addr, rdi
;	2) length, value, esi

;  Returns
;	integer average - value (in eax)

global iAverage
iAverage:


;	YOUR CODE GOES HERE
push rbp
mov rbp, rsp
sub rsp, 4

mov rax, 0									; Clear rax register
mov rbx, 0									; Clear rbx
mov rcx, 0									; Clear rcx
mov dword [rbp - 4], 0						; Reset tmpSum
movsxd rcx, esi								; Move length value into rcx

sumLoop:
	mov eax, dword [rdi + rbx * 4]			; Move lst[i] into eax
	add dword [rbp - 4], eax				; tmpSum += lst[i]
	inc rbx									; Update i counter
	cmp rbx, rcx							; Compare current i to length
	jl sumLoop								; If i < length
sumLoopDone:
	mov eax, dword [rbp - 4]				; Move tmpSum into eax
	mov edx, 0
	div rcx									; tmpSum/length to find average

mov rsp, rbp
pop rbp

	ret

; *******************************************************************************
;  Function to compute and return the variance of a list.
;	Note, uses iaverage to find the average for the calculations.

; -----
;  HLL Call:
;	var = variance(list, len)

; ----
;  Arguments Passed:
;	1) list, addr, rdi
;	2) length, value, esi

;  Returns:
;	variance - value (in edx:eax)

global variance
variance:


;	YOUR CODE GOES HERE
push rbp
mov rbp, rsp
sub rsp, 8

call iAverage
movsxd r10, eax								; Move average into r10
mov rax, 0									; Clear rax register
mov rbx, 0									; Clear rbx register
mov rcx, 0									; Clear rcx register
mov qword [rbp - 8], 0						; Reset tmpVar
movsxd rcx, esi								; Move length value into rcx

summationLoop:
	movsxd rax , dword [rdi + rbx * 4]		; Move lst[i] into rax
	sub rax, r10							; lst[i] - average
	mul rax									; Square the result
	add qword [rbp - 8], rax				; tmpVar += (lst[i] - average)^2
	inc rbx									; Update counter i++
	cmp rbx, rcx							; Compare i with length
	jl summationLoop						; If i < length, keep looping
summationDone:
	mov rax, qword [rbp - 8]				; Result in rax

mov rsp, rbp
pop rbp

	ret

; ********************************************************************************
;  Generic function to display a string to the screen.
;  String must be NULL terminated.

;  Algorithm:
;	Count characters in string (excluding NULL)
;	Use syscall to output characters

; -----
;  HLL Call:
;	printString(stringAddr);

;  Arguments:
;	1) address, string, rdi
;  Returns:
;	nothing

global	printString
printString:

; -----
;  Count characters to write.

	mov	rdx, 0
strCountLoop:
	cmp	byte [rdi+rdx], NULL
	je	strCountLoopDone
	inc	rdx
	jmp	strCountLoop
strCountLoopDone:
	cmp	rdx, 0
	je	printStringDone

; -----
;  Call OS to output string.

	mov	rax, SYS_write		; system code for write()
	mov	rsi, rdi			; address of char to write
	mov	rdi, STDOUT			; file descriptor for std in
							; rdx=count to write, set above
	syscall					; system call

; -----
;  String printed, return to calling routine.

printStringDone:
	ret

; ********************************************************************************
