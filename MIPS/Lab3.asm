##################################################################
# Created by: Mingze, Guo
# 	      mguo12
#	      10 February 2021
#
# Assignment: Lab 3: ASCII-risks
#		     CMPE 012, Computer Systems and Assembly Language
# 		     UC Santa Cruz, Winter 2021
#
# Description: This program is used to print numbers and asterisks to show a reverse diamond to the console
#
# Notes:	This program is intended to run from the MARS IDE.
##################################################################
# Pseudo Code
# int n = input("Enter the height of the pattern(must be greater than 0):\t")
# while(n<0){
#	print("Invalid Entry!\n")
#	int n = input("Enter the height of the pattern(must be greater than 0):\t")	
# }
# for (int i = 0; j < n; i++){
#	for(int j = 0; j < i; j++){
#		print("*\t")
#	}
#	print(i+1)
#	for (int j = 0; j < i; j++){
#		print("\t*")
# 	}
# }
#	print("\n")
.text
READ_INPUT:
	# prompt the user to enter a value
	li $v0, 4
	la $a0, Prompt
	syscall
	
	# read the input
	li $v0, 5
	syscall
	
	# move n from $v0 to $t0
	move $t0, $v0
	
	# check if $t0 is greater than 0, if true, jump to the next part, else print Invalid entry and jump back again
	sgt $t1, $t0, 0
	beq $t1, 1, FOR_LOOP
	
	# print Invalid 
	li $v0, 4
	la $a0, Invalid
	syscall
	
	# jump back
	b READ_INPUT
	
FOR_LOOP:
	# set a counter and cleaer it to 0
	move $t1, $zero
	
Pre:
	# judge if $t1 is less than $t0, if true, go output part.
	slt $t2, $t1, $t0
	beqz $t2, Exit
	
	move $t2, $zero
First:
	# inside for loop to print asterisks and tabs
	slt $t3, $t2, $t1
	beqz $t3, Mid
	li $v0, 4
	la $a0, Front
	syscall
	addi $t2, $t2, 1
	b First

Mid:
	# Print the number
	li $v0, 1
	addi $a0, $t1, 1
	syscall

	move $t2, $zero	
Third:
	# inside for loop to print asterisks and tabs (after number)
	slt $t3, $t2, $t1
	beqz $t3, Tail
	li $v0, 4
	la $a0, End
	syscall
	addi $t2, $t2, 1
	b Third

Tail:
	# add the counter, print a new line and jump back
	li $v0, 4
	la $a0, NewLine
	syscall
	addi $t1, $t1, 1
	b Pre
	
Exit:
	# exit the program
	li $v0, 10
	syscall
.data
	Prompt: .asciiz "Enter the height of the pattern(must be greater than 0):\t"
	Invalid: .asciiz "Invalid Entry!\n"
	Front: .asciiz "*\t"
	End: .asciiz "\t*"
	NewLine: .asciiz "\n"
