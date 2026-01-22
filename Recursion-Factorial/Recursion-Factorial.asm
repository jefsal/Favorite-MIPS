# 	File: 		Recursion-Factorial
# 	Name:		Jeffrey Salinas
# 	Date: 		12/15/25
#

		
	.data
error_integer: .asciiz "Error: A negative integer does not have a factorial."
str1:			.asciiz "Enter a positive integer: "
endl: 			.asciiz	"\n"
str2: 			.asciiz "Factorial of "
equals:			.asciiz " = "

	.text
		
main:
#	num 	$s0
# 	factorial $s1
#	i			$s2

		li $s0, 0		# init
		li $s1, 1
		
		la $t0, str1	# "Enter a positive integer: "
		move $a0, $t0
		li $v0, 4
		syscall
		
		li $v0, 5		# num = user input
		syscall
		move $s0, $v0
	
		la $t0, str2			# "Factorial of " num " = " factorial "\n"
		move $a0, $t0
		li $v0, 4
		syscall
		
		move $a0, $s0			# num
		li $v0, 1
		syscall
		
		la $t0, equals			# " = "
		move $a0, $t0
		li $v0, 4
		syscall
		
		move $a0, $s0			# Factorial(num)
		jal Factorial				
		move $s1, $v0
		
		move $a0, $s1			# print factorial
		li $v0, 1
		syscall
		
		
		la $t0, endl
		move $a0, $t0
		li $v0, 4
		syscall
		
		li $v0, 10
		syscall
		
Factorial:
# num	$a0
# n		$s0
# 1		$t0
		addi $sp, $sp, -8		# push $ra, $s0 to the stack
		sw $ra, 4($sp)
		sw $s0, 0($sp)
		
		li $t0, 1
		ble $a0, $t0, Factorial_end
		
		move $s0, $a0			# n = num
		addi $a0, $a0, -1		# num--
		
		jal Factorial			# n * Factorial(num)
		mulu $s0, $s0, $v0		
		move $v0, $s0
		
		lw $s0, 0($sp)			# pop $ra, $s0
		lw $ra, 4($sp)
		addi $sp, $sp 8
		
		jr $ra
		
Factorial_end: 
		li $v0, 1
	
		lw $s0, 0($sp)		# pop $ra, $s0
		lw $ra, 4($sp)
		addi $sp, $sp 8
		
		jr $ra
		