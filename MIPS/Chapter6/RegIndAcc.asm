# Program: RegIndAcc.asm
# Author: Jason Heywood
# Program used to illustrate indirect register memory access

.text 
.globl main
main:
	# Get the input value
	la $a0, prompt
	jal PromptInt
	move $s0, $v0
	
	# Load the constant a, b and c into registers
	lui $t0, 0x1001
	lw $t5, 0($t0)
	addi $t0, $t0, 4
	lw $t6, 0($t0)
	addi $t0, $t0, 4
	lw $t7, 0($t0)
	
	# Calculate the result
	mul $t0, $s0, $s0
	mul $t0, $t0, $t5
	mul $t1, $s0, $t6
	add $t0, $t0, $t1
	add $s1, $t0, $t7
	
	# Print the result 
	la $a0, result
	move $a1, $a