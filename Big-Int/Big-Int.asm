# Project:		Big-Int
# Name:			Jeffrey Salinas
# Date: 		12/17/2025
	
	
	.text	
main: 
# $s0 	lo (lo 32 bits)
# $s1	hi (hi 32 bits)
# $s2	i (index)
#
# $t0  	remainder
# $t1	10 (divisor)
# 
	li $s0, 0
	li $s1, 0
		
	li $s2, 0 			# i;
	li $t1, 10			# 
		
loop:
	or $t3, $s0, $s1	# if(lo > 0 || hi > 0)
	beqz $t3, endloop	#
	
	move $a0, $s0		# pass LO
	move $a1, $s1		# pass HI
	jal mod_10_to_stack
		
	move $s0, $v0		# update LO
	move $s1, $v1		# update HI
	
	addi $s2, $s2, 1	# 	i++
	j loop
		
endloop:


print_loop:
	beqz $s2, print_loopend	# if(i > 0)
		
	lw $a0, 0($sp)			# pop remainder 
	addi $sp, $sp, 4
	addi $a0, $a0, 48		# convert remainder to ascii
	li $v0, 11				# print remainder 
	syscall
		
	addi $s2, $s2, -1		# 	i--
	j print_loop
		
print_loopend:
	li $v0, 10
	syscall
		
		
# # # # # #

# -----------------------------------------------------------------------
# FUNCTION: mod_10_to_stack
# Description: Divides 64-bit number by 10, updates Quotient, PUSHES Remainder.
#
# Inputs:  $a0 (LO), $a1 (HI)
# Outputs: $v0 (New LO), $v1 (New HI)
# Note: Decrements $sp by 4 and saves the remainder there.
# -----------------------------------------------------------------------

mod_10_to_stack:
# $t0 	remainder
# $t1 	loop count
    li $t0, 0           
    li $t1, 64          

mod_loop_inner:
    sll $t0, $t0, 1         # shift Remainder
    
    li $t2, 0x80000000		# 0b1000...0
    and $t3, $a1, $t2       # check hi MSB
    sll $a1, $a1, 1         # shift hi
    and $t4, $a0, $t2       # check lo MSB
    sll $a0, $a0, 1         # shift lo
    beqz $t4, no_carry
    ori $a1, $a1, 1         # carry lo -> hi
no_carry:
    beqz $t3, no_rem_add
    ori $t0, $t0, 1         # carry hi -> Remainder
no_rem_add:		# check div
    blt $t0, 10, next_iter
    sub $t0, $t0, 10
    ori $a0, $a0, 1         # set quotient bit

next_iter:
    sub $t1, $t1, 1			# decrement
    bnez $t1, mod_loop_inner

    addi $sp, $sp, -4      # PUSH Remainder
    sw $t0, 0($sp)          
    
    move $v0, $a0		   # return new quotients (LO and HI)
    move $v1, $a1
    
    jr $ra