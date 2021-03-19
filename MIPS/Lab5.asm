# Winter 2021 CSE12 Lab5 Template
######################################################
# Macros for instructor use (you shouldn't need these)
######################################################

# Macro that stores the value in %reg on the stack 
#	and moves the stack pointer.
.macro push(%reg)
	subi $sp $sp 4
	sw %reg 0($sp)
.end_macro 

# Macro takes the value on the top of the stack and 
#	loads it into %reg then moves the stack pointer.
.macro pop(%reg)
	lw %reg 0($sp)
	addi $sp $sp 4	
.end_macro

#################################################
# Macros for you to fill in (you will need these)
#################################################

# Macro that takes as input coordinates in the format
#	(0x00XX00YY) and returns x and y separately.
# args: 
#	%input: register containing 0x00XX00YY
#	%x: register to store 0x000000XX in
#	%y: register to store 0x000000YY in
.macro getCoordinates(%input %x %y)
	add %x, $zero, %input
	srl %x, %x, 16
	add %y, $zero, %input
	sll %y, %y, 16
	srl %y, %y, 16
.end_macro

# Macro that takes Coordinates in (%x,%y) where
#	%x = 0x000000XX and %y= 0x000000YY and
#	returns %output = (0x00XX00YY)
# args: 
#	%x: register containing 0x000000XX
#	%y: register containing 0x000000YY
#	%output: register to store 0x00XX00YY in
.macro formatCoordinates(%output %x %y)
	add %output, $zero, %x
	sll %output, %output, 16
	add %output, %output, %y
.end_macro 

# Macro that converts pixel coordinate to address
# 	output = origin + 4 * (x + 128 * y)
# args: 
#	%x: register containing 0x000000XX
#	%y: register containing 0x000000YY
#	%origin: register containing address of (0, 0)
#	%output: register to store memory address in
.macro getPixelAddress(%output %x %y %origin)
	mulu %output, %y, 128
	add %output, %output, %x
	mulu %output, %output, 4
	add %output, %output, %origin
.end_macro


.data
originAddress: .word 0xFFFF0000

.text
# prevent this file from being run as main
li $v0 10 
syscall

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  Subroutines defined below
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#*****************************************************
# Clear_bitmap: Given a color, will fill the bitmap 
#	display with that color.
# -----------------------------------------------------
# Inputs:
#	$a0 = Color in format (0x00RRGGBB) 
# Outputs:
#	No register outputs
#*****************************************************
clear_bitmap: 
	# use a for loop to store word in these areas, 
	li $t0, 0
	lw $t1, originAddress
	clearLoop:
		sw $a0, 0($t1)
		addi $t0, $t0, 4
		addi $t1, $t1, 4
		blt $t0, 65536, clearLoop
 	jr $ra

#*****************************************************
# draw_pixel: Given a coordinate in $a0, sets corresponding 
#	value in memory to the color given by $a1
# -----------------------------------------------------
#	Inputs:
#		$a0 = coordinates of pixel in format (0x00XX00YY)
#		$a1 = color of pixel in format (0x00RRGGBB)
#	Outputs:
#		No register outputs
#*****************************************************
draw_pixel: nop
	getCoordinates($a0, $t0, $t1)
	lw $t2, originAddress
	getPixelAddress($t3, $t0, $t1, $t2)
	sw $a1, ($t3)
	jr $ra
	
#*****************************************************
# get_pixel:
#  Given a coordinate, returns the color of that pixel
#-----------------------------------------------------
#	Inputs:
#		$a0 = coordinates of pixel in format (0x00XX00YY)
#	Outputs:
#		Returns pixel color in $v0 in format (0x00RRGGBB)
#*****************************************************
get_pixel: nop
	getCoordinates($a0, $t0, $t1)
	lw $t2, originAddress
	getPixelAddress($t3, $t0, $t1, $t2)
	lw $v0, ($t3)
	jr $ra

#*****************************************************
# draw_horizontal_line: Draws a horizontal line
# ----------------------------------------------------
# Inputs:
#	$a0 = y-coordinate in format (0x000000YY)
#	$a1 = color in format (0x00RRGGBB) 
# Outputs:
#	No register outputs
#*****************************************************
draw_horizontal_line: nop
	# store in a line, construct the coordinate and get the address
	li $t0, 0
	lw $t1, originAddress
	dhlLoop:
		getPixelAddress($t2, $t0, $a0, $t1)
		sw $a1, ($t2)
		addi $t0, $t0, 1
		blt $t0, 0x80, dhlLoop
 	jr $ra


#*****************************************************
# draw_vertical_line: Draws a vertical line
# ----------------------------------------------------
# Inputs:
#	$a0 = x-coordinate in format (0x000000XX)
#	$a1 = color in format (0x00RRGGBB) 
# Outputs:
#	No register outputs
#*****************************************************
draw_vertical_line: nop
	li $t0, 0
	lw $t1, originAddress
	dvlLoop:
		getPixelAddress($t2, $a0, $t0, $t1)
		sw $a1, ($t2)
		addi $t0, $t0, 1
		blt $t0, 0x80, dvlLoop
 	jr $ra


#*****************************************************
# draw_crosshair: Draws a horizontal and a vertical 
#	line of given color which intersect at given (x, y).
#	The pixel at (x, y) should be the same color before 
#	and after running this function.
# -----------------------------------------------------
# Inputs:
#	$a0 = (x, y) coords of intersection in format (0x00XX00YY)
#	$a1 = color in format (0x00RRGGBB) 
# Outputs:
#	No register outputs
#*****************************************************
draw_crosshair: nop
	push($ra)
	push($s0)
	push($s1)
	push($s2)
	push($s3)
	push($s4)
	push($s5)
	move $s5 $sp

	move $s0 $a0  # store 0x00XX00YY in s0
	move $s1 $a1  # store 0x00RRGGBB in s1
	getCoordinates($a0 $s2 $s3)  # store x and y in s2 and s3 respectively
	
	# get current color of pixel at the intersection, store it in s4
	# YOUR CODE HERE, only use the s0-s4 registers (and a, v where appropriate)
	jal get_pixel
	move $s4, $v0 # store pixel color in $v0

	# draw horizontal line (by calling your `draw_horizontal_line`) function
	# YOUR CODE HERE, only use the s0-s4 registers (and a, v where appropriate)
	move $a0, $s3
	jal draw_horizontal_line

	# draw vertical line (by calling your `draw_vertical_line`) function
	# YOUR CODE HERE, only use the s0-s4 registers (and a, v where appropriate)
	move $a0, $s2
	jal draw_vertical_line

	# restore pixel at the intersection to its previous color
	# YOUR CODE HERE, only use the s0-s4 registers (and a, v where appropriate)
	move $a0, $s0
	move $a1, $s4
	jal draw_pixel

	move $sp $s5
	pop($s5)
	pop($s4)
	pop($s3)
	pop($s2)
	pop($s1)
	pop($s0)
	pop($ra)
	jr $ra
