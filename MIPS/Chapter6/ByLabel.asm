# Program: ByLabel.asm
# Author: Jason Heywood
# Program used to illustrated addressing by label

.text
.globl main
main:
	# Get the input value and store it in $S0
	la $a0, prompt
	jal PromptInt
	move $s0, $v0
	
	# Load the constant a, b, c
	lw $t5, a
	lw $t6, b
	lw $t7, c
	
	# Calculate the result
	mul $t0, $s0, $s0
	mul $t0, $t0, $t5
	mul $t1, $s0, $t6
	add $t0, $t0, $t1
	add $s1, $t0, $t7
	
	# Store the result 
	sw $s1, y
	
	# Print out from memory y
	la $a0, result
	lw $a1, y
	jal PrintInt
	jal PrintNewLine
	
	# Exit the program
	jal Exit
	
.data
	a: .word 5
	b: .word 2
	c: .word 3
	y: .word 0
	prompt: .asciiz "Please input the value of X\n"
	result: .asciiz "The final result is "
	
.include "utils.asm"