# 	Project: 	Final-Project
# 	Name:		Jeffrey Salinas
# 	Date: 		12/11/25
#
	.data
x:	.word	0:4	# x-coordinates of 4 robots
y:	.word	0:4	# y-coordinates of 4 robots

str1:	.asciiz	"Your coordinates: 25 25\n"
str2:	.asciiz	"Enter move (1 for +x, -1 for -x, 2 for + y, -2 for -y):"
str3:	.asciiz	"Your coordinates: "
sp:	.asciiz	" "
endl:	.asciiz	"\n"
str4:	.asciiz	"Robot at "
str5:	.asciiz	"AAAARRRRGHHHHH... Game over\n"

# i			$s0
# myX			$s1
# myY			$s2
# move				$s3
# status			$s4
# temp				$s5
# pointers			$s6
	.text
#	.globl	inc
#	.globl	getNew

main:	
	li	$s1,25		#  myX = 25
	li	$s2,25		#  myY = 25
	li	$s4,1		#  status = 1

	la	$s5,x
	la	$s6,y

	sw	$0,($s5)	#  x[0] = 0; y[0] = 0;
	sw	$0,($s6)
	sw	$0,4($s5)	#  x[1] = 0; y[1] = 50;
	li	$s7,50
	sw	$s7,4($s6)
	sw	$s7,8($s5)	#  x[2] = 50; y[2] = 0;
	sw	$0,8($s6)
	sw	$s7,12($s5)	#  x[3] = 50; y[3] = 50;
	sw	$s7,12($s6)

	la	$a0,str1	#  cout << "Your coordinates: 25 25\n";
	li	$v0,4
	syscall

	bne	$s4,1,main_exitw	#  while (status == 1) {
main_while:
	la	$a0,str2			#    cout << "Enter move (1 for +x,
	li	$v0,4				#	-1 for -x, 2 for + y, -2 for -y):";
	syscall

	li	$v0,5				#    cin >> move;
	syscall
	move	$s3,$v0

	bne	$s3,1,main_else1	#    if (move == 1)
	add	$s1,$s1,1			#      myX++;
	b	main_exitif
main_else1:
	bne	$s3,-1,main_else2	#    else if (move == -1)
	add	$s1,$s1,-1			#      myX--;
	b	main_exitif
main_else2:
	bne	$s3,2,main_else3	#    else if (move == 2)
	add	$s2,$s2,1			#      myY++;
	b	main_exitif
main_else3:	
	bne	$s3,-2,main_exitif	#    else if (move == -2)
	add	$s2,$s2,-1			#      myY--;

main_exitif:	
	la	$a0,x				#    status = moveRobots(&x[0],&y[0],myX,myY);
	la	$a1,y
	move	$a2,$s1
	move	$a3,$s2
	jal	moveRobots
	move	$s4,$v0

	la	$a0,str3	#    cout << "Your coordinates: " << myX
	li	$v0,4		#      << " " << myY << endl;
	syscall
	move	$a0,$s1
	li	$v0,1
	syscall
	la	$a0,sp
	li	$v0,4
	syscall
	move	$a0,$s2
	li	$v0,1
	syscall
	la	$a0,endl
	li	$v0,4
	syscall

	la	$s5,x
	la	$s6,y
	li	$s0,0		#    for (i=0;i<4;i++)
main_for:	
	la	$a0,str4	#      cout << "Robot at " << x[i] << " "
	li	$v0,4		#           << y[i] << endl;
	syscall
	lw	$a0,($s5)
	li	$v0,1
	syscall
	la	$a0,sp
	li	$v0,4
	syscall
	lw	$a0,($s6)
	li	$v0,1
	syscall
	la	$a0,endl
	li	$v0,4
	syscall
	add	$s5,$s5,4
	add	$s6,$s6,4
	add	$s0,$s0,1
	blt	$s0,4,main_for

	beq	$s4,1,main_while
				#  }
main_exitw:	
	la	$a0,str5	#  cout << "AAAARRRRGHHHHH... Game over\n";
	li	$v0,4
	syscall
	li	$v0,10		#}
	syscall

	#
	#	int moveRobots(int *arg0, int *arg1, int arg2, int arg3)
	#
	#	arg0		base address of array of x-coordinates
	#	arg1		base address of array of y-coordinates
	#	arg2		x-coordinate of human (copy in $s2)
	#	arg3		y-coordinate of human (copy in $s3)
	#	ptrX		$s0
	#	ptrY		$s1
	#
	#	i			$s2
	#	alive		$s3
	#	temp		$t1
	#
	#	*ptrX		$s4		value
	#	*ptrY		$s5		value
	#
	#	moveRobots() calls getNew() to obtain the new coordinates
	#	of each robot. The position of each robot is updated.

moveRobots:
	addi $sp, $sp, -28		# push $ra and $s0-$s5 to stack
	sw $ra, 24($sp)
	sw $s0, 20($sp)
	sw $s1, 16($sp)
	sw $s2, 12($sp)
	sw $s3, 8($sp)
	sw $s4, 4($sp)
	sw $s5, 0($sp)
	
	li $s3, 1		 	 	#  alive = 1;

	move $s0, $a0			#  ptrX = arg0;
	move $s1, $a1			#  ptrY = arg1;

	li $s2, 0				# i;
	
move_for:			#  for (i=0;i<4;i++) {
	bge $s2, 4, move_exitfor
			     	    
	lw $a0, 0($s0)			#  *ptrX = getNew(*ptrX,arg2); input we use $a0,$a1
	move  $a1, $a2
	jal getNew
	move $s4, $v0		
	sw $s4, 0($s0)
		   	      		
	lw $a0, 0($s1)			#  *ptrY = getNew(*ptrY,arg3);
	move $a1, $a3
	jal getNew
	move $s5, $v0		
	sw $s5, 0($s1)		
	
	addi $s2, $s2, 1		# i++  }


	bne $s4, $a2, move_exitif  	# if ((*ptrX == arg2) && (*ptrY == arg3)) {
	bne $s5, $a3, move_exitif
move_if:
	li $s3, 0					# alive = 0;
	j move_exitfor				# break;
																													
move_exitif:	
	addi $s0, $s0, 4			# ptrX++;
	addi $s1, $s1, 4			# ptrY++;   	
	j move_for      			   	     
			   	      			   	      			   	     			   	      
move_exitfor:			   	     			   	      			   	     			   	      			   	      	
	move $v0, $s3   			# return alive;	
		   	     			   	 			   	      			   	      			   	      	   	     			   	 			   	      			   	      			   	      
	lw $s5, 0($sp)				# pop $ra and $s0-$s5
	lw $s4, 4($sp)
	lw $s3, 8($sp)
	lw $s2, 12($sp)
	lw $s1, 16($sp)
	lw $s0, 20($sp)
	lw $ra, 24($sp)
	addi $sp, $sp, 28
	
	jr $ra
	
	#
	#	int getNew(int arg0, int arg1)
	#
	#	arg0		one coordinate of robot
	#	arg1		one coordinate of human
	#	temp		$t0
	#	result		$t1
	#
	#	Returns new coordinate of robot. If the absolute difference between
	#	the robot coordinate and human coordinate is >=10, the robot
	#	coordinate moves 10 units closer to the human coordinate.
	#	If the absolute difference is < 10, the robot coordinate
	#	moves 1 unit closer to the human coordinate.

getNew:		
	sub $t0, $a0, $a1				# temp = arg0 - arg1

	bge $t0, 10, getNew_if1			# if (temp >= 10)
	bgtz $t0, getNew_if2			# else if (temp > 0)
	beqz $t0, getNew_if3			# else if (temp == 0)
	bgt $t0, -10, getNew_if4 		# else if (temp > -10)
	ble $t0, -10, getNew_if5		# else if (temp <= -10)
									
getNew_if1:
	addi $t1, $a0, -10			# result = arg0 - 10;
	j getNew_endif
getNew_if2:
	addi $t1, $a0, -1			# result = arg0 - 1;
	j getNew_endif
getNew_if3:	
	move $t1, $a0				# result = arg0;
	j getNew_endif
getNew_if4:
	addi $t1, $a0, 1			# result = arg0 + 1;
	j getNew_endif
getNew_if5:
	addi $t1, $a0, 10			# result = arg0 + 10;
getNew_endif:
 	move $v0, $t1			 	# return result
 	jr $ra


								
