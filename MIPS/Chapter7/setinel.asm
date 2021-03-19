# Progtram: setinel.asm
# Author: Jason Heywood
# Program used to illustrate while loop
# int i =  prompt("Please enter an integer: ");
# while(i != 1){
#	print("You entered " + i);
#	i = prompt("Enter an integer, or -1 to exit");
#}

.text
	la $a0, prompt1
	jal PromptInt
while:
	move $t0, $v0
	sne $t1, $t0, -1
	beqz $t1, end_while
	la $a0, prompt2
	move $a1, $t0
	jal PrintInt
	la $a0, prompt3 
	jal PromptInt
	b while

end_while:
	jal Exit
.data
	prompt1: .asciiz "Please enter an integer: "
	prompt2: .asciiz "You entered "
	prompt3: .asciiz "\nEnter an integer or -1 to exit\n"
.include "utils.asm"
