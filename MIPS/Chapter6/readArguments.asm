# Program: readArguments.asm
# Author: Jason Heywood
# Program used to test if arguments reading works

.text
.globl main
main:
	# print the number of the arguments
	move $s0, $a1
	move $a1, $a0
	la $a0, number
	jal PrintInt
	
	# print all the aruments one by one
	jal PrintNewLine
	lw $a0, 0($s0)
	jal PrintString
	jal PrintNewLine
	lw $a0, 4($s0)
	jal PrintString
	
	# End the program
	jal Exit
	
.data
	number: .asciiz "The number of arguments is "

.include "utils.asm"