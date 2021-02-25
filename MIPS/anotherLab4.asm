.data
    content: .space 128
    contLen: .word 127
    prompt: .asciiz "You entered the file:\n"
    badarg: .asciiz "ERROR: Invalid program argument."


.text
main:
    la $a0, prompt
    li $v0, 4
    syscall
    
    lw $a0, 0($a1)
    li $v0, 4
    syscall         # Output prompt message

    # check process
    lw $t0, 0($a1)
    lb $t0, ($t0)
    jal checkFirstChar  # Check the first character
    lw $t0, 0($a1)
    jal checkFileLen
    sle $t0, $v0, 20
    beqz $t0, badArg

    # Read file content
    move $t1, $a0
    lw $t0, 0($a1)
    li $a1, 0
    li $v0, 13
    syscall

    move $a0, $v0
    la $a1, content
    lw $a2, contLen
    li $v0, 14
    syscall



badArg:
    la $a0, badarg
    li $v0, 4
    syscall

    # Exit
    li $v0, 10
    syscall


checkFirstChar:
    # $t0 contains the first char
    sge $t1, $t0, 65
    sle $t2, $t0, 90
    and $t1, $t1, $t2

    sge $t2, $t0, 97
    sle $t3, $t0, 122
    and $t2, $t2, $t3

    or $t1, $t1, $t2
    move $v0, $t1
    jr $ra
    
checkFileLen:
    # $t0 contains the start address, refered to https://stackoverflow.com/questions/27790663/strlen-subroutine-mips
    move $v0, $zero
while:
    lb $t1, 0($t0)
    beqz $t1, while_end
    addi $v0, $v0, 1
    addi $t0, $t0, 1
    b while
while_end:
    jr $ra