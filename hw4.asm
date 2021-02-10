#Michael Petrey
#mdp180000


.data
	#Vars for opcode
	userInput:	.space 	8			#Variable for input value of 8 characters
	opcode:		.space	2
	rs:		.space 	2
	rt:		.space	2
	immediate:	.space	4
	
	#Binary string
	binary:		.space 	32
	zeroVal:	.asciiz "0"
	oneVal:		.asciiz	"1"
	
	#output messeges to user
	inputPrompt:	.asciiz "MIPS instruction: "	#ask for prompt
	newline:	.asciiz "\n"
	endmssg:	.asciiz "end \n"
	invalidMsg:	.asciiz "One of the characters is invalid \n"
	shortMsg:	.asciiz	"The input is too short \n"
	longMsg:	.asciiz	"The input is too long \n"
	instMsg:	.asciiz "Instruction format: "
	opMsg:		.asciiz "Opcode:"
	RsMsg:		.asciiz	"Rs: "
	RtMsg:		.asciiz	"Rt: "
	ImmMsg:		.asciiz	"Imm: "
	
	
	
	#look up the hex value for an ascii character by offset
	decimalInput:	.word 	32
	hexvals: 	.word 	0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 0, 0, 0, 0, 0, 0,
               			10, 11, 12, 13, 14, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
               			10, 11, 12, 13, 14, 15
	

.globl main
.text 
	main:
		#output prompt for the user
		li $v0, 4		#load string to be printed
		la $a0, inputPrompt	#load prompt
		syscall			#outputs string
		
		#input of machine code
		li $v0, 8		#load string to be read
		la $a0, userInput	#load userInput
		li $a1, 9		#max num of chars in string
		syscall 		#read input
		
		#output newline
		li $v0, 4		#load string to be printed
		la $a0, newline		#load prompt
		syscall			#outputs string
		
		la $t0, userInput	#load userinput
		lb $t1, 0($t0)		#load char
		beq $t1, 10, endPrgm	#checks if string is empty
		la $t1, 0		#reset $t1 var
		la $t2, 0		#counter for the loop
		
	loop:
		addi $t2, $t2, 1	#increment counter of the loop
		
		#examine chars
		lb $t1, 0($t0)		#load char
		beq $t1, $zero, exit	#check if empty
		
		move $a0, $t1		#sets a0 to first char
		jal validChar		#checks if char is a valid character
		
		beq $v0, 1,continue	#iterates if true
		beq $v0, 0,exit		#exits if found one invalid
		
	continue:
		addi $t0, $t0, 1	#increment counter
		j loop			#start of the loop
		
	exit:
		
		#output newline
		li $v0, 4		#load string to be printed
		la $a0, newline		#load prompt
		syscall			#outputs string
		
		blt  $t2, 9, outputShort
		bgt  $t1, 9, outputLong
		
		jal hexToDecimal
		sw $v0, decimalInput
		
		jal decToBin
		
		jal printOutput
		
		#syscall to end program
		li $v0 10
		syscall	

	validChar:
		li $v0,	 0		#true false val
		blt $a0, 48, isFalse	#invalid ascii value below '0'
		ble $a0, 57, isTrue	#valid ascii value of digit value (0-9)
		blt $a0, 65, isFalse	#invalid ascii values before 'A'
		ble $a0, 70, isTrue	#valid ascii value (A-F)
		blt $a0, 97, isFalse	#invalid ascii values before 'a'
		ble $a0, 102, isTrue	#valid ascii value (a-f)
		
		beq $v0, 0, isFalse	#sets v0 to false if none other functions apply
		
		jr $ra			#jump out of function

	isFalse:
		li $v0, 4
		la $a0, invalidMsg	#output that it is a lower digit
		syscall
		
		li $v0, 0		#sets to false
		jr $ra			#jump out of function
		
	isTrue:
		li $v0, 1		#sets to true
		jr $ra			#jump out of function
		
		
	endPrgm:
		#output if digit
		li $v0, 4		#prompts syscall for string
		la $a0, endmssg		#tells user the error
		syscall			#outputs message
	
		#syscall to end program
		li $v0 10
		syscall	
		
	outputLong:
		li $v0, 4		#prompts syscall for string
		la $a0, longMsg		#tells user the error
		syscall			#outputs message
		
		jal main		#restart program
		
	outputShort:
		li $v0, 4		#prompts syscall for string
		la $a0, shortMsg	#tells user the error
		syscall			#outputs message
		
		jal main		#restart program
		
	
	#converts hex string to int
	hexToDecimal:
		li      $v0, 0                  # Reset accumulator to 0.
		la      $t0, hexvals            # Load address of lookup into register.
		la 	$a0, userInput
	hexLoop:
		lb      $t1, 0($a0)             # Load a character,
		beq     $t1, $zero, endHex      # if it is null then return.
		sll     $v0, $v0, 4             # Otherwise first shift accumulator by 4 to multiply by 16.
		addi    $t2, $t1, -48           # Then find the offset of the char from '0'
		sll     $t2, $t2, 2             # in bytes,
		addu    $t2, $t2, $t0           # use it to calcute address in lookup,
		lw      $t3, 0($t2)             # retrieve its integer value,
		addu    $v0, $v0, $t3           # and add that to the accumulator.
		addi    $a0, $a0, 1             # Finally, increment the pointer
		j       hexLoop                 # and loop.
	endHex:
		jr $ra
		
		
	decToBin:
		lw $s0,decimalInput                    #s0 = x 
		addiu $t0,$zero,31          #(t0) i == 31 (the counter) 
		li $t1,1                    #(t1) mask 
		sll $t1,$t1,31            
		li $v0,1                    #prepare system call for printing values 
     
		
		la $s1, binary  
		la $s2, zeroVal  
		la $s3, oneVal  
     
	decLoop: 
		beq $t0,-1,decEnd	#if t0 == -1 exit loop 
		and $t3,$s0,$t1		#isolate the bit 
		beq $t0,$0,decCont	#shift is needed only if t0 > 0 
		srlv $t3,$t3,$t0	#right shift before display 
	decCont: 
		move $a0,$t3		#prepare bit for print 
		syscall			#print bit 
     
		subi $t0, $t0, 1	#decrease the counter 
		srl $t1,$t1, 1		#right shift the mask 
		j decLoop 
	decEnd: 
		#output newline
		li $v0, 4		#load string to be printed
		la $a0, newline		#load prompt
		syscall			#outputs string
		
		jr $ra
		
	
	printOutput:
		li $v0, 4		#load string to be printed
		la $a0, instMsg		#load message
		syscall			#outputs string
		
		#output newline
		li $v0, 4		#load string to be printed
		la $a0, newline		#load prompt
		syscall			#outputs string
		
		li $v0, 4		#load string to be printed
		la $a0, opMsg		#load message
		syscall			#outputs string
		
		#output newline
		li $v0, 4		#load string to be printed
		la $a0, newline		#load prompt
		syscall			#outputs string
		
		li $v0, 4		#load string to be printed
		la $a0, RtMsg		#load message
		syscall			#outputs string
		
		#output newline
		li $v0, 4		#load string to be printed
		la $a0, newline		#load prompt
		syscall			#outputs string
		
		li $v0, 4		#load string to be printed
		la $a0, RsMsg		#load message
		syscall			#outputs string
		
		#output newline
		li $v0, 4		#load string to be printed
		la $a0, newline		#load prompt
		syscall			#outputs string
		
		li $v0, 4		#load string to be printed
		la $a0, ImmMsg		#load message
		syscall			#outputs string
		
		#output newline
		li $v0, 4		#load string to be printed
		la $a0, newline		#load prompt
		syscall			#outputs string