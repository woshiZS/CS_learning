# Program: ifStatement.asm
# Author: Jason Heywood
# purpose: program used to illustrate simple if statement
.text
	# if (num>0)
	lw $t0, num
	sgt $t1, $t0, $zero	# $t1 is the boolean (num > 0)
	beqz $t1, end_if	# note the codeblock is entered if logical is true, skipped if false
	
	# { print ("Number is positive")}
	la $a0, positiveNumber
	jal PrintString
	end_if:
	jal Exit

.data
	num: .word 5
	positiveNumber:	.asciiz	"Number is positive"
.include "utils.asm"