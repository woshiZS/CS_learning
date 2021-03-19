# Program: Lab4.asm
# Author: Jason Heywood
# Program used to do brackets matching

.text

.globl main
main:
	# check argument count
	move $s0, $a0
	seq $s1, $s0, 1
	beqz $s1, ARG_FAULT
	
	# check if the first character is a letter
	lw $t0, 0($a1)
	lb $t0, 0($t0)
	# A-Z
	sge $t1, $t0, 65
	sle $t2, $t0, 90
	and $t1, $t1, $t2
	# a-z
	sge $t2, $t0, 97
	sle $t3, $t0, 122
	and $t2, $t2, $t3
	or $t1, $t1, $t2
	beqz $t1, ARG_FAULT
	
	# check if it is more than 20 characters
	lw $a0, 0($a1)
	jal strlen
	move $s0, $v0
	sle $s1, $s0, 20
	beqz $s1, ARG_FAULT
	
	# Filename check passed, print the filename
	la $a0, msg1
	li $v0, 4
	syscall
	lw $a0, ($a1)
	li $v0, 4
	syscall		# print the filename
	
	li $a0, 10
	li $v0, 11
	syscall
	li $a0, 10
	li $v0, 11
	syscall 	# print a new line twice
	
	# read the file and check bracket matching
	move $t7, $a1
	lw $a0, 0($t7)
	li $a1, 0
	li $v0, 13
	syscall
	
	# save file descriptor
	move $t0, $v0
	li $v0, 14
	la $a1, buffer
	li $a2, 127	# in case of the '\0' chracter
	move $a0, $t0
	syscall
	
	move $t1, $v0 	# save the read number
	li $t2, 0
	la $t4, buffer	# string address
	move $t6, $sp		# record the original stack pointer value
	move $t7, $zero 	# set matched pairs to 0
	for_loop:
		slt $t3, $t2, $t1
		beqz $t3, end_for
		lb $t5, ($t4)
		# if left brackets push the stack, if right stack, judge if match the top, if not print the error
		jal braCheck
		# $v0 contains the return value, 1 push, -1 pop, 0 other value, -2 mismatch
		bne $v0, 1, elif1
		subi $sp, $sp, 1
		sb $t5, 0($sp)
		b setCount
		elif1:
			bne $v0, -1, else
			addi $sp, $sp, 1
			addi $t7, $t7, 1
			b setCount
		else:
			bne $v0, -2, setCount
			jal MATCH_FAULT
		setCount:
			addi $t2, $t2, 1
			addi $t4, $t4, 1
			b for_loop
		
end_for:
	# check if stack is empty
	seq $t1, $sp, $t6
	beqz $t1, EXTRA_FAULT
	li $v0, 4
	la $a0, success
	syscall
	li $v0, 1
	move $a0, $t7
	syscall 	# print pair nums
	li $v0, 4
	la $a0, success_tail
	syscall
	b Exit
	
	
ARG_FAULT:
	la $a0, error1
	li $v0, 4
	syscall
	b Exit

MATCH_FAULT:
	la $a0, error2
	li $v0, 4
	syscall
	li $v0, 11
	move $a0, $t5	# $t5 contains this char
	syscall		# print the mismatch bracket
	la $a0, error2_tail
	li $v0, 4
	syscall
	li $v0, 1
	move $a0, $t2
	syscall
	b Exit

EXTRA_FAULT:
	li $v0, 4
	la $a0, error3
	syscall
	# print the left bracket in a reverse order
	print_bra:
		lb $a0, 0($sp)
		li $v0, 11
		syscall
		addi $sp, $sp, 1
		beq $sp, $t6, end_print
		b print_bra
	end_print:
		b Exit

Exit:
	# remember to close the file descriptor, if not open it is also okay.
	move $a0, $t0
	li $v0, 16
	syscall
	li $v0, 11
	li $a0, 10
	syscall 	# start a new line
	li $v0, 10
	syscall		# Exit the program

strlen:
	addi $sp, $sp, -4
	sw $ra, ($sp)
	
	move $t0, $zero
	
	while:
		lb $t0, 0($a0)
		jal valid_char
		beqz $t1, ARG_FAULT	# WONDER if here shour pop the stack?
		beqz $t0, end_while
		subi $t1, $t0, 10
		beqz $t1, end_while	# In case MARS read the "\n" for a character
		addi $v0, $v0, 1
		addi $a0, $a0, 1
		b while
	end_while:
		lw $ra, ($sp)
		addi $sp, $sp, 4
		jr $ra

valid_char:
	addi $sp, $sp, -4
	sw $ra, ($sp)
	
	# $t0 contain the byte
	seq $t1, $t0, 46	# period 
	seq $t2, $t0, 95	# underscore
	or $t1, $t1, $t2
	seq $t2, $t0, 0		# '\0'
	or $t1, $t1, $t2
	seq $t2, $t0, 10	# '\n'
	or $t1, $t1, $t2
	# 0-9
	sge $t2, $t0, 48
	sle $t3, $t0, 57
	and $t2, $t2, $t3			# And operation 
	or $t1, $t1, $t2
	# A-Z
	sge $t2, $t0, 65
	sle $t3, $t0, 90
	and $t2, $t2, $t3
	or $t1, $t1, $t2
	# a-z
	sge $t2, $t0, 97
	sle $t3, $t0, 122
	and $t2, $t2, $t3
	or $t1, $t1, $t2
	
	lw $ra, ($sp)
	addi $sp, $sp, 4
	jr $ra

braCheck:
	# $t5 contain the character
	seq $s0, $t5, 40
	beq $s0, 1, leftConfirm
	seq $s0, $t5, 91
	beq $s0, 1, leftConfirm
	seq $s0, $t5, 123
	beq $s0, 1, leftConfirm
	seq $s0, $t5, 41
	beq $s0, 1, rightConfirm1
	seq $s0, $t5, 93
	beq $s0, 1, rightConfirm2
	seq $s0, $t5, 125
	beq $s0, 1, rightConfirm3
	li $v0, 0
	jr $ra
	leftConfirm:
		li $v0, 1
		jr $ra
	rightConfirm1:
		li $v0, -1
		lb $s0, ($sp)
		bne $s0, 40, mismatch
		jr $ra
	 rightConfirm2:
		li $v0, -1
		lb $s0, ($sp)
		bne $s0, 91, mismatch
		jr $ra
	rightConfirm3:
		li $v0, -1
		lb $s0, ($sp)
		bne $s0, 123, mismatch
		jr $ra
	mismatch:
		li $v0, -2
		jr $ra

.data
	msg1: .asciiz "You entered the file:\n"
	error1: .asciiz "ERROR: Invalid program argument."
	error2: .asciiz "ERROR - There is a brace mismatch: "
	error2_tail: .asciiz " at index "
	error3: "ERROR - Brace(s) still on stack: "
	success: .asciiz "SUCCESS: There are "
	success_tail: .asciiz " pairs of braces."
	buffer: .space 128
