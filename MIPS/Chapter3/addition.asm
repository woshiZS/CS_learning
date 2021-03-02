# Program: Addition exmple
# Author: Jason Heywood
# Program to ilustrate addition examples
# There is 2 types of add operators --- R and I

# mul example
.text
main:
li $t0, 3
mulu $a0, $t0, 3

# print
li $v0, 1
syscall

li $v0, 10
syscall

