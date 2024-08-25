.data
myArray: .space 20    ### Declare myArray, an array of length 20 and initialize with 0. ###
input: .asciiz "Enter an integer: "
space: .asciiz " "
sorted: .asciiz " Sorted array output: "
.text
main:
    # call the procedure for reading the array ###
    la $a0, myArray        # Load address of array into $a0
    jal read_array         # Call read_array procedure
    move $s0, $v0          # Save array from $v0 to $s0

    # Assign appropriate values to a0 and a1 for the sort procedure ###
    la $a0, myArray        # Load array adress into $a0
    move $a1, $s0          # move from a1 to s0

    # call the sort procedure ###
    jal sort              

    # move s0 to a1. a1 will be used by the print_array procedure
    move $a1, $s0         

    # call the print_array procedure
    jal print_array      

    j exit                 # Jump to exit
read_array:
    ### Read value of n and then read n integers to myArray. Use appropriate input prompts ###
    li $v0, 4               #  syscall printing string
    la $a0, myArray         # Load address for array
    syscall                 # Print 

    ### Read integer  ###
    li $v0, 5               # syscall for reading integer
    syscall                 # Read integer


    ### Create a while loop to read n integers ###
    li $t1, 0               # t1 = 0

loop:
    li $v0, 4               #  syscall print string
    la $a0, input           # load input string
    syscall                 # Print 


    li $v0, 5               # syscall for integer
    syscall                 # Read integer

    addi $t1, $t1, 1        # Increment 




sort:    # Two arguments: a0 for the starting address of the array; a1 is the number of integers
	addi $sp,$sp,-20      # make room on stack for 5 registers
        sw $ra, 16($sp)        # save $ra on stack
        sw $s3,12($sp)         # save $s3 on stack
        sw $s2, 8($sp)         # save $s2 on stack
        sw $s1, 4($sp)         # save $s1 on stack
	sw $s0, 0($sp)         # save $s0 on stack
        move $s2, $a0           # save $a0 into $s2
        move $s3, $a1           # save $a1 into $s3
        move $s0, $zero         # i = 0
for1tst: 
	slt  $t0, $s0, $s3      # $t0 = 0 if $s0 ≥ $s3 (i ≥ n)
        beq  $t0, $zero, exit1  # go to exit1 if $s0 ≥ $s3 (i ≥ n)
        addi $s1, $s0,-1       # j = i – 1
for2tst:
	slti $t0, $s1, 0        # $t0 = 1 if $s1 < 0 (j < 0)
        bne  $t0, $zero, exit2  # go to exit2 if $s1 < 0 (j < 0)
        sll  $t1, $s1, 2        # $t1 = j * 4
        add  $t2, $s2, $t1      # $t2 = v + (j * 4)
        lw   $t3, 0($t2)        # $t3 = v[j]
        lw   $t4, 4($t2)        # $t4 = v[j + 1]
        slt  $t0, $t4, $t3      # $t0 = 0 if $t4 ≥ $t3
        beq  $t0, $zero, exit2  # go to exit2 if $t4 ≥ $t3
        move $a0, $s2           # 1st param of swap is v (old $a0)
        move $a1, $s1           # 2nd param of swap is j
        jal  swap               # call swap procedure
        addi $s1, $s1,-1      # j –= 1
        j    for2tst            # jump to test of inner loop
exit2:  
	addi $s0, $s0, 1        # i += 1
        j    for1tst            # jump to test of outer loop
exit1: 
	lw $s0, 0($sp)  # restore $s0 from stack
        lw $s1, 4($sp)         # restore $s1 from stack
        lw $s2, 8($sp)         # restore $s2 from stack
        lw $s3,12($sp)         # restore $s3 from stack
        lw $ra,16($sp)         # restore $ra from stack
        addi $sp,$sp, 20       # restore stack pointer
        jr $ra                 # return to calling routine
swap: 
	sll $t1, $a1, 2   # $t1 = k * 4
      	add $t1, $a0, $t1 # $t1 = v+(k*4) (address of v[k])
	lw $t0, 0($t1)    # $t0 (temp) = v[k]
	lw $t2, 4($t1)    # $t2 = v[k+1]
        sw $t2, 0($t1)    # v[k] = $t2 (v[k+1])
        sw $t0, 4($t1)    # v[k+1] = $t0 (temp)
        jr $ra            # return to calling routine


print_array:
    ### print the sorted array, myArray. The size of the array will be in a1. Use appropriate output text. ###
    

    li $v0, 4                # Load syscall code for printing string
    la $a0, sorted           # load sorted output prompt
    syscall                  # Print



exit:
	li $v0, 10
	syscall