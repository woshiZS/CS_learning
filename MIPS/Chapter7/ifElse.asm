# Program: ifElse.asm
# Author: Jason Heywood
# Program used to illustrate 
.text
	# prompt the user to enter a number
	la $a0, prompt
	jal PromptInt
	move $t0, $v0
	
	# judge the number is grater than 0 or not
	sgt $t0, $t0, 0
	beqz $t0, else
	la $a0, positive
	jal PrintString
	b end_if
	
	# need 2 extra branches
else:
	la $a0, negative
	jal PrintString
end_if:
	jal Exit
	
.data
	prompt: .asciiz "Please enter a number to judge if it is positive or not: "
	positive: .asciiz "The number you've entered is postive.\n"
	negative: .asciiz "The number you've entered is negative.\n"
	
.include "utils.asm"