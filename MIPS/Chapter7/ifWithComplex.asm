# Program: ifWithComplex.asm
# Author: Jason Hwywood
# Program used to illustrat more complex logical conditions 
.text
	# Prompt for input
	la $a0, prompt
	jal PromptInt
	move $t0, $v0
	
	# if ((x>0) && ((x%2) == 0) && (x < 10))
	sgt $t1, $t0, $zero
	addi $t3, $t0, 1
	rem $t2, $t3, 2
	and $t1, $t1, $t2
	addi $t2, $zero, 10
	slt $t2, $t0, $t2
	and $t1, $t1, $t2
	
	# branch
	beqz $t1, if_ends
	la $a0, succ
	jal PrintString
	
if_ends:
	jal Exit

.data
	prompt: .asciiz "Please enter a number to see if the condition is true: "
	succ:	.asciiz "The condition is true"

.include "utils.asm"