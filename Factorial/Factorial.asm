# 	File:		Factorial
# 	Name:		Jeffrey Salinas
#	Date: 		12/16/2025

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
		
		blez $s0, error # if (num > 0)
		
		li $s2, 1
for:
		bgt $s2, $s0, endfor	# if (i <= num)
		mul $s1, $s1, $s2		# 	factorial *= i
		addi $s2, $s2, 1		#	i++
		j for
endfor:

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
		
		move $a0, $s1			# print factorial
		li $v0, 1
		syscall
		
		la $t0, endl
		move $a0, $t0
		li $v0, 4
		syscall
		
		li $v0, 10
		syscall
		
		
error:	
		la $t1, endl
		move $a0, $t1
		li $v0,4
		syscall
		la $t1, error_integer
		move $a0, $t1
		li $v0, 4
		syscall