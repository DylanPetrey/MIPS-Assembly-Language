.data
	#each column in the game
	#3 columns, 6 rows
	columnLEFT:	.byte	'.', '.', '.', '.', '.', '.'	#left column of game
	columnCENTER:	.byte	'.', '.', '.', '.', '.', '.'	#center column of game
	columnRIGHT:	.byte	'.', '.', '.', '.', '.', '.'	#right column of game
	
	#chars for array
	emptySpace:	.byte	' '				#for formatting
	userChip:	.byte 	'X'
	computerChip:	.byte	'O'
	emptyChip:	.byte	'.'
	
	newline:		.asciiz	"\n"				#for formatting
	columnPrompt:   	.asciiz "\nEnter a column: "
	errorPrompt: 		.asciiz "\nInvalid Input. Try again"
	fullPrompt:		.asciiz	"\nColumn is full. Try again"
	computerWinPrompt:	.asciiz "\nThe computer has won"
	userWinPrompt:		.asciiz "\nThe user has won"
	tieWinPrompt:		.asciiz "\nThe game has tied"
	
	userInput:	.space	1				#variable for input value of 1 character
	columnInput:	.word	0				#int for column
	
	numLeft:	.word	0
	numCenter:	.word	0
	numRight:	.word	0
	
	
	
.globl main
.text	
	main:
		while: 

			# Might want to check if win here			
			jal checkWin

			# Display the array first
			jal printGame
		
			jal validInput
			
			#print a newline
			li $v0, 4
			la $a0, newline
			syscall
			
			#load user input
			lw $v0, columnInput
			
			# Load the numbers in to compare with user input
			li $t1, 1
			li $t2, 2
			li $t3, 3
			
			# Compare it with the column numbers and put a chip in
			beq $v0, $t1, addColumnLeftUser
			beq $v0, $t2, addColumnCenterUser
			beq $v0, $t3, addColumnRightUser
			
			
			
			computerTurn:

			# Might want to check if win here
			jal checkWin
			# Generate a random number between 0 and 2
			addi $a1, $zero, 3
			addi $v0, $zero, 42
			syscall
			
			# Add one to it to get the column number
			move $v0, $a0
			addi $v0, $v0, 1
			
			# Load the numbers in to compare with computer generated number
			li $t1, 1
			li $t2, 2
			li $t3, 3
			
			# Compare it with the column numbers and put a chip in
			beq $v0, $t1, addColumnLeftComputer
			beq $v0, $t2, addColumnCenterComputer
			beq $v0, $t3, addColumnRightComputer
			
	
		
		exitMainUserWin:
		jal printGame			# Print the Board

		# The the user who won
		li $v0, 4
		la $a0, userWinPrompt
		syscall
		#syscall to end program
		li $v0 10
		syscall	
		
		exitMainComputerWin:
		jal printGame			# Print the Board

		# The the user who won
		li $v0, 4
		la $a0, computerWinPrompt
		syscall
		#syscall to end program
		li $v0 10
		syscall	
		
		exitMainTie:
		jal printGame			# Print the Board

		# The the user who won
		li $v0, 4
		la $a0, tieWinPrompt
		syscall
		#syscall to end program
		li $v0 10
		syscall	
		
		exitMain:
		#syscall to end program
		li $v0 10
		syscall	
	
	######################################################################################################################
	
	#function that prints the current game
	printGame:
		addi $t0, $zero, 5			#set t0 to 5(last index of array)
		
		whileInArray:
			blt  $t0, 0, exitArray		#branch if index is before beginning of array
			
			#print current index of column3 array
			li $v0, 11
			lb $a0, columnLEFT($t0)
			syscall
			
			#print space between columns
			li $v0, 11
			lb $a0, emptySpace
			syscall
			
			#print current index of column2 array
			li $v0, 11
			lb $a0, columnCENTER($t0)	
			syscall
			
			#print space between columns
			li $v0, 11
			lb $a0, emptySpace
			syscall
			
			#print current index of column3 array
			li $v0, 11
			lb $a0, columnRIGHT($t0)		
			syscall
			
			subi $t0, $t0, 1		#decreases index by 1 byte
			
			#print a newline
			li $v0, 4
			la $a0, newline
			syscall
			
			j whileInArray	
		exitArray:	
			jr $ra			#return to main	
			
	######################################################################################################################
			
	addColumnLeftUser:
		
		lb $t7, userChip
		lb $t5, emptyChip
		li $t0, 0			#set t0 to 5(last index of array)
		la $t2, columnLEFT
		lb $t4, 0($t2)			# Load base address of column left into $t4
		
		whileGoThroughLeftUser:
			
			bgt $t0, 5, exitWhileGoThroughLeftUser

			# If the current place is empty, then move to the exit
			seq $t1, $t5, $t4			# Compares the current index to the empty chip
			add $s0, $t2, $zero			# 
			bgt $t1, $zero, exitWhileGoThroughLeftUser
			
			addi $t2, $t2, 1
			addi $t0, $t0, 1
			
			lb $t4, ($t2)		# Load base address of column left into $t4
			
			j whileGoThroughLeftUser
			
		exitWhileGoThroughLeftUser:
		
			sb $t7, 0($s0)
			lw $s3, numLeft
			addi $s3, $s3, 1
			sw $s3,numLeft
			j computerTurn
		
	######################################################################################################################
	
	addColumnCenterUser:
		
		lb $t7, userChip
		lb $t5, emptyChip
		li $t0, 0			#set t0 to 5(last index of array)
		la $t2, columnCENTER
		lb $t4, 0($t2)			# Load base address of column left into $t4
		
		whileGoThroughCenterUser:
			# At the end of the array
			bgt $t0, 5, exitWhileGoThroughCenterUser

			# If the current place is empty, then move to the exit
			seq $t1, $t5, $t4			# Compares the current index to the empty chip
			add $s0, $t2, $zero			# 
			bgt $t1, $zero, exitWhileGoThroughCenterUser
			
			addi $t2, $t2, 1
			addi $t0, $t0, 1
			
			lb $t4, ($t2)		# Load base address of column left into $t4
			
			j whileGoThroughCenterUser
			
		exitWhileGoThroughCenterUser:
		
			sb $t7, 0($s0)
			lw $s3, numCenter
			addi $s3, $s3, 1
			sw $s3, numCenter
			j computerTurn
			
	######################################################################################################################
	
	addColumnRightUser:
		
		lb $t7, userChip
		lb $t5, emptyChip
		li $t0, 0			#set t0 to 5(last index of array)
		la $t2, columnRIGHT
		lb $t4, 0($t2)			# Load base address of column left into $t4
		
		whileGoThroughRightUser:
			
			bgt $t0, 5, exitWhileGoThroughRightUser

			# If the current place is empty, then move to the exit
			seq $t1, $t5, $t4			# Compares the current index to the empty chip
			add $s0, $t2, $zero			# 
			bgt $t1, $zero, exitWhileGoThroughRightUser
			
			addi $t2, $t2, 1
			addi $t0, $t0, 1
			
			lb $t4, ($t2)		# Load base address of column left into $t4
			
			j whileGoThroughRightUser
			
		exitWhileGoThroughRightUser:
		
			sb $t7, 0($s0)
			lw $s3, numRight
			addi $s3, $s3, 1
			sw $s3,numRight
			j computerTurn
			
			
	######################################################################################################################
	
	#gets valid input
	validInput:
		# Prompt the user for input
		li $v0, 4
		la $a0, columnPrompt
		syscall
	
		# Get the desired user choice
		li $v0, 8
		la $a0, userInput	#load userInput
		li $a1, 2
		move $t0, $a0
		syscall	
		
		
		lb $t1, 0($t0)		#load char
		
		#check ascii values of char
		beq $t1, 49, valid1	#checks if char is '1' 
		beq $t1, 50, valid2	#checks if char is '2'
		beq $t1, 51, valid3	#checks if char is '3'
		beq $t1, 10, exitMain	#enter exits the game
		
		# error input msg
		li $v0, 4
		la $a0, errorPrompt
		syscall
			
		j validInput		#jump to beginning of the loop
		
		valid1:			#input var to column 1
			li $t2, 1
			sw $t2, columnInput
			jr $ra
		valid2:			#input var to column 2
			li $t2, 2
			sw $t2, columnInput
			jr $ra
		valid3:			#input var to column 3
			li $t2, 3
			sw $t2, columnInput
			jr $ra
	
	######################################################################################################################
			
	addColumnLeftComputer:
		
		lb $t7, computerChip
		lb $t5, emptyChip
		li $t0, 0			#set t0 to 5(last index of array)
		la $t2, columnLEFT
		lb $t4, 0($t2)			# Load base address of column left into $t4
		lw $s3, numLeft
		
		whileGoThroughLeftComputer:
			
			bgt $s3, 5, computerTurn
			bgt $t0, 5, exitWhileGoThroughLeftComputer

			# If the current place is empty, then move to the exit
			seq $t1, $t5, $t4			# Compares the current index to the empty chip
			add $s0, $t2, $zero			# 
			bgt $t1, $zero, exitWhileGoThroughLeftComputer
			
			addi $t2, $t2, 1
			addi $t0, $t0, 1
			
			lb $t4, ($t2)		# Load base address of column left into $t4
			
			j whileGoThroughLeftComputer
			
		exitWhileGoThroughLeftComputer:
		
			sb $t7, 0($s0)
			lw $s3, numLeft
			addi $s3, $s3, 1
			sw $s3,numLeft
			
			beq $s3, 6, checkTie
			
			j while

	######################################################################################################################
	
	addColumnCenterComputer:
		
		lb $t7, computerChip
		lb $t5, emptyChip
		li $t0, 0			#set t0 to 5(last index of array)
		la $t2, columnCENTER
		lb $t4, 0($t2)			# Load base address of column left into $t4
		lw $s3, numCenter
		
		whileGoThroughCenterComputer:

			bgt $s3, 5, computerTurn
			# At the end of the array
			bgt $t0, 5, exitWhileGoThroughCenterComputer

			# If the current place is empty, then move to the exit
			seq $t1, $t5, $t4			# Compares the current index to the empty chip
			add $s0, $t2, $zero			# 
			bgt $t1, $zero, exitWhileGoThroughCenterComputer
			
			addi $t2, $t2, 1
			addi $t0, $t0, 1
			
			lb $t4, ($t2)		# Load base address of column left into $t4
			
			j whileGoThroughCenterComputer
			
		exitWhileGoThroughCenterComputer:
		
			sb $t7, 0($s0)
			lw $s3, numCenter
			addi $s3, $s3, 1
			sw $s3, numCenter
			
			beq $s3, 6, checkTie
			
			j while
			
	######################################################################################################################
	
	addColumnRightComputer:
		
		lb $t7, computerChip
		lb $t5, emptyChip
		li $t0, 0			#set t0 to 5(last index of array)
		la $t2, columnRIGHT
		lb $t4, 0($t2)			# Load base address of column left into $t4
		lw $s3, numRight
		
		whileGoThroughRightComputer:
			
			bgt $s3, 5, computerTurn
			bgt $t0, 5, exitWhileGoThroughRightComputer

			# If the current place is empty, then move to the exit
			seq $t1, $t5, $t4			# Compares the current index to the empty chip
			add $s0, $t2, $zero			# 
			bgt $t1, $zero, exitWhileGoThroughRightComputer
			
			addi $t2, $t2, 1
			addi $t0, $t0, 1
			
			lb $t4, ($t2)		# Load base address of column left into $t4
			
			j whileGoThroughRightComputer
			
		exitWhileGoThroughRightComputer:
		
			sb $t7, 0($s0)
			lw $s3, numRight
			addi $s3, $s3, 1
			sw $s3,numRight
			
			beq $s3, 6, checkTie
			
			j while
			
	######################################################################################################################
	
	checkWin:
		
		lb $t8, computerChip
		lb $t1, userChip
		li $t0, 0			#set t0 to 0(first index of array)
		la $t2, columnLEFT
		la $t3, columnCENTER
		la $t4, columnRIGHT
		lb $t5, 0($t2)
		lb $t6, 0($t3)
		lb $t7, 0($t4)
		
	
		whileCheckHorizontal:
			
			bgt $t0, 5, checkVertical
			
			# Check for the horizontal win for user
			seq $s0, $t5, $t1		# Check if the user chip is at the first spot
			seq $s1, $t5, $t6		# Check if the one at the center matches the one next to it
			seq $s2, $t6, $t7		# Check if the one on the right matches the on in the center
			
			# See if it all matches
			and $t9, $s0, $s1
			and $t9, $t9, $s2
			
			beq $t9, 1, exitMainUserWin		# If it all matches the branch to user win
			
			# Check for the horizontal win for computer
			seq $s0, $t5, $t8		# Check if the computer chip is at the first spot
			seq $s1, $t5, $t6		# Check if the one at the center matches the one next to it
			seq $s2, $t6, $t7		# Check if the one on the right matches the on in the center
			
			# See if it all matches
			and $t9, $s0, $s1
			and $t9, $t9, $s2
			
			beq $t9, 1, exitMainComputerWin	# If it all matches the branch to computer win
			
			# Increment everything by 1
			addi $t2, $t2, 1
			addi $t3, $t3, 1
			addi $t4, $t4, 1
			addi $t0, $t0, 1
			
			lb $t5, ($t2)		# Load base address of column left into $t5
			lb $t6, ($t3)		# Load base address of column left into $t6
			lb $t7, ($t4)		# Load base address of column left into $t7
			
			j whileCheckHorizontal
			
			
			
		#####################################################################################################################
			
		checkVertical:
		
			lb $t8, computerChip
			lb $t1, userChip
			li $t0, 2			#set t0 to 0(first index of array)
			la $t2, columnLEFT
			la $t3, columnLEFT
			la $t4, columnLEFT
			
			
			addi $t2, $t2, 2
			addi $t3, $t3, 1
		
			lb $t5, 0($t2)
			lb $t6, 0($t3)
			lb $t7, 0($t4)
			
				whileCheckVerticalLeft:
				
					bgt $t0, 5, checkVerticalCenter
					
					# Check for the horizontal win for user
					seq $s0, $t5, $t1		# Check if the user chip is at the first spot
					seq $s1, $t5, $t6		# Check if the one at the center matches the one next to it
					seq $s2, $t6, $t7		# Check if the one on the right matches the on in the center
			
					# See if it all matches
					and $t9, $s0, $s1
					and $t9, $t9, $s2
		
					beq $t9, 1, exitMainUserWin		# If it all matches the branch to user win					
					
					# Check for the horizontal win for computer
					seq $s0, $t5, $t8		# Check if the computer chip is at the first spot
					seq $s1, $t5, $t6		# Check if the one at the center matches the one next to it
					seq $s2, $t6, $t7		# Check if the one on the right matches the on in the center
			
					# See if it all matches
					and $t9, $s0, $s1
					and $t9, $t9, $s2
			
					beq $t9, 1, exitMainComputerWin	# If it all matches the branch to computer win
			
					# Increment everything by 1
					addi $t2, $t2, 1
					addi $t3, $t3, 1
					addi $t4, $t4, 1
					addi $t0, $t0, 1
			
					lb $t5, ($t2)		# Load base address of column left into $t5
					lb $t6, ($t3)		# Load base address of column left into $t6
					lb $t7, ($t4)		# Load base address of column left into $t7
					
					j whileCheckVerticalLeft
					
				checkVerticalCenter:
				
				
				lb $t8, computerChip
				lb $t1, userChip
				li $t0, 2			#set t0 to 0(first index of array)
				la $t2, columnCENTER
				la $t3, columnCENTER
				la $t4, columnCENTER
				
				addi $t2, $t2, 2
				addi $t3, $t3, 1
	
				lb $t5, 0($t2)
				lb $t6, 0($t3)
				lb $t7, 0($t4)
				
				
			
					whileCheckVerticalCenter:
				
					bgt $t0, 5, checkVerticalRight
					
					# Check for the horizontal win for user
					seq $s0, $t5, $t1		# Check if the user chip is at the first spot
					seq $s1, $t5, $t6		# Check if the one at the center matches the one next to it
					seq $s2, $t6, $t7		# Check if the one on the right matches the on in the center
			
					# See if it all matches
					and $t9, $s0, $s1
					and $t9, $t9, $s2
		
					beq $t9, 1, exitMainUserWin		# If it all matches the branch to user win					
					
					# Check for the horizontal win for computer
					seq $s0, $t5, $t8		# Check if the computer chip is at the first spot
					seq $s1, $t5, $t6		# Check if the one at the center matches the one next to it
					seq $s2, $t6, $t7		# Check if the one on the right matches the on in the center
			
					# See if it all matches
					and $t9, $s0, $s1
					and $t9, $t9, $s2
			
					beq $t9, 1, exitMainComputerWin	# If it all matches the branch to computer win
			
					# Increment everything by 1
					addi $t2, $t2, 1
					addi $t3, $t3, 1
					addi $t4, $t4, 1
					addi $t0, $t0, 1
			
					lb $t5, ($t2)		# Load base address of column left into $t5
					lb $t6, ($t3)		# Load base address of column left into $t6
					lb $t7, ($t4)		# Load base address of column left into $t7
					
					j whileCheckVerticalCenter
					
				checkVerticalRight:
				
				lb $t8, computerChip
				lb $t1, userChip
				li $t0, 2			#set t0 to 0(first index of array)
				la $t2, columnRIGHT
				la $t3, columnRIGHT
				la $t4, columnRIGHT
				
				addi $t2, $t2, 2
				addi $t3, $t3, 1
	
				lb $t5, 0($t2)
				lb $t6, 0($t3)
				lb $t7, 0($t4)
				
				
			
					whileCheckVerticalRight:
				
					bgt $t0, 5, checkDiagonal
					
					# Check for the horizontal win for user
					seq $s0, $t5, $t1		# Check if the user chip is at the first spot
					seq $s1, $t5, $t6		# Check if the one at the center matches the one next to it
					seq $s2, $t6, $t7		# Check if the one on the right matches the on in the center
			
					# See if it all matches
					and $t9, $s0, $s1
					and $t9, $t9, $s2
		
					beq $t9, 1, exitMainUserWin		# If it all matches the branch to user win					
					
					# Check for the horizontal win for computer
					seq $s0, $t5, $t8		# Check if the computer chip is at the first spot
					seq $s1, $t5, $t6		# Check if the one at the center matches the one next to it
					seq $s2, $t6, $t7		# Check if the one on the right matches the on in the center
			
					# See if it all matches
					and $t9, $s0, $s1
					and $t9, $t9, $s2
			
					beq $t9, 1, exitMainComputerWin	# If it all matches the branch to computer win
			
					# Increment everything by 1
					addi $t2, $t2, 1
					addi $t3, $t3, 1
					addi $t4, $t4, 1
					addi $t0, $t0, 1
			
					lb $t5, ($t2)		# Load base address of column left into $t5
					lb $t6, ($t3)		# Load base address of column left into $t6
					lb $t7, ($t4)		# Load base address of column left into $t7
					
					j whileCheckVerticalRight
					
		#####################################################################################################################

		checkDiagonal:

		lb $t8, computerChip
		lb $t1, userChip
		li $t0, 2			#set t0 to 0(first index of array)
		la $t2, columnLEFT
		la $t3, columnCENTER
		la $t4, columnRIGHT

		addi $t2, $t2, 2
		addi $t3, $t3, 1

		lb $t5, 0($t2)
		lb $t6, 0($t3)
		lb $t7, 0($t4)

			whileCheckDiagonalLeft:

				bgt $t0, 5, checkDiagonalRight
					
				# Check for the horizontal win for user
				seq $s0, $t5, $t1		# Check if the user chip is at the first spot
				seq $s1, $t5, $t6		# Check if the one at the center matches the one next to it
				seq $s2, $t6, $t7		# Check if the one on the right matches the on in the center
		
				# See if it all matches
				and $t9, $s0, $s1
				and $t9, $t9, $s2
	
				beq $t9, 1, exitMainUserWin		# If it all matches the branch to user win					
				
				# Check for the horizontal win for computer
				seq $s0, $t5, $t8		# Check if the computer chip is at the first spot
				seq $s1, $t5, $t6		# Check if the one at the center matches the one next to it
				seq $s2, $t6, $t7		# Check if the one on the right matches the on in the center
		
				# See if it all matches
				and $t9, $s0, $s1
				and $t9, $t9, $s2
		
				beq $t9, 1, exitMainComputerWin	# If it all matches the branch to computer win
		
				# Increment everything by 1
				addi $t2, $t2, 1
				addi $t3, $t3, 1
				addi $t4, $t4, 1
				addi $t0, $t0, 1
		
				lb $t5, ($t2)		# Load base address of column left into $t5
				lb $t6, ($t3)		# Load base address of column left into $t6
				lb $t7, ($t4)		# Load base address of column left into $t7
				
				j whileCheckDiagonalLeft


			checkDiagonalRight:

				lb $t8, computerChip
				lb $t1, userChip
				li $t0, 2			#set t0 to 0(first index of array)
				la $t2, columnRIGHT
				la $t3, columnCENTER
				la $t4, columnLEFT

				addi $t2, $t2, 2
				addi $t3, $t3, 1

				lb $t5, 0($t2)
				lb $t6, 0($t3)
				lb $t7, 0($t4)

					whileCheckDiagonalRight:

					bgt $t0, 5, exitCheck
					
					# Check for the horizontal win for user
					seq $s0, $t5, $t1		# Check if the user chip is at the first spot
					seq $s1, $t5, $t6		# Check if the one at the center matches the one next to it
					seq $s2, $t6, $t7		# Check if the one on the right matches the on in the center

					# See if it all matches
					and $t9, $s0, $s1
					and $t9, $t9, $s2

					beq $t9, 1, exitMainUserWin		# If it all matches the branch to user win					

					# Check for the horizontal win for computer
					seq $s0, $t5, $t8		# Check if the computer chip is at the first spot
					seq $s1, $t5, $t6		# Check if the one at the center matches the one next to it
					seq $s2, $t6, $t7		# Check if the one on the right matches the on in the center

					# See if it all matches
					and $t9, $s0, $s1
					and $t9, $t9, $s2

					beq $t9, 1, exitMainComputerWin	# If it all matches the branch to computer win

					# Increment everything by 1
					addi $t2, $t2, 1
					addi $t3, $t3, 1
					addi $t4, $t4, 1
					addi $t0, $t0, 1

					lb $t5, ($t2)		# Load base address of column left into $t5
					lb $t6, ($t3)		# Load base address of column left into $t6
					lb $t7, ($t4)		# Load base address of column left into $t7

					j whileCheckDiagonalRight
		
		checkTie:
			lw $s3, numLeft
			lw $s4, numCenter
			lw $s5, numRight
			
			seq $s0, $s3, 6		# Check if the user chip is at the first spot
			seq $s1, $s4, 6		# Check if the one at the center matches the one next to it
			seq $s2, $s5, 6		# Check if the one on the right matches the on in the center
		
			# See if it all matches
			and $t9, $s0, $s1
			and $t9, $t9, $s2
			
			beq $t9, 1, exitMainTie
			
			j while

		exitCheck:
			jr $ra
