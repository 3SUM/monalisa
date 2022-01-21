;  Luis Maya
;  CS 218 Section #1002
;  Assignment #10
;  Support Functions.
;  Provided Template

; -----
;  Function getIterations()
;	Gets, checks, converts, and returns iteration
;	count and rotation speed from the command line.

;  Function drawChaos()
;	Calculates and plots Chaos algorithm

; ---------------------------------------------------------

;	MACROS (if any) GO HERE
; *****************************************************************************
;  Macro, ternary2int, to convert an ASCII string (STR_SIZE characters,
;  byte-size, leading sign, right justified, blank filled, NULL terminated)
;  representing the signed ternary value into a signed base-10 integer.

;  Assumes valid/correct data.  As such, no error checking is performed.

;  NOTE, addresses are passed.  For example:
;	mov	rbx, %1 	  		-> copies 1st argument address to rbx
;	mov	dword [%2], eax   	-> sets 2nd argument.

%macro ternary2int 2

push rbp
mov rbp, rsp
sub rsp, 8

push rcx
push rdx

mov dword [%2], 0						; Clear ans value
mov dword [rbp - 4], 0					; tempInt; Move 0 into temp [rbp - 4]
mov dword [rbp - 8], 3					; numThree; Move 3 into [rbp - 8]
mov rax, 0								; Clear rax
mov rdx, 0
mov rcx, 0
mov r10, 0								; Clear r10, will be used as counter

%%spaceCheck:
	movzx eax, byte [%1 + r10]			; Move current character of string[i] into eax
	cmp eax, " "						; Compare current character with " "
	jne %%controlLoop					; If current character is not " " jump to controlLoop
	inc r10								; Increase counter
	jmp %%spaceCheck					; Jump to spaceCheck and check next character
%%controlLoop:
	cmp eax, "-"						; Check if number is negative
	je %%rmNegSign						; Jump to rmNegSign if number is negative
	cmp eax, "0"						; Check if current charcter is a number
	jae %%positiveLoop					; If charcter is number, jump to positiveLoop
	inc r10								; Update counter to access first digit if identified as postive
%%positiveLoop:
	movzx eax, byte [%1 + r10]			; Move first digit into eax
	cmp eax, NULL						; Check if at end of string
	je %%controlDone					; Jump to controlDone if current character is equal to NULL
	cmp eax, "0"						; Check if current character is number
	jae %%postiveSum					; If character is 0 or above, jump to convert character to number
%%rmNegSign:
	inc r10								; Update counter to access first digit in string
%%negativeLoop:
	movzx eax, byte [%1 + r10]			; Move first digit into eax
	cmp eax, NULL						; Check if at end of string
	je %%negativeDone					; Jump to negativeDone if current character is equal to NULL
	cmp eax, "0"						; Check if current character is number
	jae %%negativeSum					; If character is 0 or above, jump to convert character to number
%%postiveSum:
	sub eax, "0"						; "Curr number" - "0" to get number as is
	mov dword [rbp - 4], eax			; Move number to temp storage location
	mov eax, dword [%2]					; Move current decimal number to eax
	mul dword [rbp - 8]					; Mul current number by three to convert into decimal
	add eax, dword [rbp - 4]			; ans += intDigit
	mov dword [%2], eax					; Move current value of eax to ans
	inc r10								; Update string counter
	jmp %%positiveLoop					; Jump to positiveLoop to continue
%%negativeSum:
	sub eax, "0"						; "Curr number" - "0" to get number as is
	mov dword [rbp - 4], eax			; Move number to temp storage location
	mov eax, dword [%2]					; Move current decimal number to eax
	mul dword [rbp - 8]					; Mul current number by three to convert into decimal
	add eax, dword [rbp - 4]			; ans += intDigit
	mov dword [%2], eax					; Move current value of eax to ans
	inc r10								; Update string counter
	jmp %%negativeLoop					; Jump to negativeLoop to continue
%%negativeDone:
	mov eax, dword [%2]					; Move decimal number to eax
	neg eax								; Negate decimal number to get negative
	mov dword [%2], eax					; Move negative number to ans
%%controlDone:

pop rdx
pop rcx

mov rsp, rbp
pop rbp

%endmacro

; ---------------------------------------------------------

section  .data

; -----
;  Define standard constants.

TRUE		equ	1
FALSE		equ	0

SUCCESS		equ	0			; successful operation
NOSUCCESS	equ	1

STDIN		equ	0			; standard input
STDOUT		equ	1			; standard output
STDERR		equ	2			; standard error

SYS_read	equ	0			; code for read
SYS_write	equ	1			; code for write
SYS_open	equ	2			; code for file open
SYS_close	equ	3			; code for file close
SYS_fork	equ	57			; code for fork
SYS_exit	equ	60			; code for terminate
SYS_creat	equ	85			; code for file open/create
SYS_time	equ	201			; code for get time

LF			equ	10
SPACE		equ	" "
NULL		equ	0
ESC			equ	27

; -----
;  OpenGL constants

GL_COLOR_BUFFER_BIT	equ	16384
GL_POINTS			equ	0
GL_POLYGON			equ	9
GL_PROJECTION		equ	5889

GLUT_RGB		equ	0
GLUT_SINGLE		equ	0

; -----
;  Define program constants.

IT_MIN		equ	255
IT_MAX		equ	65535
RS_MAX		equ	32768

; -----
;  Local variables for getArguments function.

STR_LENGTH	equ	12

ddThree		dd	3

errUsage	db	"Usage: chaos -it <ternaryNumber> -rs <ternaryNumber>"
			db	LF, NULL
errBadCL	db	"Error, invalid or incomplete command line argument."
			db	LF, NULL
errITsp		db	"Error, iterations specifier incorrect."
			db	LF, NULL
errITvalue	db	"Error, invalid iterations value."
			db	LF, NULL
errITrange	db	"Error, iterations value must be between "
			db	"100110 (3) and 10022220020 (3)."
			db	LF, NULL
errRSsp		db	"Error, rotation speed specifier incorrect."
			db	LF, NULL
errRSvalue	db	"Error, invalid rotation speed value."
			db	LF, NULL
errRSrange	db	"Error, rotation speed value must be between "
			db	"0 (3) and 1122221122 (3)."
			db	LF, NULL

; -----
;  Local variables for plotChaos funcction.

red			dd	0					; 0-255
green		dd	0					; 0-255
blue		dd	0					; 0-255

pi			dq	3.14159265358979	; constant
oneEighty	dq	180.0
tmp			dq	0.0

dStep		dq	120.0				; t step
scale		dq	500.0				; scale factor

rScale		dq	100.0				; rotation speed scale factor
rStep		dq	0.1					; rotation step value
rSpeed		dq	0.0					; scaled rotation speed

initX		dq	0.0, 0.0, 0.0		; array of x values
initY		dq	0.0, 0.0, 0.0		; array of y values

x			dq	0.0
y			dq	0.0

seed		dq	987123
qThree		dq	3
fTwo		dq	2.0

A_VALUE		equ	9421				; must be prime
B_VALUE		equ	1

n			dd	0
; ------------------------------------------------------------

section  .text

; -----
; Open GL routines.

extern glutInit, glutInitDisplayMode, glutInitWindowSize
extern glutInitWindowPosition
extern glutCreateWindow, glutMainLoop
extern glutDisplayFunc, glutIdleFunc, glutReshapeFunc, glutKeyboardFunc
extern glutSwapBuffers
extern gluPerspective
extern glClearColor, glClearDepth, glDepthFunc, glEnable, glShadeModel
extern glClear, glLoadIdentity, glMatrixMode, glViewport
extern glTranslatef, glRotatef, glBegin, glEnd, glVertex3f, glColor3f
extern glVertex2f, glVertex2i, glColor3ub, glOrtho, glFlush, glVertex2d
extern glutPostRedisplay

; -----
;  c math library funcitons

extern	cos, sin


; ******************************************************************
;  Generic function to display a string to the screen.
;  String must be NULL terminated.
;  Algorithm:
;	Count characters in string (excluding NULL)
;	Use syscall to output characters

;  Arguments:
;	1) address, string
;  Returns:
;	nothing

global	printString
printString:
	push	rbx
	push	rsi
	push	rdi
	push	rdx

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

	mov	rax, SYS_write		; system code for write()
	mov	rsi, rdi			; address of characters to write
	mov	rdi, STDOUT			; file descriptor for standard in
							; EDX=count to write, set above
	syscall					; system call

; -----
;  String printed, return to calling routine.

prtDone:
	pop	rdx
	pop	rdi
	pop	rsi
	pop	rbx
	ret

; ******************************************************************
;  Function getIterations()
;	Performs error checking, converts ASCII/ternary to integer.
;	Command line format (fixed order):
;	  "-it <ternaryNumber> -rs <ternaryNumber>"

; -----
;  Arguments:
;	1) ARGC, double-word, value, rdi
;	2) ARGV, double-word, address, rsi
;	3) iterations count, double-word, address, rdx
;	4) rotate speed, double-word address, rcx



;	YOUR CODE GOES HERE
global getIterations
getIterations:

push rbx
push rcx
push r8
push r12
push r13

cmp rdi, 1							; Compare argc  to 1
je usageMessage						; If argc = 1, then jump usageMessage
cmp rdi, 5							; Compare argc to 5
jne lackofArguments					; If argc != 5, jump to lackofArguments

mov rbx, qword[rsi + 8]				; Move address of argv[1] into rbx
mov r10, 0							; Set counter to traverse argv[1] to 0, i = 0
itSpecifier:
	mov rax, 0						; Clear rax
	mov al, byte[rbx + r10]			; Move character of argv[1][i] into al
	cmp r10, 0						; Compare counter to 0
	jne firstITDone					; If counter != 0, jump to firstITDone
	cmp al, "-"						; Compare argv[1][0] to "-"
	jne itSpecifierWrong			; If argv[1][0] != "-", jump to itSpecifierWrong
firstITDone:
	cmp r10, 1						; Compare counter to 1
	jne secondITDone				; If counter != 1, jump to secondITDone
	cmp al, 'i'						; Compare argv[1][1] to "i"
	jne itSpecifierWrong			; If argv[1][1] != "i", jump to itSpecifierWrong
secondITDone:
	cmp r10, 2						; Compare counter to 2
	jne thirdITDone					; If counter != 2, jump to thirdITDone
	cmp al, 't'						; Compare argv[1][2] to "t"
	jne itSpecifierWrong 			; If argv[1][2] != "t", jump to thirdITDone
thirdITDone:
	cmp r10, 3   					; Compare counter to 3
	jne fourthITDone				; If counter != 3, jump to fourthITDone
	cmp al, NULL					; Compare argv[1][3] to NULL
	jne itSpecifierWrong			; If argv[1][3] != NULL, jump to fourthITDone
fourthITDone:
	inc r10							; Update counter, i++
	cmp al, NULL					; Compare current character to NULL
	jne itSpecifier					; If current character != NULL, jump to itSpecifier

mov rbx, qword[rsi + 16]			; Move address of argv[2]
mov r10, 0							; Clear r10, will be used as counter to check string
itTernaryCheck:
	mov rax, 0						; Clear rax
	mov al, byte [rbx + r10]		; Move ternaryString[i] into al
	cmp al, NULL					; Check if at end of ternaryString[i]
	je convertITString				; If at end of ternaryString[i], jump to convertString
	cmp al, "3"						; Compare ternaryString[i] with "3"
	jae itNotTernary				; If ternaryString[i] >= "3" jump to notTernary
	cmp al, "0"						; Compare ternaryString[i] with "0"
	jb itNotTernary					; If ternaryString[i] < "0", jump to notTernary
	inc r10							; Update counter to traverse ternaryString[i]
	jmp itTernaryCheck				; If counter < value of total characters, jump to ternaryCheck

convertITString:
	push rdi
	push rsi
	mov rdi, rbx
	mov rsi, rdx
	ternary2int rdi, rsi 		    ; Invoke ternary2int macro
	pop rsi
	pop rdi

mov rbx, qword[rsi + 24]			; Move address of argv[3] into rbx
mov r10, 0							; Set counter to traverse argv[3] to 0, i = 0
rsSpecifier:
	mov rax, 0						; Clear rax
	mov al, byte[rbx + r10]			; Move character of argv[3][i] into al
	cmp r10, 0						; Compare counter to 0
	jne firstRSDone					; If counter != 0, jump to firstRSDone
	cmp al, "-"						; Compare argv[3][0] to "-"
	jne rsSpecifierWrong			; If argv[3][0] != "-", jump to rsSpecifierWrong
firstRSDone:
	cmp r10, 1						; Compare counter to 1
	jne secondRSDone				; If counter != 1, jump to secondRSDone
	cmp al, 'r'						; Compare argv[3][1] to "i"
	jne rsSpecifierWrong			; If argv[3][1] != "r", jump to rsSpecifierWrong
secondRSDone:
	cmp r10, 2						; Compare counter to 2
	jne thirdRSDone					; If counter != 2, jump to thirdRSDone
	cmp al, 's'						; Compare argv[3][2] to "t"
	jne rsSpecifierWrong 			; If argv[3][2] != "s", jump to rsSpecifierWrong
thirdRSDone:
	cmp r10, 3   					; Compare counter to 3
	jne fourthRSDone				; If counter != 3, jump to fourthRSDone
	cmp al, NULL					; Compare argv[3][3] to NULL
	jne rsSpecifierWrong			; If argv[3][3] != NULL, jump to rsSpecifierWrong
fourthRSDone:
	inc r10							; Update counter, i++
	cmp al, NULL					; Compare current character to NULL
	jne rsSpecifier					; If current character != NULL, jump to itSpecifier

mov rbx, qword[rsi + 32]			; Move address of argv[4]
mov r10, 0							; Clear r10, will be used as counter to check string
rsTernaryCheck:
	mov rax, 0						; Clear rax
	mov al, byte [rbx + r10]		; Move ternaryString[i] into al
	cmp al, NULL					; Check if at end of ternaryString[i]
	je convertRSString				; If at end of ternaryString[i], jump to convertString
	cmp al, "3"						; Compare ternaryString[i] with "3"
	jae rsNotTernary				; If ternaryString[i] >= "3" jump to notTernary
	cmp al, "0"						; Compare ternaryString[i] with "0"
	jb rsNotTernary					; If ternaryString[i] < "0", jump to notTernary
	inc r10							; Update counter to traverse ternaryString[i]
	jmp rsTernaryCheck				; If counter < value of total characters, jump to ternaryCheck

convertRSString:
	push rdi
	push rsi
	mov rdi, rbx
	mov rsi, rcx
	ternary2int rdi, rsi 		    ; Invoke ternary2int macro
	pop rsi
	pop rdi

checkRange:
	mov rax, 0						; Clear rax
	movsxd rax, dword [rdx]			; Move iterations value into rax
	cmp rax, IT_MIN					; Compare iterations to IT_MIN
	jb itInvalidRange				; If iterations < IT_MIN, jump to itInvalidRange
	cmp rax, IT_MAX					; Compare iterations to IT_MAX
	ja itInvalidRange				; If iterations > IT_MAX, jump to itInvalidRange
	movsxd rax, dword [rcx]			; Move rotateSpeed value into rax
	cmp rax, 1						; Compare rotateSpeed to 1
	jb rsInvalidRange				; If rotateSpeed < 1, jump to rsInvalidRange
	cmp rax, RS_MAX					; Compare rotateSpeed to RS_MAX
	ja rsInvalidRange				; If rotateSpeed > RS_MAX, jumpt to rsInvalidRange

successful:
	mov rax, TRUE
	jmp done
usageMessage:
	lea rdi, [errUsage]
	call printString
	mov rax, FALSE
	jmp done
lackofArguments:
	lea rdi, [errBadCL]
	call printString
	mov rax, FALSE
	jmp done
itSpecifierWrong:
	lea rdi, [errITsp]
	call printString
	mov rax, FALSE
	jmp done
rsSpecifierWrong:
	lea rdi, [errRSsp]
	call printString
	mov rax, FALSE
	jmp done
itNotTernary:
	lea rdi, [errITvalue]
	call printString
	mov rax, FALSE
	jmp done
rsNotTernary:
	lea rdi, [errRSvalue]
	call printString
	mov rax, FALSE
	jmp done
itInvalidRange:
	lea rdi, [errITrange]
	call printString
	mov rax, FALSE
	jmp done
rsInvalidRange:
	lea rdi, [errRSrange]
	call printString
	mov rax, FALSE
done:

pop r13
pop r12
pop r8
pop rcx
pop rbx

	ret



; ******************************************************************
;  Function to draw chaos algorithm.

;  Chaos point calculation algorithm:
;	seed = 7 * 100th of seconds (from current time)
;	for  i := 1 to iterations do
;		s = rand(seed)
;		n = s mod 3
;		x = x + ( (init_x(n) - x) / 2 )
;		y = y + ( (init_y(n) - y) / 2 )
;		color = n
;		plot (x, y, color)
;		seed = s
;	end_for

; -----
;  Global variables (form main) accessed.

common	drawColor	1:4			; draw color
common	degree		1:4			; initial degrees
common	iterations	1:4			; iteration count
common	rotateSpeed	1:4			; rotation speed

; -----

global drawChaos
drawChaos:

; -----
;  Save registers...
	push r12

; -----
;  Prepare for drawing
	; glClear(GL_COLOR_BUFFER_BIT);

	mov	rdi, GL_COLOR_BUFFER_BIT
	call	glClear

; -----
;  Set rotation speed step value.
;	rStep = rotateSpeed / rScale

	cvtsi2sd xmm0, dword [rotateSpeed] 			; Move rotateSpeed into xmm0
	divsd xmm0, qword [rScale]					; rotateSpeed/rScale stored in xmm0
	movsd qword [rStep], xmm0					; Move rotateSpeed/rScale result into rStep

; -----
;  Plot initial points.

	; glBegin();

	mov	rdi, GL_POINTS
	call	glBegin

; -----
;  Calculate and plot initial points.
	mov r12, 0									; Set counter to 0, i = 0
	calcLoop:
		;----------------
		; initX[i]

		cvtsi2sd xmm0, r12d 					; Move i counter value into xmm0
		mulsd xmm0, qword [dStep]				; (i * dStep) stored in xmm0
		addsd xmm0, qword [rSpeed]				; (rSpeed + (i * dStep)) stored in xmm0
		movsd xmm1, qword [pi]					; Move pi value into xmm1
		divsd xmm1, qword [oneEighty] 			; (pi/180.0), stored in xmm1
		mulsd xmm0, xmm1	  					; (rSpeed + (i * dStep)) * (pi/180.0) stored in xmm0

		call sin

		mulsd xmm0, qword [scale] 			 	; sin((rSpeed + (i * dStep)) * (pi/180.0)) * scale, stored in xmm0
		movsd qword [initX + (r12 * 8)], xmm0   ; Store initX[i]

		;----------------
		; initY[i]

		cvtsi2sd xmm0, r12d 					; Move i counter value into xmm0
		mulsd xmm0, qword [dStep]				; (i * dStep) stored in xmm0
		addsd xmm0, qword [rSpeed]				; (rSpeed + (i * dStep)) stored in xmm0
		movsd xmm1, qword [pi]					; Move pi value into xmm1
		divsd xmm1, qword [oneEighty] 			; (pi/180.0), stored in xmm1
		mulsd xmm0, xmm1	  					; (rSpeed + (i * dStep)) * (pi/180.0) stored in xmm0

		call cos

		mulsd xmm0, qword [scale] 				; cos((rSpeed + (i * dStep)) * (pi/180.0)) * scale, stored in xmm0
		movsd qword [initY + (r12 * 8)], xmm0  	; Store initY[i]

		;--------------
		; Update counter and check condition

		inc r12
		cmp r12, 3
		jb calcLoop


; -----
;  set and plot x[0], y[0]

	mov r12, 0
	movsd xmm1, qword [initY + (r12 * 8)]		; Move y value into xmm1, 2nd argument
	movsd xmm0, qword [initX + (r12 * 8)]		; Move x value into xmm0, 1st argument

	call glVertex2d

; -----
;  set and plot x[1], y[1]

	mov r12, 1
	movsd xmm1, qword [initY + (r12 * 8)]		; Move y value into xmm1, 2nd argument
	movsd xmm0, qword [initX + (r12 * 8)]		; Move x value into xmm0, 1st argument

	call glVertex2d

; -----
;  set and plot x[2], y[2]

	mov r12, 2
	movsd xmm1, qword [initY + (r12 * 8)]		; Move y value into xmm1, 2nd argument
	movsd xmm0, qword [initX + (r12 * 8)]		; Move x value into xmm0, 1st argument

	call glVertex2d

; -----
;  Main plot loop.
mov r12, 0										; Reset counter, i = 0

mainPlotLoop:
	cmp r12d, dword [iterations]				; Compare counter, with iterations
	jae mainPlotDone							; If counter => iterations, jump to mainPlotDone

; -----
;  Generate pseudo random number, via linear congruential generator
;	s = R(n+1) = (A × seed + B) mod 2^16
;	n = s mod 3
;  Note, A and B are constants.

	mov r10, 65536								; Move 2^16 into r10

	;----------------
	; s = R(n+1) = (A × seed + B) mod 2^16

	mov rax, A_VALUE							; Move A_VALUE into rax
	mul qword [seed]							; (A * seed) stored in rax
	add rax, B_VALUE							; (A * seed + B) stored in rax
	mov rdx, 0
	div r10										; ((A * seed + B) mod 2^16) stored in rdx
	mov qword [seed], rdx						; Move new seed value in

	;----------------
	; n = s mod 3

	mov rax, qword [seed]						; Move seed (s) value into rax
	mov rdx, 0
	div qword [qThree]							; (s mod 3) stored in rdx
	mov dword [n], edx							; Move n value into r12


; -----
;  Generate next (x,y) point.
;	x = x + ( (initX[n] - x) / 2 )
;	y = y + ( (initY[n] - y) / 2 )

	;----------------
	; x

	mov r8, 0									; Clear r8
	mov r8d, dword [n] 							; Move value of n into r8d
	movsd xmm0, qword [initX + (r8 * 8)]		; Move value of initX[n] into xmm0
	subsd xmm0, qword [x] 						; (initX[n] - x) stored in xmm0
	divsd xmm0, qword [fTwo]					; ((initX[n] - x) / 2.0) stored in xmm0
	addsd xmm0, qword [x] 						; (x + ((initX[n] - x) / 2 )) stored in xmm0
	movsd qword [x], xmm0 						; Move new x value into x

	;----------------
	; y

	mov r8, 0									; Clear r8
	mov r8d, dword [n] 							; Move value of n into r8d
	movsd xmm0, qword [initY + (r8 * 8)]		; Move value of initY[n] into xmm0
	subsd xmm0, qword [y] 						; (initY[n] - x) stored in xmm0
	divsd xmm0, qword [fTwo]					; ((initY[n] - x) / 2.0) stored in xmm0
	addsd xmm0, qword [y] 						; (y + ((initY[n] - y) / 2 )) stored in xmm0
	movsd qword [y], xmm0 						; Move new y value into y


; -----
;  Set draw color

	cmp dword [n], 0							; Compare n to 0
	jne notZero									; If n != 0, jump to notZero
		mov dword [blue], 0
		mov dword [green], 0
		mov dword [red], 255					; Move 255 into red
	notZero:
		cmp dword [n], 1						; Compare n to 1
		jne notOne								; If n != 1, jump to notOne
		mov dword [blue], 0
		mov dword [green], 255					; Move 255 into green
		mov dword [red], 0
	notOne:
		cmp dword [n], 2						; Compare n to 2
		jne notTwo								; If n != 2, jump to notTwo
		mov dword [blue], 255					; Move 255 into blue
		mov dword [green], 0
		mov dword [red], 0
	notTwo:

		mov rdi, 0								; Clear rdi
		mov rsi, 0								; Clear rsi
		mov rdx, 0								; Clear rdx

		mov edx, dword[blue]	 				; Move blue value into edx, 3rd argument
		mov esi, dword[green]					; Move green value into esi, 2nd argument
		mov edi, dword[red]						; Move red value into edi, 1st argument

		call glColor3ub

; -----
;  Plot (x,y)

	movsd xmm1, qword [y]						; Move y value into xmm1, 2nd argument
	movsd xmm0, qword [x]						; Move x value into xmm0, 1st argument

	call glVertex2d

	inc r12										; Update counter, i++
	jmp mainPlotLoop							; Jump to mainPlotLoop

mainPlotDone:

; -----

	call	glEnd
	call	glFlush

; -----
;  Update rotation speed.
;  Then tell OpenGL to re-draw with new rSpeed value.

	movsd xmm0, qword [rSpeed]					; Move rSpeed into xmm0
	addsd xmm0, qword [rStep]					; rSpeed + rStep
	movsd qword [rSpeed], xmm0					; Move updated value into rSpeed

	call	glutPostRedisplay

	pop	r12
	ret

; ******************************************************************
