# Program: fileIO.asm
# Author: Jason Heywood
# Program used to read file and test for stack implementation

.text
main:
	lw $a0, 0($a1)
	li $v0, 4
	syscall		# print file name

	li $a1, 0
	li $v0, 13
	syscall
	
	move $a0, $v0
	move $t7, $v0
	li $v0, 14
	la $a1, buffer
	li $a2, 127
	syscall
	
	move $t0, $v0		# save the number of characters which were read
	li $v0, 11
	li $a0, 10
	syscall 	# start a new line
	li $v0, 1
	move $a0, $t0
	syscall
	li $t1, 0		# set a counter
for_loop:
	slt $t2, $t1, $t0
	beqz $t2, end_for
	lb $t3, buffer($t1)
	subi $sp, $sp, 1
	sb $t3, 0($sp)
	addi $t1, $t1, 1
	b for_loop
	
end_for:
	# print character in reverse order
	lb $a0, 0($sp)
	li $v0, 11
	syscall
	addi $sp, $sp, 1
	lb $a0, 0($sp)
	li $v0, 11
	syscall
	addi $sp, $sp, 1
	lb $a0, 0($sp)
	li $v0, 11
	syscall
	addi $sp, $sp, 1
	lb $a0, 0($sp)
	li $v0, 11
	syscall
	addi $sp, $sp, 1
	lb $a0, 0($sp)
	li $v0, 11
	syscall
	addi $sp, $sp, 1
	lb $a0, 0($sp)
	li $v0, 11
	syscall
	addi $sp, $sp, 1
	lb $a0, 0($sp)
	li $v0, 11
	syscall
	addi $sp, $sp, 1
	
	# Exit
	# close file
	move $a0, $t7
	li $v0, 16
	syscall
	li $v0, 10
	syscall

.data
	buffer: .space 128
