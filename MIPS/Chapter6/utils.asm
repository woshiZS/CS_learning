# File:	utils.asm
# Purpose: To define utilities which will be used in MIPS programs.
# Author: Jason Heywood
#
# Instructors are granted permission to make copies of this file for use by 
# students in this course. Title to and ownership iof all intellectual property rights
# in this file are the exclusive property of Charles W. Kann, Gettysburg, Pa.
#
# Subprograms Index:
#	Exit - 		Call syscall with a server 10 to exit the program 
# 	NewLine - 	Print a new line character (\n) to the console
# 	PrintInt - 	print a string with an integer to the console
# 	PrintString - 	print a string to the console
# 	PromptInt - 	Prompt the user to enter an integer, and return it to the calling program.

# Subprogram: 	PrintNewLine
# Author: 	Jason Heywood
# purpose: 	to output a new line to the uer console
.text
PrintNewLine:
	li $v0, 4
	la $a0, __PNL_newline
	syscall
	jr $ra
.data
	__PNL_newline:	.asciiz "\n"
	
# subprogram: 	PrintInt
# Author: 	Jason Heywood
# purpose: 	To print a stirng to the console 
# input: 	$a0 - The address of the string to print 
# 		$a1 - The value of the int to print
# returns: 	None
# Side effects: 	The String is printed followed by the integer value.
.text
PrintInt:
	li $v0, 4
	syscall 	# string address is already in $a0
	
	# pirnt integer
	move $a0, $a1
	li $v0, 1
	syscall
	
	# return
	jr $ra
	
#subprogram: 	PromptInt
# author: 	Jason Heywood
# purpose: 	prompt the user to enter a integer value
# input: 	$a0 - The address of the string to print
# returns:	$v0 - The value the user entered
# side effexts: 	The string is printed followed bythe integer value.
.text
PromptInt:
	li $v0, 4
	syscall
	
	# read uer input
	move $a0, $a1		# clear $a0
	li $v0, 5
	syscall
	
	# return
	jr $ra
	
# subprogram: 		PrintString
# Author:		Jason Heywood
# Purpose: 		To print a string to the console
# input:		$a0 - The address of the string to print
# returns:		None
# side effects:		The String is printed to the console
.text
PrintString:
	addi $v0, $zero, 4
	syscall
	jr $ra
	
# Subprogram: 		Exit
# Author: 		Jason Heywood
# PUurpose:		to use syscall service 10 to exit a program
# input:		None
# returns:		None
# side effects:		The program is exited
.text
Exit:
	li $v0, 10
	syscall
