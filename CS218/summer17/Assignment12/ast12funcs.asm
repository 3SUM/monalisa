; Luis Maya
; CS 218 Section #1002
; Assignment #12
; Provided template

; ***************************************************************

section	.data

; -----
;  Define standard constants.

LF			equ	10			; line feed
NULL		equ	0			; end of string
ESC			equ	27			; escape key

TRUE		equ	1
FALSE		equ	-1

SUCCESS		equ	0			; Successful operation
NOSUCCESS	equ	1			; Unsuccessful operation

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

SYS_NPROCESSORS	equ	0x53			; system call code for number of processors

; -----
;  Message strings

LIMIT		equ	0x70000000
;LIMIT		equ	0x64

header			db	LF, "*******************************************", LF
				db	ESC, "[1m", "Program Start", ESC, "[0m", LF, LF, NULL

msgFinal		db	"Final Counter Value should be: ", NULL
msgDoneMain		db	"Sequential Counter -> Final Value: ", NULL
msgDoneThread	db	"Parrellel Counter -> Final Value: ", NULL

msgProgDone		db	LF, "Completed.", LF, NULL

SeqMsgStart		db	LF, "--------------------------------------", LF
				db	"Compute Formula -> Sequential", LF, NULL
ParMsgStart		db	LF, "--------------------------------------", LF
				db	"Compute Formula -> Parrellel", LF, NULL

errUsage		db	"Usage: ast12 <-sq|-pt>", LF, NULL
errSpec			db	"Error, invalid argument.", LF, NULL

coreCount		db	"CPU Cores: "
cores			db	"?", LF, NULL

; -----
;  Constants and global variable

A		equ	2
B		equ	2
C		equ	1
SEQ		equ	1
PAR		equ	2

STR_SIZE	equ	25

optFlag		db	SEQ
myValue		dd	0

weight		dd	3

; -----
;  Thread data structures

pthreadID0	dd	0, 0, 0, 0, 0
pthreadID1	dd	0, 0, 0, 0, 0

; -----
;  Local variables for compute functions.

msgMain		db	" ...Main starting...", LF, NULL
msgThread0	db	" ...Thread 0 starting...", LF, NULL
msgThread1	db	" ...Thread 1 starting...", LF, NULL

; -----
;  Local variables for printMessageValue

newLine		db	LF, LF, NULL

section	.bss
tmpString	resb	STR_SIZE


; ***************************************************************

section	.text

extern	pthread_create, pthread_join
extern  sysconf

global main
main:

; -----
;  Check argument count, rdi
;  Check argument


;	YOUR CODE GOES HERE
getArguments:
	cmp rdi, 1						; Compare argc to 1
	je usageMessage					; If argc == 1, jump to usageMessage
	cmp rdi, 2						; Compare argc to 2
	jne invalidArgc					; If argc != 2, jump to errorMessage

mov rbx, 0							; Clear rbx
mov rbx, qword [rsi + 8]			; Move address of argv[1][i] into rbx
specifierCheck:
	cmp dword [rbx], 0x0071732d		; Compare argv[1][i] with "-sq", NULL
	je validSpecifier				; If argv[1][i] == "-sq", NULL, jump to validSpecifier
	cmp dword [rbx], 0x0074702d		; Compare argv[1][i] with "-pt", NULL
	je validSpecifier				; If argv[1][i] == "-pt", NULL, jump to validSpecifier
	jmp invalidSpecifier			; If none of the above, jump to invalidSpecifier

validSpecifier:

; -----
;  Get the number of cores and display to the screen.
;	Not needed for anything, but kinda interesting...

	mov	rdi, SYS_NPROCESSORS
	call	sysconf

	add	al, "0"
	mov	byte [cores], al

; -----
;  Initial actions:
;	Display start message
;	Display final value in ternary (for reference)
;	Display message for sequential, non-threaded start message

	mov	rdi, header
	call	printString

	mov	rdi, coreCount
	call	printString

	mov	rdi, msgFinal
	mov	rsi, LIMIT
	call printSummary

; -----
;  Jump to doSequential or doParrallel

	cmp dword [rbx], 0x0071732d		; Compare argv[1] with "-sq", NULL
	je doSequential					; If argv[1] == "-sq", NULL, jump to doSequential

	cmp dword [rbx], 0x0074702d		; Compare argv[1] with "=pt", NULL
	je doParrallel					; If argv[1] == "-pt", NULL, jump to doParrallel

	jmp progDone

; -----
;  Compute formula - sequential, non-threaded

doSequential:
	mov	dword [myValue], 0			; initialize counter to 0

	mov	rdi, SeqMsgStart
	call	printString

; -----
;  Create new thread 0
;	pthread_create(&pthreadID0, NULL, &threadFunction0, NULL);

	mov rdi, msgThread0
	call printString

	mov	rdi, pthreadID0
	mov	rsi, NULL
	mov	rdx, threadFunction0
	mov	rcx, NULL
	call	pthread_create

;  Wait for thread to complete.
;	pthread_join (pthreadID0, NULL);

	mov	rdi, qword [pthreadID0]
	mov	rsi, NULL
	call	pthread_join

; -----
;  Create new thread 1
;	pthread_create(&pthreadID1, NULL, &threadFunction1, NULL);

	mov rdi, msgThread1
	call printString

	cmp threadCount, 4
	je fourThreads
	cmp threadCount, 3
	je threeThreads
	cmp threadCount, 2
	je twoThreads
	cmp threadCount, 1
	je oneThread

fourThreads:
	mov	rdi, pthreadID0
	mov	rsi, NULL
	mov	rdx, threadFunction1
	mov	rcx, NULL
	call	pthread_create
threeThreads:
	mov	rdi, pthreadID1
	mov	rsi, NULL
	mov	rdx, threadFunction1
	mov	rcx, NULL
	call	pthread_create
twoThreads:
	mov	rdi, pthreadID2
	mov	rsi, NULL
	mov	rdx, threadFunction1
	mov	rcx, NULL
	call	pthread_create
oneThread:
	mov	rdi, pthreadID3
	mov	rsi, NULL
	mov	rdx, threadFunction1
	mov	rcx, NULL
	call	pthread_create

;  Wait for thread to complete.
;	pthread_join (pthreadID1, NULL);

	mov	rdi, qword [pthreadID1]
	mov	rsi, NULL
	call	pthread_join

; -----
;  Display final result for sequential, non-threaded result.

	mov	rdi, msgDoneMain
	mov	esi, dword [myValue]
	call	printSummary

	mov	rdi, msgProgDone
	call	printString

	jmp	progDone

; -----
;  Compute formula - parrallel, threaded
;  Display message for threaded start


;	YOUR CODE GOES HERE

doParrallel:
	mov dword [myValue], 0			; Move 0 into myValue

	mov rdi, ParMsgStart			; Move ParMsgStart into rdi
	call printString				; Call printString

; 	-----
;  	Create new thread 0
;	pthread_create(&pthreadID0, NULL, &threadFunction0, NULL);

	mov rdi, msgThread0
	call printString

	mov	rdi, pthreadID0
	mov	rsi, NULL
	mov	rdx, threadFunction0
	mov	rcx, NULL
	call	pthread_create

; 	-----
; 	 Create new thread 1
;	pthread_create(&pthreadID1, NULL, &threadFunction1, NULL);


	mov rdi, msgThread1
	call printString

	mov	rdi, pthreadID1
	mov	rsi, NULL
	mov	rdx, threadFunction1
	mov	rcx, NULL
	call	pthread_create

;  Wait for thread to complete.
;	pthread_join (pthreadID0, NULL);

	mov	rdi, qword [pthreadID0]
	mov	rsi, NULL
	call	pthread_join


; 	 Wait for thread to complete.
;	 pthread_join (pthreadID1, NULL);

	mov	rdi, qword [pthreadID1]
	mov	rsi, NULL
	call	pthread_join

; -----
;  Display final result for parrallel, threaded result.

	mov	rdi, msgDoneThread
	mov	esi, dword [myValue]
	call printSummary

	mov	rdi, msgProgDone
	call	printString

	jmp	progDone

; -----
;  Errors check

usageMessage:
	mov rdi, errUsage
	call printString
	jmp progDone
invalidArgc:
	mov rdi, errSpec
	call printString
	jmp progDone
invalidSpecifier:
	mov rdi, errSpec
	call printString

; -----
;  Program done, terminate.

progDone:
	mov	rax, SYS_exit			; system call for exit
	mov	rdi, SUCCESS			; return code SUCCESS
	syscall

; =====================================================================
;  Thread function #0
;	Accesses a global variable 'myValue'
;	Computes -> myValue = A * myValue / B + C

; -----
;  Arguments:
;	N/A (global variable accessed)
;  Returns:
;	N/A (global variable accessed)


;	YOUR CODE GOES HERE

global threadFunction0
threadFunction0:

	mov rcx, LIMIT						; Move limit value into rcx
	shr rcx, 1 							; LIMIT/2

IncreaseLoop0:
	mov rax , 0							; Clear rax
	mov eax, dword [myValue] 			; Move myValue value into eax
	mov rbx, A  						; Move A value into rbx

	mul ebx 							; (myValue * A) stored in eax
	mov rbx, B 							; Move B value into rbx

	div ebx 							; (myValue * A)/B stored in eax
	mov rbx, C							; Move C value into rbx

	add eax, ebx						; ((myValue * A)/B) + C stored in eax
	mov dword [myValue], eax            ; Move ((myValue * A)/B) + C into myValue

	loop IncreaseLoop0

	ret


; =====================================================================
;  Thread function #1
;	Accesses a global variable 'myValue'
;	Computes -> myValue = A * myValue / B + C
;	Loops LIMIT/2 times

; -----
;  Arguments:
;	N/A (global variable accessed)
;  Returns:
;	N/A (global variable accessed)


;	YOUR CODE GOES HERE

global threadFunction1
threadFunction1:

	mov rcx, LIMIT						; Move limit value into rcx
	shr rcx, 1 							; LIMIT/2

IncreaseLoop1:
	mov rax , 0							; Clear rax
	mov eax, dword [myValue] 			; Move myValue value into eax
	mov rbx, A  						; Move A value into rbx

	mul ebx 							; (myValue * A) stored in eax
	mov rbx, B 							; Move B value into rbx

	div ebx 							; (myValue * A)/B stored in eax
	mov rbx, C							; Move C value into rbx

	add eax, ebx						; ((myValue * A)/B) + C stored in eax
	mov dword [myValue], eax            ; Move ((myValue * A)/B) + C into myValue

	loop IncreaseLoop1

	ret

; =====================================================================
;  Display message and hex value in specified format.
;	format: <messageString> <value> <newLine>

;  Basic steps:
;	- print message string (via passed address)
;	- convert value into ASCII/ternary string
;	- print ASCII/ternary string
;	- print newLine (for nice formatting)

; -----
;  Arguments:
;	1) message, address, rdi
;	2) value, value, esi
; -----
;  Returns:
;	N/A

global printSummary
printSummary:
	push rbx

	mov ebx, esi					; Move myValue value into ebx

	call printString				; rdi already set

	mov rdi, 0						; Clear rdi
	mov edi, ebx					; Move myValue into edi
	mov rsi, tmpString				; Move tmpString into
	call int2ternary				; Call int2ternary

	mov	rdi, tmpString
	call printString

	mov	rdi, newLine
	call printString

	pop	rbx
	ret

; =====================================================================
;  Function, int2ternary, to convert a signed base-10 integer
;  into an ASCII string representing the ternary value.
;  Assumes valid/correct data.  As such, no error checking is performed.


;	YOUR CODE GOES HERE

global int2ternary
int2ternary:

push rax
push rbx
push rcx
push rdx
push r12

mov rax, 0								; Reset rax
mov rbx, 0								; Reset rbx
mov rcx, 0								; Reset rcx
mov eax, edi							; Move integer value into eax

initialCheck:
	cmp eax, 0							; Compare integer with 0
	jb invalid							; If integer < 0, jump to invalid
conversionLoop:
	mov edx, 0
	div dword [weight]					; Divide integer by 3 repeatedly to convert to base 3
	push rdx							; Remainder will be stored, push onto stack
	inc rcx								; Increase character counter
	cmp eax, 0							; Compare current value in eax with 0 to determine if conversion is done
	jne conversionLoop					; If current value != 0, jump to conversionLoop
	mov rbx, STR_SIZE					; Move STR_SIZE into rbx
	sub rbx, rcx						; Amount of spaces to be placed after characters are placed
	sub rbx, 1							; Take into account NULL
	mov r12, 0							; Counter for string
popLoop:
	pop rax								; Pop digit that needs to be placed
	add al, "0"							; Convert digit into character
	jmp setChar							; Jump to setChar
setChar:
	mov byte [rsi + r12], al			; Set character in current string position
	inc r12								; Update counter to traverse string
	loop popLoop						; Dec rcx; remaining amount of digits that need to be placed
setSpaces:
	mov byte [rsi + r12], " "			; Move space into current string position
	inc r12								; Update counter to traverse string
	dec rbx								; Dec amount of spaces to place
	cmp rbx, 0							; Compare amount of spaces left to 0
	jne setSpaces						; If spaces != 0, jump to setSpaces
	mov byte [rsi + r12], NULL			; Add NULL to end of string
valid:
	mov eax, TRUE						; Return TRUE if valid
	jmp int2ternaryDone
invalid:
	mov eax, FALSE						; Return FALSE if invalid
int2ternaryDone:

pop r12
pop rdx
pop rcx
pop rbx
pop rax

	ret

; =====================================================================
;  Generic function to display a string to the screen.
;  String must be NULL terminated.

;  Algorithm:
;	Count characters in string (excluding NULL)
;	Use syscall to output characters

;  Arguments:
;	- address, string
;  Returns:
;	nothing

global	printString
printString:
	push	rbx

; -----
;  Count characters in string.

	mov	rbx, rdi			; str addr
	mov	rdx, 0
strCountLoop:
	cmp	byte [rbx], NULL
	je	strCountDone
	inc	rbx
	inc	rdx
	jmp	strCountLoop
strCountDone:

	cmp	rdx, 0
	je	prtDone

; -----
;  Call OS to output string.

	mov	rax, SYS_write			; system code for write()
	mov	rsi, rdi			; address of characters to write
	mov	rdi, STDOUT			; file descriptor for standard in
						; EDX=count to write, set above
	syscall					; system call

; -----
;  String printed, return to calling routine.

prtDone:
	pop	rbx
	ret

; ******************************************************************
