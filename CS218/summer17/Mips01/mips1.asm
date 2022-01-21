#  Luis Maya
#  CS 218 Section #1002
#  CS 218, MIPS Assignment #1
#  Provided Template

###########################################################
#  data segment

.data

aSides:	.word	   31,    21,    15,    28,    37
		.word	   10,    14,    13,    37,    54
		.word	  -31,   -13,   -20,   -61,   -36
		.word	   14,    53,    44,    19,    42
		.word	  -27,   -41,   -53,   -62,   -10
		.word	   19,    28,    24,    10,    15
		.word	  -15,   -11,   -22,   -33,   -70
		.word	   15,    23,    15,    63,    26
		.word	  -24,   -33,   -10,   -61,   -15
		.word	   14,    34,    13,    71,    81
		.word	  -38,    73,    29,    17,    93

bSides:	.word	  101,   132,   111,   121,   142
		.word	  133,   114,   173,   131,   115
		.word	 -164,  -173,  -174,  -123,  -156
		.word	  144,   152,   131,   142,   156
		.word	 -115,  -124,  -136,  -175,  -146
		.word	  113,   123,   153,   167,   135
		.word	 -114,  -129,  -164,  -167,  -134
		.word	  116,   113,   164,   153,   165
		.word	 -126,  -112,  -157,  -167,  -134
		.word	  117,   114,   117,   125,   153
		.word	 -123,   173,   115,   106,   113

cSides:	.word	 1234,  1111,  1313,  1897,  1321
		.word	 1145,  1135,  1123,  1123,  1123
		.word	-1254, -1454, -1152, -1164, -1542
		.word	 1353,  1457,   182,  1142,  1354
		.word	-1364, -1134, -1154, -1344, -1142
		.word	 1173,  1543,  1151,  1352,  1434
		.word	-1355, -1037,  -123, -1024, -1453
		.word	 1134,  2134,  1156,  1134,  1142
		.word	-1267, -1104, -1134, -1246, -1123
		.word	 1134,  1161,  1176,  1157,  1142
		.word	-1153,  1193,  1184,  1142,  2034

volumes:	.space	220

len:		.word	55

vMin:		.word	0
vMid:		.word	0
vMax:		.word	0
vSum:		.word	0
vAve:		.word	0

# -----

hdr:		.ascii	"MIPS Assignment #1 \n"
		.ascii	"  Program to calculate the volume of each rectangular \n"
		.ascii	"  parallelepiped in a series of rectangular parallelepipeds.\n"
		.ascii	"  Also finds min, mid, max, sum, and average for volumes.\n"
		.asciiz	"\n"

sHdr:		.asciiz	"  Volumes: \n"

newLine:	.asciiz	"\n"
blnks:		.asciiz	"    "
tab:		.asciiz "\t"

minMsg:		.asciiz	"  Volumes Min = "
midMsg:		.asciiz	"  Volumes Mid = "
maxMsg:		.asciiz	"  Volumes Max = "
sumMsg:		.asciiz	"  Volumes Sum = "
aveMsg:		.asciiz	"  Volumes Ave = "


###########################################################
#  text/code segment

.text
.globl main
.ent main
main:

# -----
#  Display header.

	la	$a0, hdr
	li	$v0, 4
	syscall					# print header

# -----


#	YOUR CODE GOES HERE

	la $t0, volumes				# Move address of volumes[i] into $t0
	la $t1, aSides				# Move address of aSides[i] into $t1
	la $t2, bSides				# Move address of bSides[i] into $t2
	la $t3, cSides				# Move address of cSides[i] into $t3

	li $t7, 0					# Counter, i = 0
	lw $t8, len					# Move length value into $t8

volumesLoop:
	li $t4, 0					# Clear $t4, will be used to set volumes[i]
	lw $t4, ($t1)				# Move aSides[i] value into $t4
	lw $t5, ($t2)				# Move bSides[i] value into $t5
	lw $t6, ($t3)				# Move cSides[i] value into $t6

	mul $t4, $t4, $t5			# (aSides[i] * bSides[i]) stored in $t4
	mul $t4, $t4, $t6			# (aSides[i] * bSides[i] * cSides[i]) stored in $t4

	sw $t4, ($t0)				# Set volumes[i] to answer

	add $t0, $t0, 4				# Update volumes[i]
	add $t1, $t1, 4				# Update aSides[i]
	add $t2, $t2, 4				# Update bSides[i]
	add $t3, $t3, 4				# Update cSides[i]
	add $t7, $t7, 1				# Update counter, i++

	blt $t7, $t8, volumesLoop	# If counter < len, jump to volumesLoop

	la $t0, volumes				# Move address of volumes into $t0
	lw $t1, volumes				# Set min as volumes[0]
	lw $t2, volumes				# Set max as volumes[0]

	li $t7, 0					# Counter, i = 0
	li $t8, 0					# tempSum = 0
	lw $t9, len					# Move length value into $t9
volumesStats:
	li $t3, 0					# Clear $t3, will be used to set sum
	lw $t3, ($t0)				# Move volumes[i] into $t3

	add $t8, $t8, $t3			# tempSum += volumes[i] stored in $t8
	bge $t3, $t1, minDone		# If volumes[i] >= min, jump to minDone
	move $t1, $t3 				# Else set min to volumes[i]
minDone:
  	ble $t3, $t2, maxDone		# If volumes[i] <= max, jump to maxDone
	move $t2, $t3				# Else set max to volumes[i]
maxDone:
	add $t0, $t0, 4				# Update volumes[i]
	add $t7, $t7, 1				# Update counter, i++
	blt $t7, $t9, volumesStats	# If counter < len, jump to volumesStats

statsDone:
	sw $t8, vSum				# Set sum
	sw $t1, vMin				# Set min
	sw $t2, vMax				# Set max

doAverage:
	div $t8, $t8, $t9			# sum/length stored in $t8; Values set from before
	sw $t8, vAve				# Set average

midLoop:
	la $t0, volumes				# Move volumes address into $t0
	lw $t1, len					# Move len value into $t1
	li $t2, 0					# Clear $t2
	rem $t2, $t1, 2				# (length % 2) stored in $t2
	bnez $t2, oddLoop			# If rem != 0, jump to oddLoop
	sub $t1, $t1, 1				# (length - 1) stored in $t1
	div $t1, $t1, 2				# (length - 1)/2 stored in $t1
	mul $t1, $t1, 4				# Value for address of first mid number
	add $t0, $t0, $t1			# Get address of first mid number
	lw $t3, ($t0)				# Move first mid number into $t3
	add $t0, $t0, 4				# Get address for second mid number
	lw $t4, ($t0)				# Move second mid number into $t4
	add $t3, $t3, $t4			# (mid1 + mid2) stored in $t3
	div $t3, $t3, 2				# (mid1 + mid2)/2 stored in $t3
	sw $t3, vMid				# Set mid value
	b midDone					# Jump to midDone
oddLoop:
	sub $t1, $t1, 1				# (length - 1) stored in $t1
	div $t1, $t1, 2				# (length - 1)/2 stored in $t1
	mul $t1, $t1, 4				# Value for address of first mid number
	add $t0, $t0, $t1			# Get address of first mid number
	lw $t3, ($t0)				# Move first mid number into $t3
	sw $t3, vMid				# Set mid value
	b midDone					# Jump to midDone
midDone:

outputData:
	la $a0, sHdr				# Print volumes header
	li $v0, 4
	syscall

	la $a0, blnks				# Print tab
	li $v0, 4
	syscall

	la $s0, volumes				# Move volumes address into $s0
	li $s1, 0					# Display counter, i = 0
	lw $s2, len					# Move length value into $s2
printVolumes:
	lw $a0, ($s0)				# Move volumes[i] into $a0
	li $v0, 1					# Call code for print
	syscall

	la $a0, blnks				# Print spaces
	li $v0, 4
	syscall

	add $s0, $s0, 4				# Update volumes[i]
	add $s1, $s1, 1				# Update counter
	sub $s2, $s2, 1				# length--
	rem $t0, $s1, 6				# (display counter % 6) stored in $t0
	bnez $t0, skipNewLine		# If $t0 != 0, jump to skipNewLine

	la $a0, newLine				# Print newLine
	li $v0, 4
	syscall

	la $a0, blnks				# Print tab
	li $v0, 4
	syscall
skipNewLine:
	bnez $s2, printVolumes		# If length != 0, jump to printVolumes

	la $a0, newLine				# Print newLine
	li $v0, 4
	syscall

	la $a0, newLine				# Print newLine
	li $v0, 4
	syscall

printStats:
	la $a0, minMsg				# Print min message
	li $v0, 4
	syscall

	lw $a0, vMin				# Print min value
	li $v0, 1
	syscall

	la $a0, newLine				# Print newLine
	li $v0, 4
	syscall
# -----
	la $a0, midMsg				# Print mid message
	li $v0, 4
	syscall

	lw $a0, vMid				# Print mid value
	li $v0, 1
	syscall

	la $a0, newLine				# Print newLine
	li $v0, 4
	syscall
# -----
	la $a0, maxMsg				# Print max message
	li $v0, 4
	syscall

	lw $a0, vMax				# Print max value
	li $v0, 1
	syscall

	la $a0, newLine				# Print newLine
	li $v0, 4
	syscall
# -----
	la $a0, sumMsg				# Print sum message
	li $v0, 4
	syscall

	lw $a0, vSum				# Print sum value
	li $v0, 1
	syscall

	la $a0, newLine				# Print newLine
	li $v0, 4
	syscall
# -----
	la $a0, aveMsg				# Print ave message
	li $v0, 4
	syscall

	lw $a0, vAve				# Print ave value
	li $v0, 1
	syscall

	la $a0, newLine				# Print newLine
	li $v0, 4
	syscall

# -----
#  Done, terminate program.

endit:
	la	$a0, newLine			# print a newline
	li	$v0, 4
	syscall

	li	$v0, 10
	syscall					# all done!

.end main
