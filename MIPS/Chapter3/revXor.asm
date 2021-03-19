# Program: revXor.asm
# Author: Jason Heywood
# Program used to do reverse Xor
# That is Xor twice returns the original number.

.text
.globl main
main:
	ori $s0, $zero, 0x01234567
	
	# Write out the XOR's ed value
	la $a0, output1
	li $v0, 4
	syscall
	xori $s0, $s0, 0xffffffff
	move $a0, $s0
	li $v0, 34
	syscall
	
	# Show the original value has been restored
	la $a0, output2
	li $v0, 4
	syscall
	xori $s0, $s0, 0xffffffff
	move $a0, $s0
	li $v0, 34
	syscall
	
	ori $v0, $zero, 10
	syscall
	
.data
	output1: .asciiz "\nAfter first XOR: "
	output2: .asciiz "\nAfter second XOR: "