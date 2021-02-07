# Program: Addition exmple
# Author: Jason Heywood
# Program to ilustrate addition examples
# There is 2 types of add operators --- R and I

# illustrate R format Register
li $t1, 100
li $t2, 50
add $t0, $t1, $t2

# add with an immediate 
addi $t0, $t0, 50
add $t0, $t0, 50

# Using an unsign number, notice the
# result is not what is expected
# for negative numbers
addiu $t0, $t2, -100

# Addition with a 32 bit immediate. Note that 5647123
# base 10 is 0x562b13
addi $t1, $t2, 5647123