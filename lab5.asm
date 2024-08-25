.data
x_string:  .space 40
y_string:  .space 40
in_prompt: .asciiz "Input the y string (max 40 characters) and then press enter: "
length_message: .asciiz "The length of the string is: "
out_message: .asciiz "\nThis is the content of x string after copying: "

.text
main:
    # Print the input prompt
    li $v0, 4
    la $a0, in_prompt #load address of inpromt
    syscall #syscall for print 
    
    # Read y string from the user using syscall
    li $v0, 8  #load immediate value of 8 into v0 for reading string
    la $a0, y_string # load address of the y string 
    li $a1, 40 #a1 = 40
    syscall 

  ### Calcualte length of y string.### 
### You have use a loop. Count the total no of cahracters until you find 0 in the string that incdicates the null terminator###
### Note, you need to use lbu for loading a Byte. ###
### Also, to access the next character in memory, increment the Byte number by 1 unlike array of words where you incremented by 4###


    
calculateY: 
    lbu $t0, y_string($s0) # Load byte from ystring to t0 at s0 element
    beqz $t0, output          #  (branch if equal 0 ) go to output
    addi $s0, $s0, 1       # Increment counter
    j calculateY
output:
    # Output the message for showing length
    li $v0, 4 #code 4 for string 
    la $a0, length_message #load length message  a0
    syscall

### Output the length of the string. Before printing, subtract 1 from the length as we do not want to count the newline character.###

    addi $s0, $s0, -1      # Subtract 1 from length
    li $v0, 1 # 
    move $a0, $s0 #move s0 to a0
    syscall

    # Load the base addresses of the strings to a0 and a1 for the procedure call a0 for x and a1 for y### 
    la $a0, x_string 
    la $a1, y_string
    
    jal strcpy

    # Output the message for showing the x string
    li $v0, 4
    la $a0, out_message
    syscall

    # Output x string
    li $v0, 4
    la $a0, x_string
    syscall

    j exit

# strcpy contains the code for copying y_string to x_string
# Base addresses of x_string and y_string are in $a0 and $a1 respectively    

strcpy:
    addi $sp, $sp, -4      # Adjust stack for 1 item
    sw   $s0, 0($sp)       # Save $s0
    add  $s0, $zero, $zero # i = 0
L3: add  $t1, $s0, $a1     # Address of y[i] in $t1
    lbu  $t2, 0($t1)       # $t2 = y[i]
    add  $t3, $s0, $a0     # Address of x[i] in $t3
    sb   $t2, 0($t3)       # x[i] = y[i]
    beq  $t2, $zero, L4    # Exit loop if y[i] == 0  
    addi $s0, $s0, 1       # i = i + 1
    j    L3                # Next iteration of loop
L4: lw   $s0, 0($sp)       # Restore saved $s0
    addi $sp, $sp, 4       # Pop 1 item from stack
    jr   $ra               

exit:
    li $v0, 10
    syscall
