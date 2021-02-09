# Program: counterControl.asm
# Author:Jason Hwywood
# Program used to illustrate for loops
# pseudo code
# n = prompt('Please enter the value to calculate sum up to: ")
# total = 0
# for (i = 0; i < n; i++){
#	total = total + i
# }
# print("Total = " + total)
.text
	# prompt and get the input value
	la $a0, prompt
	jal PromptInt
	move $a0, $v0
	# initialization
	lw $t0, total
	addi $t1, $zero, 0
for:
	slt $t2, $t1, $a0
	beqz $t2, end_for
	add $t0, $t0, $t1
	addi $t1, $t1, 1
	b for
	
end_for:
	la $a0, endPrompt
	move $a1, $t0
	jal PrintInt
	jal Exit

.data
	total: .word 0
	prompt: .asciiz "Please enter a number to calculate sum up to: "
	endPrompt: .asciiz "\nTotal = "

.include "utils.asm"