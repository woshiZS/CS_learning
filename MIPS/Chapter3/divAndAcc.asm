# Program: DivAndAcc.asm
# Author: Jason Heywood
# Program to iluustrate precision losing

.text
main:
	# store the number
	addi $s0, $zero, 10
	addi $s1, $zero, 3
	
	# calculate result 1
	div $s2, $s0, $s1
	mul $s2, $s2, $s1
	
	# Output the msg and result1
	addi $v0, $zero, 4
	la $a0, output
	syscall
	addi $v0, $zero, 1
	move $a0, $s2
	syscall
	
	# Another kind of try
	mul $s2, $s0, $s1
	div $s2, $s2, $s1
	
	
	# Output the Message and result again
	addi $v0, $zero, 4	
	la $a0, output
	syscall
	addi $v0, $zero, 1
	move $a0, $s2
	syscall
	
	# End the program
	addi $v0, $zero, 10
	syscall
	
.data
output: .asciiz "\n The calculate result is :"