# Program: division
# Author: Jason Heywood
# Program used to check whether a number is even or odd

.text
main:
	# Output the prompt
	li $v0, 4
	la $a0, prompt
	syscall
	
	# Read the integer
	li $v0, 5
	syscall
	move $t1, $v0
	
	# Division Arithmetic
	rem $t1, $t1, 2
	
	# Output the result 
	li $v0, 4
	la $a0, msg
	syscall
	
	# Output the remainder
	li $v0, 1
	move $a0, $t1
	syscall
	
	# End the program
	li $v0, 10
	syscall
	
.data
prompt:	.asciiz "Please Enter a number:\t"
msg:	.asciiz	"A result of 0 is even, a result of 1 is odd.\n result = "
	