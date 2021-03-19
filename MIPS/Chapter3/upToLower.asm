# Program: UpToLower.asm
# Author: Jason Heywood
# Program to convert letters from upper case to lower case
.text
.globl main
main:
	# Show adding 0x20 only works if the character is upper case
	ori $v0, $zero, 4
	la $a0, output1
	syscall
	
	# Load character, convert and print 
	ori $t0, $zero, 0x41
	addi $a0, $t0, 0x20
	ori $v0, $zero, 11
	syscall
	
	# Invalud conversion
	ori $v0, $zero, 4
	la $a0, output2
	syscall
	
	ori $t0, $zero, 0x61
	addi $a0, $t0, 0x20
	ori $v0, $zero, 11
	syscall
	
	# Show or'ing 0x20 works if the character is upper or lower case.
	ori $v0, $zero, 4
	la $a0, output1
	syscall
	ori $t0, $zero, 0x41
	ori $a0, $t0, 0x20
	ori $v0, $zero, 11
	syscall
	
	ori $v0, $zero, 4
	la $a0, output1
	syscall
	ori $t0, $zero, 0x61
	ori $a0, $t0, 0x20
	ori $v0, $zero, 11
	syscall
	
	ori $v0, $zero, 10
	syscall
	
.data
output1:	.asciiz "\nValid conversion: "
output2:	.asciiz	"\nInvalud conversion, nothing is printed: "