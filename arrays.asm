
  .data
array: .word 1, 3, 5, 7, 9, 2, 4, 6, 8, 10 # array elements
maxArray: .word 10 #max element array value 10
minArray: .word  1 #min element array value 1
arrayTotal: .asciiz "Array total sum is: \n"   #print statement
differenceTotal: .asciiz " Difference total \n" #print statement
mulResult: .asciiz " Multiplcation Result: \n" #print statement

.text
main:
    la $t0, array  # Load array address
    li $t1, 0      # t1 = 0
    li $t2, 0      # t2 = 0

	
loop:
    lw $t3, 0($t0)   # Load current element in array to $t3
    add $t2, $t2, $t3  # t2 = t2 + t3

    addi $t0, $t0, 4  # increment by 4 bytes to move in the array
    addi $t1, $t1, 1  # Increase value of counter by 1

    beq $t1, 10, multiply  # If counter is at 10, go to multiply
    j loop
   

#leaf procedure
multiply:

    sw   $t3, 4($sp) # t3 being saved on stack
    sw   $t4, 0($sp) # t4 being saved on stack

    li   $t3, 5          # t3 = 5
    li   $t4, 5          # t4 = 5
    #procedure body
    mul  $t5, $t3, $t4     # t3 * t4 saved in t5 


    lw   $t4, 0($sp)     #restore t4 from stack
    lw   $t3, 4($sp)     #restore t3 from stack
    jr $ra               #return
   
  
#non leaf procedure
add5ToResult:
    jal multiply        #recersive call
# Add 5 to the multiplication result
    addi $t5, $t5, 5 # increase value in t5 by 5 so now its 30
   
    li $v0, 1            # print integer result
    move $a0, $t5        # move updated result to $a0
    syscall
    
    #result
    # Print string
    li $v0, 4            # print output string
    la $a0, mulResult    # load address string (mulResult) in output
    syscall
 
findMazArray:
    la $t0, array  # Load array address
    lw $t0, maxArray #load array max value 

    
findMinArray:
    la $t0, array #load array address
    lw $t1, minArray #load array min value
   
difference:
  
    lw $t0, maxArray       # $t0 = 10 because maxArray value is 10
    lw $t1, minArray        # $t1 = 1 because minArray value is 1

    #Subtract $t1 - $t0 and stotes result in $a0
    sub $a0, $t0, $t1

    # Print result
    li $v0, 1        # syscall code 1 for print result in integer
    syscall
    
    li $v0, 4         # print string result code 4
    la $a0, differenceTotal  
    syscall
    
    
exit: 
    # Print string for array sum
    li $v0, 4         # print string output code 4
    la $a0, arrayTotal  #load address (arrayTotal) in a0
    syscall
    
    # Print the total
    li $v0, 1         # print integer  code 1
    move $a0, $t2      # move total from t2 to a0
    syscall
    
    
    li $v0, 10     # close program code 10
    syscall

