# Progrma: msgDialog.asm
# Author: Jason Heywood
# Program uses a dialog

.text
main:
	# Show the msg box and read string
	li $v0, 54
	la $a0, prompt
	la $a1, input
	lw $a2, inputSize
	syscall
	
	# No logic branch, just write back
	li $v0, 55
	la $a0, input
	lw $a1, infoType
	syscall
	
	# End Program
	li $v0, 10
	syscall
	
.data
confirmMsg: .asciiz "Are you single again?"
prompt: .asciiz "Please enter a String"
input: .space 51
inputSize: .word 50
infoType: .word 1