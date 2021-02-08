# Program:	useUtils.asm
# Author:	Jason Heywood
# purpose: To illustrate implementing and calling a 
# subprogram named PrintNewLine

.text
main:
	# Read an input value from the user
	la $a0, prompt
	jal PromptInt
	move $s0, $v0
	
	# print the value back to the user
	jal PrintNewLine
	la $a0, result
	move $a1, $s0
	jal PrintInt
	
	# call the Exit subprogram to exit
	jal Exit
.data
	prompt:	.asciiz "Please enter an integer: "
	result: .asciiz "You  entered: "
.include "utils.asm"