#Michael Petrey
#mdp180000

	.data
x:	.word 0		#Variable for x value
y:	.word 0		#Variable for y value
s:	.word 0		#Variable for sum

prompt1:	.asciiz "x: "					#ask for x string
prompt2:	.asciiz "y: "					#ask for y string
prompt3:	.asciiz "The sum of X and Y (X + Y) is "	#show sum string

	.text 
	.globl main
main:					#main
	li	$v0, 4			#load string to be printed
	la	$a0, prompt1		#load prompt
	syscall				#outputs string
	
	li	$v0, 5			#load int to be read
	syscall 			#read input
	sw 	$v0, x			#write input to x
	
	li	$v0, 4			#load string to be printed
	la	$a0, prompt2		#load prompt
	syscall				#output prompt
	
	li	$v0, 5			#load int to be read
	syscall 			#read input
	sw 	$v0, y			#write input to y
	
	lw	$t0, x			#load x to temp var
	lw	$t1, y			#load y to temp var
	lw	$t2, s			#load s to temp var
	add 	$t2, $t0, $t1		#add x and y
	
	sw	$t2, s			#write result to s
	
	li	$v0, 4			#load string to be printed
	la	$a0, prompt3		#load string
	syscall				#output
	
	li	$v0, 1			#load int
	move	$a0, $t2		
	
	
	syscall				#print int
	
