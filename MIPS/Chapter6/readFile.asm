# Program: readFile.asm
# Author: Jason Heywood
# Program used to read content from a file.

.text
.globl main
main:
	# load the file which in the arguments
	lw $a0, 0($a1)
	# need a place to stroe the string, use heap allocation is okay.
	# sw $a0, filename

	# filename is the address of allocated memory
	# la $a0, filename
	li $v0, 13
	li $a1, 0
	syscall
	
	# save the file descriptor
	move $t0, $v0
	li $v0, 14
	la $a1, buffer
	li $a2, 80
	move $a0, $t0
	syscall
	
	move $t1, $v0 # save the readed number
	
	# print the total number read in this file
	la $a0, result
	li $v0, 4
	syscall
	move $a0, $t1
	li $v0, 1
	syscall
	jal PrintNewLine
	
	# print the string read from the file
	li $v0, 4
	la $a0, buffer
	syscall
	
	# Do not forget to close the file
	move $a0, $t0
	li $v0, 16
	syscall
	
	# End the program
	jal Exit
	
.data
	buffer: .space 81
	result: .asciiz "The total read length is "
	filename: .asciiz "text.txt"
	
.include "utils.asm"
