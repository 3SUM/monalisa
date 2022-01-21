#  Luis Maya
#  CS 218 Section #1002
#  CS 218, MIPS Assignment #3
#  Provided template

#  MIPS assembly language program to check for
#  a magic square.


###########################################################
#  data segment

.data

hdr:		.asciiz	"\nProgram to check a Magic Square. \n\n"

# -----
#  Possible Magic Square #1

msq1:		.word	2, 7, 6
			.word	9, 5, 1
			.word	4, 3, 8
ord1:		.word	3

# -----
#  Possible Magic Square #2

msq2:		.word	16,  3,  2, 13
			.word	 5, 10, 11,  8
			.word	 9,  6,  7, 12
			.word	 4, 15, 14,  1
ord2:		.word	4

# -----
#  Possible Magic Square #3

msq3:		.word	16,  3,  2, 13
			.word	 5, 10, 11,  8
			.word	 9,  5,  7, 12
			.word	 4, 15, 14,  1
ord3:		.word	4

# -----
#  Possible Magic Square #4

msq4:		.word	21,  2,  8, 14, 15
			.word	13, 19, 20,  1,  7
			.word	 0,  6, 12, 18, 24
			.word	17, 23,  4,  5, 11
			.word	 9, 10, 16, 22,  3
ord4:		.word	5

# -----
#  Possible Magic Square #5

msq5:		.word	64, 12, 23, 61, 60, 35, 17, 57
			.word	19, 55, 54, 12, 13, 51, 55, 16
			.word	17, 47, 46, 21, 20, 43, 42, 24
			.word	41, 26, 27, 37, 36, 31, 30, 33
			.word	32, 34, 35, 29, 28, 38, 39, 25
			.word	40, 23, 22, 44, 45, 19, 18, 48
			.word	49, 15, 14, 52, 53, 11, 10, 56
			.word	18, 58, 59, 46, 24, 62, 63, 11
ord5:		.word	8

# -----
#  Possible Magic Square #6

msq6:		.word	 9,  6,  3, 16
			.word	 4, 15, 10,  5
			.word	14, 1,  8, 11
			.word	 7, 12, 13, 1
ord6:		.word	4

# -----
#  Possible Magic Square #7

msq7:		.word	64,  2,  3, 61, 60,  6,  7, 57
			.word	 9, 55, 54, 12, 13, 51, 50, 16
			.word	17, 47, 46, 20, 21, 43, 42, 24
			.word	40, 26, 27, 37, 36, 30, 31, 33
			.word	32, 34, 35, 29, 28, 38, 39, 25
			.word	41, 23, 22, 44, 45, 19, 18, 48
			.word	49, 15, 14, 52, 53, 11, 10, 56
			.word	 8, 58, 59,  5,  4, 62, 63,  1
ord7:		.word	8


# -----
#  Local variables for print header routine.

ds_hdr:		.ascii	"\n-----------------------------------------------------"
			.asciiz	"\nPossible Magic Square #"

nlines:		.asciiz	"\n\n"


# -----
#  Local variables for check magic square.

TRUE = 1
FALSE = 0

rw_msg:		.asciiz	"    Row  #"
cl_msg:		.asciiz	"    Col  #"
d_msg:		.asciiz	"    Diag #"

no_msg:		.asciiz	"\nNOT a Magic Square.\n"
is_msg:		.asciiz	"\nIS a Magic Square.\n"


# -----
#  Local variables for prt_sum routine.

sm_msg:		.asciiz	"   Sum: "


# -----
#  Local variables for prt_matrix function.

newLine:	.asciiz	"\n"

blnks1:		.asciiz	" "
blnks2:		.asciiz	" "
blnks3:		.asciiz	"  "
blnks4:		.asciiz	"   "
blnks5:		.asciiz	"    "
blnks6:		.asciiz	"     "


###########################################################
#  text/code segment

.text

.globl main
.ent main
main:

# -----
#  Display main program header.

	la	$a0, hdr
	li	$v0, 4
	syscall					# print header

# -----
#  Set data set counter.

	li	$s0, 0

# -----
#  Check Magic Square #1

	addu	$s0, $s0, 1
	move	$a0, $s0
	jal	prtHeader

	la	$a0, msq1
	lw	$a1, ord1
	jal	prtSquare

	la	$a0, msq1
	lw	$a1, ord1
	jal	chkMagicSqr

# -----
#  Check Magic Square #2

	addu	$s0, $s0, 1
	move	$a0, $s0
	jal	prtHeader

	la	$a0, msq2
	lw	$a1, ord2
	jal	prtSquare

	la	$a0, msq2
	lw	$a1, ord2
	jal	chkMagicSqr

# -----
#  Check Magic Square #3

	addu	$s0, $s0, 1
	move	$a0, $s0
	jal	prtHeader

	la	$a0, msq3
	lw	$a1, ord3
	jal	prtSquare

	la	$a0, msq3
	lw	$a1, ord3
	jal	chkMagicSqr

# -----
#  Check Magic Square #4

	addu	$s0, $s0, 1
	move	$a0, $s0
	jal	prtHeader

	la	$a0, msq4
	lw	$a1, ord4
	jal	prtSquare

	la	$a0, msq4
	lw	$a1, ord4
	jal	chkMagicSqr

# -----
#  Check Magic Square #5

	addu	$s0, $s0, 1
	move	$a0, $s0
	jal	prtHeader

	la	$a0, msq5
	lw	$a1, ord5
	jal	prtSquare

	la	$a0, msq5
	lw	$a1, ord5
	jal	chkMagicSqr

# -----
#  Check Magic Square #6

	addu	$s0, $s0, 1
	move	$a0, $s0
	jal	prtHeader

	la	$a0, msq6
	lw	$a1, ord6
	jal	prtSquare

	la	$a0, msq6
	lw	$a1, ord6
	jal	chkMagicSqr

# -----
#  Check Magic Square #7

	addu	$s0, $s0, 1
	move	$a0, $s0
	jal	prtHeader

	la	$a0, msq7
	lw	$a1, ord7
	jal	prtSquare

	la	$a0, msq7
	lw	$a1, ord7
	jal	chkMagicSqr

# -----
#  Done, terminate program.

	li	$v0, 10
	syscall

.end main


# -------------------------------------------------------
#  Function to check if a two-dimensional array
#  is a magic square.

#  Algorithm:
#	Find sum for first row

#	Check sum of each row (n row's)
#	  if any sum not equal initial sum, set NOT magic square.
#	Check sum of each column (n col's)
#	  if any sum not equal initial sum, set NOT magic square.
#	Check sum of main diagonal 1
#	  if sum not equal initial sum, set NOT magic square.
#	Check sum of main diagonal 2
#	  if sum not equal initial sum, set NOT magic square.

# -----
#  Formula for multiple dimension array indexing:
#	addr(row,col) = base_address + (rowindex * col_size
#					+ colindex) * element_size

# -----
#  Arguments
#	$a0 - address of two-dimension two-dimension array
#	$a1 - order/size of two-dimension array

.globl chkMagicSqr
.ent chkMagicSqr
chkMagicSqr:

	sub $sp, $sp, 24
	sw $ra, 0($sp)				# Push $ra
	sw $s0, 4($sp)				# Push $s0
	sw $s1, 8($sp)				# Push $s1
	sw $s2, 12($sp)				# Push $s2
	sw $s3, 16($sp)				# Push $s3
	sw $s4, 20($sp)				# Push $s4

calleSave:
	move $s0, $a0          		# Move base address of array into $s0
	move $s1, $a1		   		# Move order/size value into $s1

	la $s2, is_msg				# By default it is a Magic Square

	move $s3, $zero  			# Counter, i = 0
rowOne:
	bge $s3, $s1, endRow1		# If i >= order/size, jump to endRow1
	move $t0, $zero 			# Counter, j = 0
	move $t3, $zero 			# tempSum = 0
rowTwo:
	bge $t0, $s1, endRow2		# If j >= order/size, jump to endRow2
	move $t1, $s0				# Move base address of array into $t1

	mul $t2, $s3, $s1			# (rowIndex * colSize) stored in $t2
	add $t2, $t2, $t0			# (rowIndex * colSize + colIndex) stored in $t2
	mul $t2, $t2, 4				# (Result * 4) stored in $t2

	add $t1, $t1, $t2 			# baseAddress + (rowindex * col_size + colIndex) * dataSize
	lw $t4, 0($t1) 				# Move arr[i][j] into $t4

	add $t3, $t3, $t4			# tempSum += arr[i][j]

	add $t0, $t0, 1				# Update j++
	b rowTwo					# Jump to rowTwo
endRow2:
	bnez $s3, notFirstSum
	move $s4, $t3				# Save first sum in $s4
notFirstSum:
	beqz $s3, firstRowSum 		# After first sum check every other sum
	beq $s4, $t3, firstRowSum
	la $s2, no_msg
firstRowSum:
	la $a0, rw_msg				# Print sum
	move $a1, $s3
	move $a2, $t3
	jal prtMsg					# Call prtMsg

	add $s3, $s3, 1				# Update i++
	b rowOne
endRow1:



move $s3, $zero					# Reset counter, j = 0
columnOne:
	bge $s3, $s1, endCol1		# If j >= order/size, jump to endCol1
	move $t0, $zero 			# Reset counter, i = 0
	move $t3, $zero 			# Reset tempSum = 0
columnTwo:
	bge $t0, $s1, endCol2		# If i >= order/size, jump to endCol2
	move $t1, $s0				# Move base address of array into $t1

	mul $t2, $t0, $s1 			# (rowIndex * colSize) stored in $t2
	add $t2, $t2, $s3			# (rowIndex * colSize + colIndex) stored in $t2
	mul $t2, $t2, 4				# (Result * 4) stored in $t2

	add $t1, $t1, $t2			# baseAddress + (rowindex * col_size + colIndex) * dataSize
	lw $t4, ($t1)				# Move arr[i][j] into $t4

	add $t3, $t3, $t4			# tempSum += arr[i][j]

	add $t0, $t0, 1				# Update i ++
	b columnTwo					# Jump to columnTwo
endCol2:
	beq $s4, $t3, checkColumn		# If tempSum == Sum, jump to CheckCSum
	la $s2, no_msg
checkColumn:
	la $a0, cl_msg
	move $a1, $s3
	move $a2, $t3
	jal prtMsg

	add $s3, $s3, 1 			# Update j++
	b columnOne
endCol1:


move $t0, $zero 				# Reset counter, i = 0
move $t3, $zero	  				# Reset tempSum = 0
diaOne:
	move $t1, $s0				# Move base address of array into $t1

	mul $t2, $t0, $s1 			# (rowIndex * colSize) stored in $t2
	add $t2, $t2, $t0    		# (rowIndex * colSize + colIndex) stored in $t2
	mul $t2, $t2, 4 			# (Result * 4) stored in $t2

	addu $t1, $t1, $t2 			# baseAddress + (rowindex * col_size + colIndex) * dataSize
	lw $t4, ($t1) 				# Move arr[i][j] into $t4

	add $t3, $t3, $t4 			# tempSum += arr[i][j]

	add $t0, $t0, 1				# Update i++
	blt $t0, $s1, diaOne

	beq $s4, $t3, checkDiaOne
	la $s2, no_msg
checkDiaOne:
	la $a0, d_msg
	li $a1, 1
	move $a2, $t3
	jal prtMsg


move $t0, $zero					# Reset counter, i = 0
move $t3, $zero 				# Reset tempSum = 0
sub $t5, $s1, 1					# order/size - 1 (j)
diaTwo:
	move $t1, $s0				# Move base address of array into $t1

	mul $t2, $t0, $s1 			# (rowIndex * colSize) stored in $t2
	add $t2, $t2, $t5 			# (rowIndex * colSize + colIndex) stored in $t2
	mul $t2, $t2, 4 			# (Result * 4) stored in $t2

	addu $t1, $t1, $t2			# baseAddress + (rowindex * col_size + colIndex) * dataSize
 	lw $t4, ($t1)				# Move arr[i][j] into $t4

 	add $t3, $t3, $t4	 		# tempSum += arr[i][j]

	sub $t5, $t5, 1 			# Update j--
	add $t0, $t0, 1				# Update i++
	blt $t0, $s1, diaTwo

	beq $s4, $t3, checkDiaTwo
	la $s2, no_msg
checkDiaTwo:
	la $a0, d_msg
	li $a1, 2
	move $a2, $t3
	jal prtMsg

	la $a0,newLine				# Print newLine
	li $v0, 4
	syscall

	move $a0, $s2				# Print if Magic Square
	li $v0, 4
	syscall


	lw $ra, 0($sp)				# Pop $ra
	lw $s0, 4($sp)				# Pop $s0
	lw $s1, 8($sp)				# Pop $s1
	lw $s2, 12($sp)				# Pop $s2
	lw $s3, 16($sp)				# Pop $s3
	lw $s4, 20($sp)				# Pop $s4
	add $sp, $sp, 24

	jr $ra

.end chkMagicSqr

# -------------------------------------------------------
#  Function to display sum message.

# -----
#  Arguments:
#	$a0 - message (address)
#	$a1 - row/col/diag number (value)
#	$a2 - sum


.globl prtMsg
.ent prtMsg
prtMsg:


	sub $sp, $sp, 12
	sw $s0, 0($sp)			# Push $s0
	sw $s1, 4($sp)			# Push $s1
	sw $s2, 8($sp)			# Push $s2

saveCalle:
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2

	la $a0, newLine			# Print newLine
	li $v0, 4
	syscall

	move $a0, $s0			# Print message
	li $v0, 4
	syscall

	move $a0, $s1			# Print row/col/diag number
	li $v0, 1
	syscall

	la $a0, sm_msg			# Print sum message
	li $v0,4
	syscall

	move $a0, $s2			# Print sum value
	li $v0,1
	syscall


	lw $s0, 0($sp)			# Pop $s0
	lw $s1, 4($sp)			# Pop $s1
	lw $s2, 8($sp)			# Pop $s2
	add $sp, $sp, 12

	jr $ra

.end prtMsg

# ---------------------------------------------------------
#  Display simple header for data set (as per asst spec's).

.globl prtHeader
.ent prtHeader
prtHeader:

	sub	$sp, $sp, 4
	sw $s0, ($sp)

	move $s0, $a0

	la	$a0, ds_hdr
	li	$v0, 4
	syscall

	move $a0, $s0
	li $v0, 1
	syscall

	la $a0, nlines
	li $v0, 4
	syscall

	lw $s0, ($sp)
	add $sp, $sp, 4

	jr	$ra

.end prtHeader

# ---------------------------------------------------------
#  Print possible magic square.
#  Note, a magic square is an N x N array.

#  Arguments:
#	$a0 - starting address of square to ptint
#	$a1 - order (size) of the square

.globl prtSquare
.ent prtSquare
prtSquare:

	sub $sp, $sp, 20
	sw $s0, 0($sp)				# Push $s0
	sw $s1, 4($sp)				# Push $s1
	sw $s2, 8($sp)				# Push $s2
	sw $s3, 12($sp)				# Push $s3
	sw $s4, 16($sp)				# Push $s4


	move $s2, $a0 				# Move baseAddress into $s2
	move $s0, $a1 				# Move order(n) value into $s0
	mul $s3, $s0, $s0 			# (n^2) stored in $s3
	move $s1, $zero 			# Reset counter, i = 0

spacesCheck:
	lw $s4, ($s2)	 			# Move arr[i] value into $s4

	bge $s4, 1000000, printNumber
	bge $s4, 100000, oneSpace
	bge $s4, 10000, twoSpaces
	bge $s4, 1000, threeSpaces
	bge $s4, 100, fourSpaces
	bge $s4, 10, fiveSpaces


sixSpaces:
	la $a0, blnks6				# Print six spaces
	li $v0, 4
	syscall
	b printNumber

fiveSpaces:
	la $a0, blnks5				# Print five spaces
	li $v0, 4
	syscall
	b printNumber

fourSpaces:
	la $a0, blnks4				# Print four spaces
	li $v0, 4
	syscall
	b printNumber

threeSpaces:
	la $a0, blnks3				# Print three spaces
	li $v0, 4
	syscall
	b printNumber

twoSpaces:
	la $a0, blnks2				# Print two spaces
	li $v0, 4
	syscall
	b printNumber

oneSpace:
	la $a0, blnks1				# Print one space
	li $v0, 4
	syscall
	b printNumber


printNumber:
	move $a0, $s4			# Print arr[i] value
	li $v0, 1
	syscall

	add $s2, $s2, 4			# Update baseAddress
	add $s1, $s1, 1			# Update i++

	rem $t0, $s1, $s0 		# if (remainder == 0) get newLine

	bnez $t0, skipNewline
	la $a0, newLine			# Print newline
	li $v0, 4
	syscall

skipNewline:
	blt $s1, $s3, spacesCheck


	lw $s0, 0($sp)			# Pop $s0
	lw $s1, 4($sp)			# Pop $s1
	lw $s2, 8($sp)			# Pop $s2
	lw $s3, 12($sp)			# Pop $s3
	lw $s4, 16($sp)			# Pop $s4
	add $sp, $sp, 20

	jr $ra

.end prtSquare
