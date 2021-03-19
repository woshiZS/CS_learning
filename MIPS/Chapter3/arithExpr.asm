# Program: arithExpr.asm
# Author: Jason Heywood
# Program used to illustrate the arithmetic expression

.text
main:
	# Output the prompt
	li $v0, 4
	la $a0, prompt
	syscall
	
	# Read an integer and move to $s0
	addi $v0,$zero, 5
	syscall
	move $s0, $v0
	move $t0, $s0
	
	# Arithemetic part, 2 power of x
	mult $t0, $t0
	mflo $t1
	addi $at, $zero, 5
	mult $t1, $at
	mflo $t1
	
	# 1 power of x
	add $t0, $t0, $t0
	addi $at, $zero, 3
	add $t0, $t0, $at
	add $t0, $t0, $t1
	
	# Output the msg
	addi $v0, $zero, 4
	la $a0, OutputMsg
	syscall
	
	# Output the value 
	addi $v0, $zero, 1
	move $a0, $t0
	syscall
	
	# End the program 
	addi $v0, $zero, 10
	syscall
	
.data
prompt: .asciiz "Please input an number used for x.\n"
OutputMsg:	.asciiz "The result of 5*x^2 +  2*x + 3 is "
