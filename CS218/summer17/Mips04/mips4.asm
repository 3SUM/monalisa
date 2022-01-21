#  Luis Maya
#  CS 218 Section #1002
#  CS 218, MIPS Assignment #4

#  Write a simple assembly language program to
#  compute the Fibonacci and Perrin Sequences.


#####################################################################
#  data segment

.data

# -----
# Constants

MIN = 3
MAX = 45

# -----
#  Local variables for main.

hdr:		.ascii	"\nMIPS Assignment #4\n"
			.asciiz	"Fibonacci and Perrin Numbers Program"

entNpmt:	.asciiz	"\n\n\nEnter N (3-45, 0 to terminate): "

n:			.word	0
newLine:	.asciiz	"\n"
doneMsg:	.asciiz	"\n\nGame Over, thank you for playing.\n"

# -----
#  Local variables for getNumber() function.

msg0:		.asciiz	"\nThis should be quick.\n"
msg1:		.asciiz	"\nThis is going to take a while (n>20).\n"
msg2:		.asciiz	"\nThis is going to take a long time (n>30).\n"
msg3:		.asciiz	"\nThis going to take a really long time (n>35).\n"
msg4:		.asciiz	"\nThis is going to take a very long time (> 30 minutes).\n"
errMsg:		.asciiz	"\nError, value of range.  Please re-enter.\n"

# -----
#  Local variables for prtNumber() function.

nMsg:		.asciiz	"\nnum = "
fMsg:		.asciiz	"   fibonacci = "
pMsg:		.asciiz	"   perrin = "

# -----
#  Local variables for prtBlanks() routine.

space:		.asciiz	" "


#####################################################################
#  text/code segment

.text

.globl main
.ent main
main:

# -----
#  Display header.

	la	$a0, hdr
	li	$v0, 4
	syscall						# print header

# -----
#  Read N (including error checking and display of message).

doAgain:
	jal	getNumber
	sw	$v0, n

	beqz	$v0, allDone

# -----
#  Main loop to generate and display fibonacci and perrin numbers.

	move	$s0, $zero
	lw	$s1, n

loop:
	move	$a0, $s0			# get fibonacci(n)
	jal	fibonacci
	move	$s2, $v0

	move	$a0, $s0			# get perrin(n)
	jal	perrin
	move	$s3, $v0

	move	$a0, $s0			# print output line
	move	$a1, $s2
	move	$a2, $s3
	jal	prtLine

	add	$s0, $s0, 1				# next loop?
	ble	$s0, $s1, loop

	j	doAgain

# -----
#  Done, terminate program.

allDone:
	la	$a0, doneMsg
	li	$v0, 4
	syscall						# print header

	li	$v0, 10
	syscall						# au revoir...

.end main


#####################################################################
#  Get the N value from the user.
#  Peform appropriate error checking and display status message.

# -----
#    Arguments:
#	none

#    Returns:
#	N value ($v0)


#	YOUR CODE GOES HERE

.globl getNumber
.ent getNumber
getNumber:

	sub $sp, $sp, 4
	sw $s0, 0($sp)				# Push $s0

readStart:
	la $a0, entNpmt				# Print prompt to ask for number
	li $v0, 4
	syscall

	li $v0, 5					# Call code to read in 32-bit integer
	syscall

	move $s0, $v0				# Move n value into $s0
	beq $s0, 0, valid			# If n == 0, jump to valid
	blt $s0, MIN, invalid		# If n < 3, jump to invalid
	bgt $s0, MAX, invalid		# If n > 45, jump to invalid
	ble $s0, 25, message1		# If n <= 25, jump to message1
	blt $s0, 30, message2		# If n < 30, jump to message2
	blt	$s0, 35, message3		# If n < 35, jump to message3
	blt $s0, 40, message4		# If n < 40, jump to message4
	ble $s0, MAX, message5		# If n <= 45, jump to message5

message1:
	la $a0, msg0				# Print msg0
	li $v0, 4
	syscall

	b valid						# Jump to valid
message2:
	la $a0, msg1				# Print msg1
	li $v0, 4
	syscall

	b valid						# Jump to valid
message3:
	la $a0, msg2				# Print msg2
	li $v0, 4
	syscall

	b valid						# Jump to valid
message4:
	la $a0, msg3				# Print msg3
	li $v0, 4
	syscall

	b valid						# Jump to valid
message5:
	la $a0, msg4				# Print msg4
	li $v0, 4
	syscall

	b valid						# Jump to valid

invalid:
	la $a0, errMsg				# Print error message
	li $v0, 4
	syscall

	b readStart					# Jump to readStart

valid:
	move $v0, $s0				# Return n value

	lw $s0, 0($sp)				# Pop $s0
	add $sp, $sp, 4

	jr $ra

.end getNumber

#####################################################################
#  Display fibonacci sequence.

# -----
#    Arguments:
#	$a0 - n

#    Returns:
#	fibonacci(n)


#	YOUR CODE GOES HERE

.globl fibonacci
.ent fibonacci
fibonacci:

	sub $sp, $sp, 12
	sw $s0, 0($sp)				# Push $s0
	sw $s1, 4($sp)				# Push $s1
	sw $ra, 8($sp)				# Push $ra

baseCase:
	move $v0, $a0				# Move n value into $v0
	beq $a0, 0, fibDone			# If n == 0, jump to fibDone
	beq $a0, 1, fibDone			# If n == 1, jump to fibDone

fibStart:
	move $s0, $a0				# Save n, move into $s0
	sub $a0, $a0, 2				# (n-2) stored in $a0
	jal fibonacci				# Call fibonacci
	move $s1, $v0				# Store retured value into $s1

	sub $a0, $s0, 1				# (n-1) stored in $a0
	jal fibonacci				# Call fibonacci

	add $v0, $s1, $v0			# fib(n-2) + fib(n-1) stored in $v0

fibDone:

	lw $s0, 0($sp)				# Pop $s0
	lw $s1, 4($sp)				# Pop $s1
	lw $ra, 8($sp)				# Pop $ra
	add $sp, $sp, 12

	jr $ra

.end fibonacci

#####################################################################
#  Display perrin sequence.

# -----
#    Arguments:
#	$a0 - n

#    Returns:
#	perrin(n)


#	YOUR CODE GOES HERE

.globl perrin
.ent perrin
perrin:

	sub $sp, $sp, 12
	sw $s0, 0($sp)				# Push $s0
	sw $s1, 4($sp)				# Push $s1
	sw $ra, 8($sp)				# Push $ra

baseCases:
	beq $a0, 0, baseZero		# If n == 0, jump to baseZero
	beq $a0, 1, baseOne			# If n == 1, jump to baseOne
	beq $a0, 2, baseTwo			# If n == 2, jump to baseTwo

perrinStart:
	move $s0, $a0				# Save n, move into $s0
	sub $a0, $a0, 2				# (n-2) stored in $a0
	jal perrin					# Call perrin
	move $s1, $v0				# Save returned value into $s1

	sub $a0, $s0, 3				# (n-3) stored in $a0
	jal perrin					# Call perrin

	add $v0, $s1, $v0			# perrin(n-2) + perrin(n-3) stored in $v0

	b perrinDone				# Jump to perrinDone

baseZero:
	li $v0, 3					# Return 3 if n = 0
	b perrinDone
baseOne:
	li $v0, 0					# Return 0 if n = 1
	b perrinDone
baseTwo:
	li $v0, 2					# Return 2 if n = 2
	b perrinDone

perrinDone:

	lw $s0, 0($sp)				# Pop $s0
	lw $s1, 4($sp)				# Pop $s1
	lw $ra, 8($sp)				# Pop $ra
	add $sp, $sp, 12

	jr $ra

.end perrin

#####################################################################
#  Print a line as per asst #4 specificiations.

# -----
# Line should look like:
#	num =  0   fibonacci =          0   perrin = 3

# Format:
#	numB=BnnBBBfibonacciB=BffffffffffBBBperrinB=Bppppppp

#	where	B = blank space
#		f = actual fibonacci number (123...)
#		p = actual perrin number (123...)

# Note,	num will always be 1-2 digits.
#	fibonacci will always b 1-10 digits.
#	perrin will always be 1-7 digits.

# -----
#  Arguments:
#	$a0 - N number (value)
#	$a1 - fibonacci number (value)
#	$a2 - perrin number (value)


#	YOUR CODE GOES HERE

.globl prtLine
.ent prtLine
prtLine:

	sub $sp, $sp, 16
	sw $s0, 0($sp)			# Push $s0
	sw $s1, 4($sp)			# Push $s1
	sw $s2, 8($sp)			# Push $s2
	sw $ra, 12($sp)			# Push $ra


calleSave:
	move $s0, $a0			# Move n value into $s0
	move $s1, $a1			# Move fibonacci value into $s1
	move $s2, $a2			# Move perrin value into $s2

printNum:
	la $a0, nMsg			# Print nMsg
	li $v0, 4
	syscall

	move $a0, $s0			# Move n value into $a0
	li $a1, 2				# Move max digit count for num into $a1
	jal prtBlanks			# Call prtBlanks

printFib:
	la $a0, fMsg			# Print fMsg
	li $v0, 4
	syscall

	move $a0, $s1			# Move fibonacci value into $a0
	li $a1, 10				# Move max digit count for fibonacci into $a1
	jal prtBlanks			# Call prtBlanks

printPerrin:
	la $a0, pMsg			# Print pMsg
	la $v0, 4
	syscall

	move $a0, $s2			# Move perrin value into $a0
	li $a1, 7				# Move max digit count for perrin into $a1
	jal prtBlanks			# Call prtBlanks

printDone:

	lw $s0, 0($sp)			# Pop $s0
	lw $s1, 4($sp)			# Pop $s1
	lw $s2, 8($sp)			# Pop $s2
	lw $ra, 12($sp)			# Pop $ra
	add $sp, $sp, 16

	jr $ra

.end prtLine

#####################################################################
#  Print an appropriate number of blanks based on
#  size of the number.

# -----
#  Arguments:
#	$a0 - number (value)
#	$a1 - max number of digits for number (value)


#	YOUR CODE GOES HERE

.globl prtBlanks
.ent prtBlanks
prtBlanks:

	sub $sp, $sp, 12
	sw $s0, 0($sp)						# Push $s0
	sw $s1, 4($sp)						# Push $s1
	sw $s2, 8($sp)						# Push $s2

	move $s2, $zero						# printSpaces = 0
saveCalle:
	move $s0, $a0						# Move value into $s0
	move $s1, $a1						# Move max digit count into $s1

checkLoop:
	beq $a1, 2, numSpacesCheck			# If max digit count == 2, jump to numSpacesCheck
	beq $a1, 10, fibSpacesCheck			# If max digti count == 10, jump to fibSpacesCheck
	beq $a1, 7, perrinSpacesCheck		# If max digit count == 7, jump to perrinSpacesCheck

numSpacesCheck:
	bge $a0, 10, printValue				# If num value >= 10, jump to printValue
	li $s2, 1							# If value < 10, set printSpaces to
	b printSpaces						# Jump to printSpaces

fibSpacesCheck:
	bge $a0, 1000000000, printValue		# If fib value >= 1000000000, jump to printSpaces
	bge $a0, 100000000, oneSpace
	bge $a0, 10000000, twoSpaces
	bge $a0, 1000000, threeSpaces
	bge $a0, 100000, fourSpaces
	bge $a0, 10000, fiveSpaces
	bge $a0, 1000, sixSpaces
	bge $a0, 100, sevenSpaces
	bge $a0, 10, eightSpaces
	li $s2, 9							# If value < 10, set printSpaces to 9
	b printSpaces						# Jump to printSpaces

perrinSpacesCheck:
	bge $a0, 1000000, printValue
	bge $a0, 100000, oneSpace
	bge $a0, 10000, twoSpaces
	bge $a0, 1000, threeSpaces
	bge $a0, 100, fourSpaces
	bge $a0, 10, fiveSpaces
	li $s2, 6							# If value < 10, set printSpaces to 6
	b printSpaces						# Jump to printSpaces

oneSpace:
	li $s2, 1							# Set printSpaces = 1
	b printSpaces
twoSpaces:
	li $s2, 2							# Set printSpaces = 2
	b printSpaces
threeSpaces:
	li $s2, 3							# Set printSpaces = 3
	b printSpaces
fourSpaces:
	li $s2, 4							# Set printSpaces = 4
	b printSpaces
fiveSpaces:
	li $s2, 5							# Set printSpaces = 5
	b printSpaces
sixSpaces:
	li $s2, 6							# Set printSpaces = 6
	b printSpaces
sevenSpaces:
	li $s2, 7							# Set printSpaces = 7
	b printSpaces
eightSpaces:
	li $s2, 8							# Set printSpaces = 8
	b printSpaces

printSpaces:
	la $a0, space						# Print space
	li $v0, 4
	syscall

	sub $s2, $s2, 1						# printSpaces--
	bnez $s2, printSpaces				# If printSpaces != 0, jump to printSpaces

printValue:
	move $a0, $s0						# Print value
	li $v0, 1
	syscall

prtBlanksDone:

	lw $s0, 0($sp)						# Pop $s0
	lw $s1, 4($sp)						# Pop $s1
	lw $s2, 8($sp)						# Pop $s2
	add $sp, $sp, 12

	jr $ra

.end prtBlanks

#####################################################################
