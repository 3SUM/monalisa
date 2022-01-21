;  Luis Maya
;  CS 218 Section #1002
;  CS 218 - Assignment #11

; -----
;  Function - getArguments()
;	Read, parse, and check command line arguments.

;  Function - int2ternary()
;	Convert an integer to a ternary string, NULL terminated.

;  Function - countDigits()
;	Check the leading digit for each number and count
;	each 0, 1, 2, etc...
;	All file buffering handled within this procedure.

;  Function - showGraph()
;	Create graph as per required format and ouput.


; ****************************************************************************

section	.data

; -----
;  Define standard constants.

LF			equ	10			; line feed
NULL		equ	0			; end of string
SPACE		equ	0x20		; space

TRUE		equ	1
FALSE		equ	0

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

O_CREAT		equ	0x40
O_TRUNC		equ	0x200
O_APPEND	equ	0x400

O_RDONLY	equ	000000q			; file permission - read only
O_WRONLY	equ	000001q			; file permission - write only
O_RDWR		equ	000002q			; file permission - read and write

S_IRUSR		equ	00400q
S_IWUSR		equ	00200q
S_IXUSR		equ	00100q

; -----
;  Variables for getParameters()

usageMsg	db	"Usage: ./benford -i <inputFileName> "
			db	"-o <outputFileName> -d <T/F>", LF, NULL

errMany		db	"Error, too many characters on the "
			db	"command line.", LF, NULL

errFew		db	"Error, too few characters on the "
			db	"command line.", LF, NULL

errDSpec	db	"Error, invalid output display specifier."
			db	LF, NULL

errISpec	db	"Error, invalid input file specifier."
			db	LF, NULL

errOSpec	db	"Error, invalid output file specifier."
			db	LF, NULL

errTF		db	"Error, invalid display option. Must be T or F."
			db	LF, NULL

errOpenIn	db	"Error, can not open input file."
			db	LF, NULL

errOpenOut	db	"Error, can not open output file."
			db	LF, NULL


; -----
;  Variables for countDigits()

BUFFSIZE	equ	500000

SKIP_LINES	equ	5					; skip first 5 lines
SKIP_CHARS	equ	6

nextCharIsFirst	db	TRUE
skipLineCount	dd	0				; count of lines to skip
skipCharCount	dd	0				; count of chars to skip
gotDigit		db	FALSE

bfMax		dq	BUFFSIZE
curr		dq	BUFFSIZE

wasEOF		db	FALSE

errFileRead	db	"Error reading input file."
			db	"Program terminated."
			db	LF, NULL

wasFirst	db	FALSE
; -----
;  Variables for showGraph()

SCALE1		equ	100					; for < 100,000
SCALE2		equ	1000				; for >= 100,000 and < 500,000
SCALE3		equ	2500				; for >= 500,000 and < 1,000,000
SCALE4		equ	5000				; for >= 1,000,000

scale		dd	SCALE1				; initial scaling factor

weight		dd	3

errFileWrite	db	"Error writing output file."
				db	LF, NULL

graphHeader	db	LF, "CS 218 Benfords Law", LF
			db	"Test Results", LF, LF, NULL

graphLine1	db	"Total Data Points: "
tStr1		db	"                     ", LF, LF, NULL

DIGITS_SIZE	equ	15
STARS_SIZE	equ	50

graphLine2	db	"  "					; initial spaces
index2		db	"x"						; overwriten with #
			db	"  "					; spacing
num2		db	"               "		; digit count
			db	"|"						; pipe
stars2		db	"                              "
			db	"                    "
			db	LF, NULL

graphLine3	db	"                     ---------------------------------------------"
			db	LF, LF, NULL

tempSum		dd	0
starCount	dd	0
; -------------------------------------------------------

section	.bss

buff		resb	BUFFSIZE+1


; ****************************************************************************

section	.text

; ======================================================================
; Read, parse, and check command line paraemetrs.

; -----
;  Assignment #11 requires options for:
;	input file name
;	output file name
;	display results to screen (T/F)

;  For Example:
;	./benford -i <inputFileName> -o <outputFileName> -d <T/F>

; -----
;  Example high-level language call:
;	status = getParameters(ARGC, ARGV, rdFileDesc, wrFileDesc, displayToScreen)

; -----
;  Arguments passed:
;	argc, rdi
;	argv, rsi
;	address of file descriptor, input file, rdx
;	address of file descriptor, output file, rcx
;	address of boolean for display to screen, r8



;	YOUR CODE GOES HERE
global getArguments
getArguments:

push rbx
push r12
push r13
push r14
push r15

mov rbx, 0

cmp rdi, 1							; Compare argc to 1
je usageMessage						; If argc = 1, then  jump to usageMessage
cmp rdi, 7							; Compare argc to 7
jb tooFew							; If argc < 7, then jump to tooFew
cmp rdi, 7							; Compare argc to 7
ja tooMany							; If argc > 7, then jump to tooMany

mov rbx, qword [rsi + 8]			; Move address of argv[1][i] into rbx
inputSpecifier:
	cmp byte [rbx], "-"				; Compare argv[1][0] to "-"
	jne iSpecifierWrong				; If argv[1][0] != "-", jump to iSpecifierWrong

	inc rbx							; Update counter, i++
	cmp byte [rbx], "i"				; Compare argv[1][1] to "i"
	jne iSpecifierWrong  			; If argv[1][1] != "i", jump to iSpecifierWrong

	inc rbx							; Update counter, i++
	cmp byte [rbx], NULL			; Compare argv[1][2] to NULL
	jne iSpecifierWrong  			; If argv[1][2] != NULL, jump to iSpecifierWrong

mov rbx, qword [rsi + 24]			; Move address of argv[3][i] into rbx
outputSpecifier:
	cmp byte [rbx], "-"				; Compare argv[3][0] to "-"
	jne oSpecifierWrong				; If argv[3][0] != to "-", jump to oSpecifierWrong

	inc rbx							; Update counter, i++
	cmp byte [rbx], "o"				; Compare argv[3][1] to "o"
	jne oSpecifierWrong  			; If argv[3][1] != "o", jump to oSpecifierWrong

	inc rbx							; Update counter, i++
	cmp byte [rbx], NULL			; Compare argv[3][2] to NULL
	jne oSpecifierWrong  			; If argv[3][2] != NULL, jump to oSpecifierWrong

mov rbx, qword [rsi + 40]			; Move address of argv[5][i] into rbx
displaySpecifier:
	cmp byte [rbx], "-"				; Compare argv[5][0] to "-"
	jne dSpecifierWrong				; If argv[5][0] != to "-", jump to dSpecifierWrong

	inc rbx							; Update counter, i++
	cmp byte [rbx], "d"				; Compare argv[5][1] to "d"
	jne dSpecifierWrong  			; If argv[5][1] != "d", jump to dSpecifierWrong

	inc rbx							; Update counter, i++
	cmp byte [rbx], NULL			; Compare argv[5][2] to NULL
	jne dSpecifierWrong  			; If argv[5][2] != NULL, jump to dSpecifierWrong

mov rbx, qword [rsi + 48]			; Move address if argv[6][i] into rbx
displayCheck:
	cmp byte [rbx], "T"				; Compare argv[6][0] with "T"
	je displayTrue					; If argv[6][0] == "T", jump to displayTrue
	cmp byte [rbx], "F"				; Compare argv[6][0] with "F"
	je displayFalse					; If argv[6][0] == "F", jump to displayFalse
	jmp displayError				; If argv[6][0] not above, jump to displayError
displayTrue:
	mov qword [r8], TRUE			; Move TRUE into address of displayScreen
	jmp saveCalles
displayFalse:
	mov qword [r8], FALSE			; Move FALSE into address of displayScreen

saveCalles:
	mov r12, rdx 					; Move address of &input into r12
	mov r13, rcx 					; Move address of &output into r13
	mov r14, qword [rsi + 16]  		; Move address of file to read into r14
	mov r15, qword [rsi + 32] 		; Move address of file to write into r15

inFileCheck:
	mov rax, SYS_open  				; System call code to open file
	mov rdi, r14					; Move address of input file into rdi
	mov rsi, O_RDONLY           	; Read only
	syscall

	cmp rax,0						; Compare rax with 0
	jl readingError					; If rax < 0, jump to readingError

	mov qword [r12], rax  			; File descriptor of file to read

outFileCheck:
	mov rax, SYS_creat  			; System call code to open/create file
	mov rdi, r15 					; Move address of output file into rdi
	mov rsi, S_IRUSR|S_IWUSR		; Read/write to file
	syscall

	cmp rax, 0 						; Compare rax with 0
	jl writingError					; If rax < 0, jump to writingError

	mov qword [r13], rax 			; File descriptor of file to write to

;----------------------------------
successful:
	mov rax, TRUE
	jmp done
usageMessage:
	mov rdi, usageMsg
	call printString
	mov rax, FALSE
	jmp done
tooFew:
	mov rdi, errFew
	call printString
	mov rax, FALSE
	jmp done
tooMany:
	mov rdi, errMany
	call printString
	mov rax, FALSE
	jmp done
iSpecifierWrong:
	mov rdi, errISpec
	call printString
	mov rax, FALSE
	jmp done
oSpecifierWrong:
	mov rdi, errOSpec
	call printString
	mov rax, FALSE
	jmp done
dSpecifierWrong:
	mov rdi, errDSpec
	call printString
	mov rax, FALSE
	jmp done
readingError:
	mov rdi, errOpenIn
	call printString
	mov rax, FALSE
	jmp done
writingError:
	mov rdi, errOpenOut
	call printString
	mov rax, FALSE
	jmp done
displayError:
	mov rdi, errTF
	call printString
	mov rax, FALSE

done:

pop r15
pop r14
pop r13
pop r12
pop rbx

	ret

; ======================================================================
;  Simple function to convert an integer to a NULL terminated
;	ternary string.
;	NOTE, may change arguments as desired.

; -----
;  HLL Call
;	bool = int2ternary(int, &str);

; -----
;  Arguments passed:
;	1) integer value, edi
;	2) string, address, rsi

; -----
;  Returns
;	1) string (via passed address), rsi
;	2) bool, TRUE if valid conversion, FALSE for error, eax



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
	mov rbx, DIGITS_SIZE				; Move DIGITS_SIZE into rbx
	sub rbx, rcx						; Amount of spaces to be placed after characters are placed
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

; ======================================================================
; Count leading digits....
;	Check the leading digit for each number and count
;	each 0, 1, 2, etc...
;	The counts (0-9) are stored in an array.

; -----
;  High level language call:
;	countDigits (rdFileDesc, digitCounts)

; -----
;  Arguments passed:
;	value for input file descriptor, rdi
;	address for digits array, rsi



;	YOUR CODE GOES HERE
global countDigits
countDigits:

push rbx
push r9
push r12
push r13
push r14


mov r12, rdi 								; Move input file descriptor value into r12
mov r13, rsi								; Move address of array into r13
mov rbx, 0									; Reset counter, i = 0
mov r9, 0									; Reset r9

checkEOF:
	cmp byte [wasEOF], TRUE					; Compare wasEOF with TRUE
	jne notEOF								; If wasEOF != TRUE, jump to notEOF
isEOF:
	mov byte [wasEOF], FALSE				; Reset wasEOF to FALSE
	jmp countDigitsEnd						; Jump to countDigitsEnd
notEOF:
	mov rax, SYS_read 						; System code to read a file
	mov rdi, r12 							; File Descriptor
	mov rsi, buff							; Address of where to place characters read
	mov rdx, BUFFSIZE						; Amount of characters to be read (BUFFSIZE)
	syscall

	cmp rax, 0								; Compare rax with 0
	jge successfullyRead					; If rax >= 0, jump to successfullyRead
errorReading:
	mov rdi, errFileRead					; Display error message if file not read correctly
	call printString
	jmp countDigitsEnd						; Jump to countDigitsEnd once error message displayed
successfullyRead:
	cmp rax, 0								; Compare rax with 0
	jne charactersRead						; If rax != 0, jump to charactersRead
	jmp countDigitsEnd						; If rax == 0, jump to countDigitsEnd
charactersRead:
	cmp rax, BUFFSIZE						; Compare rax with BUFFSIZE
	jge buffSizeRead						; If rax >= BUFFSIZE, jump to buffSizeRead
	mov qword [bfMax], rax 					; Move value of characters read into bfMax
	mov byte [wasEOF], TRUE					; Set wasEOF to TRUE
buffSizeRead:
	mov qword [curr], 0  					; Set curr to 0
	mov r10, 0								; Clear r10, counter i = 0
	cmp dword [skipLineCount], SKIP_LINES	; Compare skipLineCount with SKIP_LINES
	je skipLinesEnd							; If skipLineCount == SKIP_LINES, jump to skipLinesEnd


skipLines:
	mov r9b, byte [buff + r10]				; Move current character into r9b
	inc r10									; Update counter, i++
	cmp r9b, LF								; Compare current character with LF
	jne skipLines
	add dword [skipLineCount], 1			; Increase skipLineCount
	cmp dword [skipLineCount], SKIP_LINES	; Compare skipLineCount with SKIP_LINES
	jne skipLines							; If skipLineCount != SKIP_LINES, jump to skipLines
	mov qword [curr], r10					; Move skipLineCount value into curr
skipLinesEnd:
	cmp byte [wasFirst], TRUE
	je ignoreRest
	cmp dword [skipCharCount], SKIP_CHARS
	je firstDigit
startSkipChars:
	mov dword [skipCharCount], 0			; Reset skipCharCount
skipChars:
	add qword [curr], 1						; Update curr
	add dword [skipCharCount], 1			; Increase skipCharCount
	cmp qword [curr], BUFFSIZE				; Compare curr with BUFFSIZE
	jae getNext								; If curr == BUFFSIZE, jump to getNext
	cmp dword [skipCharCount], SKIP_CHARS	; Compare skipCharCount with SKIP_CHARS
	jne skipChars							; If skipCharCount != SKIP_CHARS, jump to skipChars
	mov r11, 0								; Reset r11
	mov r10, qword [curr]					; Move curr value into r10
firstDigit:
	cmp byte [wasFirst], TRUE				; Compare wasFirst with TRUE
	je ignoreRest							; If wasFirst == TRUE, jump to ignoreRest
	movzx r11, byte [buff + r10] 			; Move current character into r11
	cmp r11, "0"							; Compare current character with space
	jb ignoreSpaces							; If current chacter < "0", jump to ignoreSpaces
	sub r11, "0"							; ("Curr digit" - "0") to get integer
	mov rsi, r13							; Restore address of array
	add dword [rsi + r11 * 4], 1			; Increase counter for the digit in the passed array
	mov byte [wasFirst], TRUE				; Move TRUE into wasFirst
	inc r10									; Update counter, i++
	add qword [curr], 1						; Update curr
	cmp qword [curr], BUFFSIZE				; Compare curr with BUFFSIZE
	jae getNext								; If curr == BUFFSIZE, jump to getNext
	mov r11, 0								; Reset r11
	jmp ignoreRest							; Jump to ignoreRest
ignoreSpaces:
	inc r10									; Update counter, i++
	add qword [curr], 1						; Update curr
	cmp qword [curr], BUFFSIZE				; Compare curr with BUFFSIZE
	jae getNext								; If curr == BUFFSIZE, jump to getNext
	jmp firstDigit							; Jump to firstDigit
ignoreRest:
	mov r11b, byte [buff + r10]				; Move current character into r11b
	inc r10									; Update counter, i++
	add qword [curr], 1						; Update curr
	cmp qword [curr], BUFFSIZE				; Compare curr with BUFFSIZE
	jae getNext								; If curr == BUFFSIZE, jump to getNext
	cmp r11b, LF							; Compare current chacter with LF
	jne ignoreRest							; If current chacter != LF, jump to ignoreRest
	mov r11, 0								; Reset r11
	mov byte [wasFirst], FALSE				; Reset wasFirst

getNext:
	mov r10, qword [curr]					; Move curr value into r10
	cmp r10, qword [bfMax]					; Compare curr value with bfMax value
	jb startSkipChars						; If curr < bfMax, jump to startSkipChars
	jmp checkEOF							; Jump to checkEOF

countDigitsEnd:

pop r14
pop r13
pop r12
pop r9
pop rbx

	ret

; ======================================================================
;  Create graph as per required format.
;	write graph to file
;	if requested, also show graph to output screen

;  High-level language call:
;	showGraph (wrFileDesc, digitCounts, displayToScreen)

; -----
;  Arguments passed:
;	file descriptor, output file - value, rdi
;	address for digits array - address, rsi
;	display to screen option, T or F - value, rdx



;	YOUR CODE GOES HERE
global showGraph
showGraph:

push rbx
push rcx
push r12
push r13
push r14
push r15

mov rbx, "0"							; Index
mov rcx, 0								; Reset rcx
mov r12, rdi 							; Move output file descriptor value into r12
mov r13, rsi							; Move address of array into r13
mov r14, rdx							; Move value of displayScreen to r14
mov r15, 0								; Counter, i = 0


mov rdi, 0								; Reset rdi
findtotalCount:
	mov eax, dword [r13 + r15 * 4]		; Move value of array[i] into eax
	add dword [tempSum], eax			; tempSum += array[i]
	inc r15								; Update counter, i++
	cmp r15, 10							; Compare counter value with 10
	jb findtotalCount					; If counter < 10, jump to findtotalCount

findScale:
	cmp dword [tempSum], 100000			; Compare tempSum with 100000
	jb scaleOne							; If tempSum < 100000, jump to scaleOne
	cmp dword [tempSum], 500000			; Compare tempSum with 500000
	jb scaleTwo							; If tempSum < 500000, jump to scaleTwo
	cmp dword [tempSum], 1000000		; Compare tempSum with 1000000
	jb scaleThree						; If tempSum < 1000000, jump to scaleThree
	jmp scaleFour						; If tempSum >= 1000000, jump to scaleFour
scaleOne:
	mov dword [scale], SCALE1			; Set scale to SCALE1
	jmp convertTotalCount				; Jump to convertTotalCount
scaleTwo:
	mov dword [scale], SCALE2			; Set scale to SCALE2
	jmp convertTotalCount				; Jump to convertTotalCount
scaleThree:
	mov dword [scale], SCALE3			; Set scale to SCALE3
	jmp convertTotalCount				; Jump to convertTotalCount
scaleFour:
	mov dword [scale], SCALE4			; Set scale to SCALE4

convertTotalCount:
	mov edi, dword [tempSum]			; Move value of tempSum into rsi
	mov rsi, tStr1						; Move address of tStr1 into rdi
	call int2ternary
	mov r15, 0							; Reset counter

setHeader:
	mov rdi, r12						; Move output file descriptor value into rdi
	mov rsi, graphHeader				; Move graphHeader into rsi
	call setText						; Call setText
	cmp r14, FALSE						; Compare displayScreen to FALSE
	je setTotalCount					; If displayScreen == FALSE, jump to setTotalCount
	mov rdi, graphHeader				; Move graphHeader into rdi
	call printString					; Call printString
setTotalCount:
	mov rdi, r12						; Move output file descriptor value into rdi
	mov rsi, graphLine1					; Move graphLine1 into rsi
	call setText						; Call setText
	cmp r14, FALSE						; Compare displayScreen to FALSE
	je calcDataPoints					; If displayScreen == FALSE, jump to calcDataPoints
	mov rdi, graphLine1					; Move graphLine1 into rdi
	call printString					; Call printString
	mov rax, 0							; Reset rax

calcDataPoints:
	mov byte [index2], bl				; Move current index into index2
	mov eax, dword [r13 + r15 * 4]		; Move array[i] value into eax
	mov edx, 0
	div dword [scale]					; array[i]/scale stored in eax
	mov [starCount], eax				; Move eax into starCount
	mov rcx, STARS_SIZE					; Move STARS_SIZE into rcx
	sub rcx, rax						; Amount of spaces to be placed after stars are placed
	mov r9, 0							; Reset r9
	cmp dword [starCount], 0			; Compare starCount with 0
	je setStarsSpaces					; If starCount == 0, jump to setStarsSpaces
setStars:
	mov byte [stars2 + r9], "*"			; Move "*" into stars2[i]
	inc r9								; Update counter
	cmp r9d, dword [starCount]			; Compare counter to starCount
	jne setStars						; If counter != starCount, jump to setStars
setStarsSpaces:
	mov byte [stars2 + r9], " "			; Move " " into stars2[i]
	inc r9								; Update counter
	loop setStarsSpaces
convertCount:
	mov rdi, 0							; Clear rdi
	mov edi, dword [r13 + r15 * 4]		; Move array[i] value into edi
	mov rsi, num2						; Move num2 into rsi
	call int2ternary					; Call int2ternary
setDataPoints:
	mov rdi, r12						; Move output file descriptor value into rdi
	mov rsi, graphLine2					; Move graphLine2 into rsi
	call setText						; Call setText
	cmp r14, FALSE						; Compare displayScreen to FALSE
	je updateIndex						; If displayScreen == FALSE, jump to updateIndex
	mov rdi, graphLine2					; Move graphLine2 into rdi
	call printString					; Call printString
updateIndex:
	inc rbx								; Update index
	inc r15								; Update counter, i++
	cmp r15, 9							; Compare counter value with 9
	jbe calcDataPoints					; If counter <= 9, jump to calcDataPoints

	mov rdi, r12						; Move output file descriptor value into rdi
	mov rsi, graphLine3					; Move graphLine3 into rsi
	call setText						; Call setText
	cmp r14, FALSE						; Compare displayScreen to FALSE
	je showGraphDone					; If displayScreen == FALSE, jump to showGraphDone
	mov rdi, graphLine3					; Move graphLine3 into rdi
	call printString					; Call printString
showGraphDone:

pop r15
pop r14
pop r13
pop r12
pop r9
pop rbx

	ret

; ======================================================================
;  Generic function to write a string to an already opened file.
;  Similar to printString(), but must handle possible file write error.
;  String must be NULL terminated.

;  Algorithm:
;	Count characters in string (excluding NULL)
;	Use syscall to output characters to file

;  Arguments:
;	file descriptor, value, rdi
;	address, string, rsi
;  Returns:
;	nothing


;	YOUR CODE GOES HERE
global setText
setText:

push rdx
push rbx
push r12

mov rbx, rsi						; Move address of string into rbx
mov r12, rdi 						; Move output file descriptor value into r12

mov	rdx, 0							; Clear rdx
stringCountLoop:
	cmp	byte [rbx+rdx], NULL
	je	stringCountLoopDone
	inc	rdx
	jmp	stringCountLoop
stringCountLoopDone:
	cmp	rdx, 0
	je	setTextDone


	mov	rax, SYS_write				; System code for write()
	mov	rsi, rbx					; Address of char to write
	mov	rdi, r12					; File descriptor
									; rdx = count to write, set above
	syscall							; system call

	cmp rax, 0						; Compare rax with 0
	jb setError						; If rax < 0, jump to setError
	jmp setTextDone					; Else jump to setTextDone

setError:
	mov rdi, errFileWrite
	call printString
setTextDone:

pop r12
pop rbx
pop rdx

	ret

; ======================================================================
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

; ******************************************************************
