##################################################################################################################
# Created by:   Mingze, Guo
#               mguo12
#               24 Feburary 2021
#
# Assignment:   Lab 4: Syntax Checker
#               CSE 012, Winter 2021
#
# Pseudo Code:
#       int main(int argc, char** argv){
#           char* firstArg = argv[0]
#           print("%s\n\n", firstArg)
#           char c = firstArg[0] 
#           if (c <= 'A' or ( c > 'Z' and c < 'a') or c > 'z' ){
#               print("ERROR: Invalid program argument.\n")
#               return -1
#           }
#           if (strlen(firstArg) > 20){
#               print("ERROR: Invalid program argument.")
#               return -1
#           }
#           int i = 0
#           int matchedPairs = 0
#           char* stack = (char *)malloc(sizeof(char)*strlen(firstArg))
#           char* stackBak = stack
#           while((c=firstArg[i])!='\0'){
#               if (c == '(' or c == '[' or c == '{'){
#                   stack[0] = c
#                   stack += 1
#               }
#               if(c == ')'){
#                   if(stack[-1] == '('){
#                   stack -= 1
#                   matchedPairs += 1
#                   }
#                   else{
#                       print("ERROR - There is a brace mismatch: %c at index %d", c, i)
#                       return -1
#                   }
#               }
#               if(c == ']'){
#                   if(stack[-1] == '['){
#                   stack -= 1
#                   matchedPairs += 1
#                   }
#                   else{
#                       print("ERROR - There is a brace mismatch: %c at index %d", c, i)
#                       return -1
#                   }
#               }
#               if(c == '}'){
#                   if(stack[-1] == '{'){
#                   stack -= 1
#                   matchedPairs += 1
#                   }
#                   else{
#                       print("ERROR - There is a brace mismatch: %c at index %d", c, i)
#                       return -1
#                   }
#               }
#               stack += 1
#               i += 1
#           }
#           if (stack != stackBak){
#               printf("ERROR - Brace(s) still on stack: ")
#               while(stack != stackBak){
#                   print(stack[0])
#                   stack -= 1
#               }
#               print("\n")
#               return -1
#           }
#           print("SUCCESS: There are %d pairs of braces.", matchedPairs)
#           return 0
#         }
#
#################################################################################################################################
.data
    content: .space 128
    contLen: .word 127
    prompt: .asciiz "You entered the file:\n"
    badarg: .asciiz "ERROR: Invalid program argument."
    matcherrorpre: .asciiz "ERROR - There is a brace mismatch: "
    matcherrorsuff: .asciiz " at index "
    extraerror: .asciiz "ERROR - Brace(s) still on stack: "
    successpre: .asciiz "SUCCESS: There are "
    successsuff: .asciiz " pairs of braces."

.text
main:
    la $a0, prompt
    li $v0, 4
    syscall
    
    lw $a0, 0($a1)
    li $v0, 4
    syscall         # Output prompt message
    jal printNewLine
    jal printNewLine

    # check process
    lw $t0, 0($a1)
    lb $t0, ($t0)
    jal checkFirstChar  # Check the first character
    lw $t0, 0($a1)
    jal checkFileLen
    sle $t0, $v0, 20
    beqz $t0, badArg

    # Read file content
    move $t1, $a1
    lw $a0, 0($a1)
    li $a1, 0
    li $v0, 13
    syscall

    move $a0, $v0
    la $a1, content
    lw $a2, contLen
    li $v0, 14
    syscall

    move $a1, $t1
    move $t0, $v0

    # allocate a same size memory and record the start address
    move $a0, $t0
    li $v0, 9
    syscall

    move $t7, $v0        # saved for later check
    move $t6, $v0        # used for the constructed stack pointer

    # a for loop to push and pop braces   
    # $t0: True content length.
    # $t1: Counter which is used to control the for loop
    # $t5: Number of successfully matched pairs
    # $t6: Stack pointer
    # $t7: Address for later check(if there are extra braces in the stack)
    move $t1, $zero
    move $t5, $zero
for:
    sle $t2, $t1, $t0
    beqz $t2, end_for
    lb $t2, content($t1)
    # $t2 == left braces, push; $t2 == right braces, check, match and pop, else print mismatch msg; for other chars, just ignore.
    jal charCheck
    addi $t1, $t1, 1
    b for

end_for:
    # check if there are left braces in the stack
    bne $t6, $t7, extraBraces
    la $a0, successpre
    li $v0, 4
    syscall
    move $a0, $t5
    li $v0, 1
    syscall
    la $a0, successsuff
    li $v0, 4
    syscall

    li $v0, 11
    li $a0, 10
    syscall     # Print a new line

    # Exit
    li $v0, 10
    syscall


badArg:
    la $a0, badarg
    li $v0, 4
    syscall

    li $v0, 11
    li $a0, 10
    syscall     # Print a new line

    # Exit
    li $v0, 10
    syscall

mismatch:
    # $t2 contains the mismatch charcter and pos number is $t1
    la $a0, matcherrorpre
    li $v0, 4
    syscall
    move $a0, $t2
    li $v0, 11
    syscall
    la $a0, matcherrorsuff
    li $v0, 4
    syscall
    move $a0, $t1
    li $v0, 1
    syscall

    li $v0, 11
    li $a0, 10
    syscall     # Print a new line

    # Exit
    li $v0, 10
    syscall

extraBraces:
    # print out the left braces in reverse order, from $t6 to $t7
    la $a0, extraerror
    li $v0, 4
    syscall
reverseChar:
    lb $a0, -1($t6)
    li $v0, 11
    syscall
    subi $t6, $t6, 1
    bne $t6, $t7, reverseChar

    li $v0, 11
    li $a0, 10
    syscall     # Print a new line

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
    beqz $t1, badArg
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

charCheck:
    # $t2 contains the target char
    beq $t2, 40, push
    beq $t2, 91, push
    beq $t2, 123, push
    beq $t2, 41, checkParen
    beq $t2, 93, checkBrack
    beq $t2, 125, checkBrace
    # Character which are not braces, brackets or parentheses
    jr $ra 
push:
    sb $t2, 0($t6)
    addi $t6, $t6, 1
    jr $ra
checkParen:
    lb $t3, -1($t6)
    beq $t3, 40, pop
    # mismatch condition, just exit, no need to go the original caller point
    jal mismatch

checkBrack:
    lb $t3, -1($t6)
    beq $t3, 91, pop
    jal mismatch

checkBrace:
    lb $t3, -1($t6)
    beq $t3, 123, pop
    jal mismatch

pop:
    subi $t6, $t6, 1
    addi $t5, $t5, 1
    jr $ra

printNewLine:
    li $a0, 10
    li $v0, 11
    syscall
    jr $ra
