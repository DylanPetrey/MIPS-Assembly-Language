#Michael Petrey
#mdp180000

.data
	#variables
	zipcode:	.space	5
	int_digits_sum:	.word	0
	rec_digits_sum:	.word	0
	
	#prompt strings
	inputPrompt:	.asciiz	"\nGive me your zip code (0 to stop): "
	outputMsg:	.asciiz	"\nThe sum of all digits in your zip code is"
	iterativeMsg:	.asciiz "\nITERATIVE:"
	recursiveMsg:	.asciiz	"\nRECURSIVE:"
	
	
	
.text
	main:
	
		while:
			#output prompt for the user
			li $v0, 4		#load string to be printed
			la $a0, inputPrompt	#load prompt
			syscall			#outputs string
		
			#input zipcode
			li $v0, 5		#load string to be read
			syscall 		#read input
			sw  $v0, zipcode	#store input value
			
			lw $t0, zipcode		#load zipcode
			beq $t0, 0, exit
			
			jal getIterative	#function to get sum of digits iterativly
			
			jal getRecursive	#function to get sum of digits recursively 
			
			jal finalOutput		#final output
			
			j while			#restart while loop
			
		exit:
			#syscall to end program
			li $v0 10
			syscall	
			
			
	finalOutput:
			#output prompt for the user
			li $v0, 4		#load string to be printed
			la $a0, outputMsg	#load prompt
			syscall			#outputs string
			
			#output prompt for the user
			li $v0, 4		#load string to be printed
			la $a0, iterativeMsg	#load prompt
			syscall			#outputs string
			
			#output prompt for the user
			li $v0, 1		#load string to be printed
			lb $a0, int_digits_sum	#load prompt
			syscall			#outputs string
			
			#output prompt for the user
			li $v0, 4		#load string to be printed
			la $a0, recursiveMsg	#load prompt
			syscall			#outputs string
			
			#output prompt for the user
			li $v0, 1		#load string to be printed
			lb $a0, rec_digits_sum	#load prompt
			syscall			#outputs string
			
			#jump out of function
			jr $ra
			
	getIterative:
		li $s1, 0		#load empty register for sum
		lw $s2,	zipcode		#load zipcode into register
		li $s3, 10000		#digit iterator
		for:
			ble $s3, 0, endFor	#end for loop
			
			div $s2, $s3 		#get first digit of zip
			mfhi $t0		#mod zipcode result
			mflo $t1		#get first digit
			addu $s1, $t1, $s1	#add to total sum
			move $s2, $t0		#new zipcode
			div $s3, $s3, 10	#decrease mod register
			
			j for			#restart for loop
			
		endFor:
			sw $s1, int_digits_sum	#store sum
			
			#jump out of function
			jr $ra
				
	getRecursive:
		lw $t0, zipcode		#load zipcode into register
		addi $t1,$zero, 10	#mod register
		add $t4,$zero,$zero	#sum register
		
		recursiveLoop:
			div $t0, $t1		#divide and mod zipcode
			mfhi $t3		#rightmost Digit
			mflo $t0		#remainder digits
			add $t4, $t4, $t3	#add total of digits
			bne $t0, $zero, recursiveLoop	#resets the loop
			
		endRecursive:
			sw $t4, rec_digits_sum	#store recursive sum
			
			#jump out of function
			jr $ra
			