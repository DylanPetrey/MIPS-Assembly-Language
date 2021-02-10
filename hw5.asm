#Michael Petrey
#mdp180000


.data
	#vars for input
	roundInput:	.space	4
	squareInput:	.space	4
	goalInput:	.space	4
	
	#vars for calculations
	roundArea:	.float	0
	squareArea:	.float	0
	totalArea:	.float	0
	pizzaSold:	.word	0
	roundPizza:	.float	28.26
	squarePizza:	.word	81
	squareFeet:	.word	144
	
	#output messeges
	inputRoundMsg:	.asciiz	"Round pizzas sold: "
	inputSquareMsg:	.asciiz	"Square pizzas sold: "
	inputGoalMsg:	.asciiz "Goal for the day: "
	roundOutMsg:	.asciiz "Round area sold: "
	squareOutMsg:	.asciiz "Square area sold: "
	totalOutMsg:	.asciiz "Total area sold: "
	goalReachedMsg:	.asciiz "Yeah! "
	goalMissedMsg:	.asciiz	"Too bad! "
	feetUnit:	.asciiz	" ft²\n"
	newline:	.asciiz	"\n"
	

.globl main
.text
	main:
		jal getInputs		#function to get inputs and assign vars
		
		#output newline
		li $v0, 4		#load string to be printed
		la $a0, newline		#load prompt
		syscall			#outputs string
		
		jal getAreas		#function to calculate and assign areas
		
		jal printAreas		#function to test inputs
		
		jal checkGoal		#funtion to print if the goal was met
		
		
		#syscall to end program
		li $v0 10
		syscall	
		
	getInputs:
		#output prompt for the user
		li $v0, 4		#load string to be printed
		la $a0, inputRoundMsg	#load prompt
		syscall			#outputs string
		
		#input round pizzas sold
		li $v0, 5		#load string to be read
		syscall 		#read input
		sw  $v0, roundInput	#store input value
		
		#output prompt for the user
		li $v0, 4		#load string to be printed
		la $a0, inputSquareMsg	#load prompt
		syscall			#outputs string
		
		#input square pizzas sold
		li $v0, 5		#load string to be read
		syscall 		#read input
		sw  $v0, squareInput	#store input value
		
		#output prompt for the user
		li $v0, 4		#load string to be printed
		la $a0, inputGoalMsg	#load prompt
		syscall			#outputs string
		
		li $v0, 5		#load string to be read
		syscall 		#read input
		sw  $v0, goalInput	#store input value
		
		jr $ra			#jump out of function

	printAreas:
		#output prompt for the user
		li $v0, 4		#load string to be printed
		la $a0, roundOutMsg	#load prompt
		syscall			#outputs string
		#output prompt for the user
		li $v0, 2		#load string to be printed
		l.s $f0,roundArea
		mov.s $f12, $f0		# Move contents of register $f1 to register $f12
		syscall			#outputs string
		
		#output newline
		li $v0, 4		#load string to be printed
		la $a0, feetUnit	#load prompt
		syscall			#outputs string
		
		#output prompt for the user
		li $v0, 4		#load string to be printed
		la $a0, squareOutMsg	#load prompt
		syscall			#outputs string
		#output prompt for the user
		li $v0, 2		#load string to be printed
		l.s $f0, squareArea
		mov.s $f12, $f0		# Move contents of register $f1 to register $f12
		syscall			#outputs string
		
		#output newline
		li $v0, 4		#load string to be printed
		la $a0, feetUnit	#load prompt
		syscall			#outputs string
		
		#output prompt for the user
		li $v0, 4		#load string to be printed
		la $a0, totalOutMsg	#load prompt
		syscall			#outputs string
		#output prompt for the user
		li $v0, 2		#load string to be printed
		l.s $f0, totalArea
		mov.s $f12, $f0		# Move contents of register $f1 to register $f12
		syscall			#outputs string
		
		#output newline
		li $v0, 4		#load string to be printed
		la $a0, feetUnit	#load prompt
		syscall			#outputs string
		
		#output newline
		li $v0, 4		#load string to be printed
		la $a0, newline		#load prompt
		syscall			#outputs string
		
		jr $ra			#jump out of function
		
		
	getAreas:
		#get area of round pizzas
		lw $t0, roundInput	#load roundInput
		mtc1 $t0, $f0
		cvt.s.w $f0, $f0	#convert to float
		l.s $f1 roundPizza	#load output var
		mul.s $f2, $f0, $f1	#multiply areas
		lw $t0, squareFeet	#load roundInput
		mtc1 $t0, $f0
		cvt.s.w $f0, $f0	#convert to float
		div.s $f2, $f2, $f0	#divide into feet
		s.s $f2, roundArea	#store round area into var
		
		#get area of square pizzas
		lw $t0, squareInput	#load roundInput
		mtc1 $t0, $f0
		cvt.s.w $f0, $f0	#convert to float
		lw $t1, squarePizza	#load roundInput
		mtc1 $t1, $f1
		cvt.s.w $f1, $f1	#convert to float
		mul.s $f2, $f0, $f1	#multiply areas
		lw $t0, squareFeet	#load roundInput
		mtc1 $t0, $f0
		cvt.s.w $f0, $f0	#convert to float
		div.s $f2, $f2, $f0	#divide into feet
		s.s $f2, squareArea	#store square area into var
		
		#get total areas
		l.s $f0, roundArea	#load round area
		l.s $f1, squareArea	#load square area
		add.s $f2, $f1, $f0	#add areas
		s.s $f2, totalArea	#store total area
		
		lw $t0, roundInput	#load roundInput
		lw $t1, squareInput	#load roundInput
		add $t2, $t0, $t1	#add total num of pizzas
		sw $t2, pizzaSold	#pizzas sold
		
		jr $ra			#jump out of function
		
	checkGoal:
		lw $t0, goalInput	#load roundInput
		lw $t1, pizzaSold	#load roundInput
		
		blt $t1, $t0, goalMissed
		bge $t1, $t0, goalReached
		
		jr $ra			#jump out of function
	
	goalMissed:
		#output prompt for the user
		li $v0, 4		#load string to be printed
		la $a0, goalMissedMsg	#load prompt
		syscall			#outputs string
		
		jr $ra
		
	goalReached:
		#output prompt for the user
		li $v0, 4		#load string to be printed
		la $a0, goalReachedMsg	#load prompt
		syscall			#outputs string
		
		jr $ra