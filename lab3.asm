.text
main:
	# Print input prompt
	li	$v0, 4          # syscall code = 4 for printing a string
	la	$a0, in_prompt  # assign the prompt string to a0 for printing

	syscall

	# Read the value of n from user and save to $s0
	li	$v0, 5          # syscall code = 5 for reading an integer from user to v0
	syscall
	
	
	
	##
	move $s0, $v0        # ### Set s0 with the user input & if invalid (<=2) jumpt to exit_error ###
	bge $s0, 3, input_valid
	j exit_error
        ##
        
        ##
input_valid:
### Set proper argument register and call the procedure print_numnber to show the first two numbers of the sequence (0 & 1)###

	move $a0, $zero      # Set $a0 with 0
	move $a1, $s1        # Set $a1 with 1
	jal print_number       #ptint
	
	##
	li $t0, 2           # Initialize counter register t0

	# Load the first two numbers (0 & 1) to $s1 & $s2
	##
	li $s1, 0            # Load 0 to $s1
	li $s2, 1            # Load 1 to $s2
	##
loop:
	##
### set the argument registers (a0 and a1) to the last two values in the sequence for addition, and then call proedure add_two###
	move $a0, $s1        # a0 stores last value in sequence
	move $a1, $s2        #  $a1 stores addition result

	# Call procedure add_two
	jal add_two          # Call add_two
	##

	# Update sequence values
	move $s1, $s2        # $s1 now stores the last value in the sequence
	move $s2, $v0        # $s2 now stores the new value as returned from the addition procedure
	move $a0, $v0        # Update $a0 for printing the returned value

	# Call print_number
	jal print_number

	##
	# Increment the counter and compare it with user input. If equal, jump to exit.
	addi $t0, $t0, 1     #increment
	bne $t0, $s0, loop   # not equal go to loop
	j exit               # If equal exit
	##
add_two:
	##
	# Push the value of $s0 in the stack
	
	sw $s0, 0($sp)       # push s0 on stack


	add $s0, $a0, $a1    # $s0 now holds the result of the addition
##
	# Set the register that will hold the return value with the result of the addition
	move $v0, $s0 #v0 holds value of s0

	# Pop the value of $s0 from the stack
	lw $s0, 0($sp)       # Load $s0 from the top of the stack
	

	jr $ra               # Return to the caller

# Segment for printing an integer
print_number:



	# Write the syscall code for printing the integer
	li	$v0, 1
	syscall
	
	
	
	
	
	
	
	

	# syscall for printing a space character
	li	$v0, 4
	la	$a0, space
	syscall
	
	
	
	jr $ra               # Return to the caller

# Exit block for wrong value of the input
exit_error:
	li	$v0, 4            # syscall code = 4 for printing the error message
	la	$a0, error_string
	syscall
	li	$v0, 10           # syscall code = 10 for terminate the execution of the program
	syscall

# Exit block for the program
exit:
	li	$v0, 10           # syscall code = 10 for terminate the execution of the program
	syscall

.data
in_prompt:	.asciiz	"how many numbers in the sequence you want to see (must be at least 3):  "
error_string:	.asciiz "The number must be greater than or equal to 3"
space:		.asciiz "  "
num:		.asciiz "0 1"
