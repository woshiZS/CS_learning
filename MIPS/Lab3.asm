# Program: Lab3.asm
# Author: Jason Heywood
# Program to print a diamond
# Pseudo Code
# register i = input("Enter the height of the pattern(must be greater than 0):\t")
# while(i<0){
#	print("Invalid Entry!\n")
#	register i = input("Enter the height of the pattern(must be greater than 0):\t")	
# }
# for (int j = 0; j < i; ++j){
#	for(int k = 0; k < j; ++k){
#		print("*\t")
#	}
#	print(j+1)
#	for (int k = 0; k < j; ++k){
#		print("\t*")
# 	}
# }
#	print("\n")
#
.text
user_input:
	# read user input and record it
	la $a0, prompt
	jal PromptInt
	
	# judge if input is greater than zero
	move $s0, $v0
	sle $t0, $s0, 0
	beqz $t0, output
	la $a0, invalid
	jal PrintString
	b user_input 

output:
	# $t0 must be zero if it goes here
	# print each line
	# set a counter
	slt $t1, $t0, $s0
	beqz $t1, end_program
	
	move $t2, $zero
inside_as1:
	# set another counter for inside for loop which print the asterisks
	slt $t3, $t2, $t0
	beqz $t3, printNum
	la $a0, tailTab
	jal PrintString
	addi $t2, $t2, 1
	b inside_as1
	
printNum:
	# print an integer 
	li $v0, 1
	move $a0, $t0
	addi $a0, $a0, 1
	syscall
	
	move $t2, $zero
inside_as2:
	# print the rest part of the asterisks
	slt $t3, $t2, $t0
	beqz $t3, outside
	la $a0, headTab
	jal PrintString
	addi $t2, $t2, 1
	b inside_as2

outside:
	# print a new line and add 1 to outside loop's couter
	jal PrintNewLine
	addi $t0, $t0, 1
	b output
	
end_program:
	# exit the program
	jal Exit
	
.data
	prompt: .asciiz "Enter the height of the pattern(must be greater than 0):\t"
	invalid: .asciiz "\nInvalid Entry!\n"
	tailTab: .asciiz "*\t"
	headTab: .asciiz "\t*"
.include "utils.asm"